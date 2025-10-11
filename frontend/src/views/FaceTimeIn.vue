<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
          <div class="logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ion-padding camera-page">
      <div class="camera-container">
        <div class="video-wrapper">
          <div class="video-frame-wrapper" ref="frameWrapper">
            <video ref="video" autoplay muted playsinline class="video-frame"></video>
            <canvas ref="overlayCanvas" class="overlay-canvas"></canvas>
            <canvas ref="progressCanvas" class="progress-ring"></canvas>
          </div>

          <p class="instruction" v-if="step === 'running'">
            Follow the instructions: <strong>{{ promptText }}</strong>
          </p>
        </div>

        <!-- <transition name="fade">
          <div v-if="step === 'verified'" class="step-message success">
            <ion-icon name="checkmark-circle-outline" class="success-icon"></ion-icon>
            <h2>Verified!</h2>
            <p>Attendance recorded successfully.</p>
          </div>
        </transition> -->

        <transition name="fade">
          <div v-if="step === 'failed'" class="step-message error">
            <ion-icon name="close-circle-outline" class="error-icon"></ion-icon>
            <h2>Verification Failed</h2>
            <p>Please retry and ensure good lighting and follow prompts.</p>
            <ion-button expand="block" color="primary" @click="start">Retry</ion-button>
          </div>
        </transition>
      </div>
    </ion-content>
    <!-- Footer -->
    <div class="footer">
      <div class="footer-icons">
        <ion-icon name="home" @click="goTo('/')"></ion-icon>
        <ion-icon name="calendar" @click="goTo('/calendar')"></ion-icon>
        <ion-icon name="scan" @click="goTo('/scanner')"></ion-icon>
        <ion-icon name="notifications" @click="goTo('/notifications')"></ion-icon>
        <ion-icon name="person" @click="goTo('/profile')"></ion-icon>
      </div>
      <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
    </div>
  </ion-page>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, nextTick, watch } from 'vue';
import Swal from 'sweetalert2';
import * as faceapi from 'face-api.js';
import { useRoute } from 'vue-router';

// ----- student info -----
const student = JSON.parse(localStorage.getItem('student')) || {};
const studentId = student?.student_id || localStorage.getItem('student_id') || null;

// ----- route & event info -----
const route = useRoute();
let eventId = route.query.event || localStorage.getItem('eventId');
const action = route.query.action || null;

// Watch for route changes in case query updates
watch(() => route.query.event, (newEvent) => {
  if (newEvent) eventId = newEvent;
});

// ----- refs -----
const video = ref(null);
const overlayCanvas = ref(null);
const progressCanvas = ref(null);
const frameWrapper = ref(null);

// ----- state -----
let stream = null;
let rafId = null;
let detectLoopRunning = false;
let neutralVerticalRatio = 0;

const step = ref('start'); // 'start' | 'running' | 'verified' | 'failed'
const sequence = ref([]);
const actionIndex = ref(0);
const promptText = ref('');
const requiredFrames = 3;
const actionMaxDuration = 3000; // 3 seconds
let consecutiveCount = 0;
let actionPerformed = false;

// ----- actions -----
const ACTIONS = ['smile', 'turn_left', 'turn_right', 'tilt_up'];

// ----- helpers -----
const buildRandomSequence = (n = 3) => {
  const seq = [];
  while (seq.length < n) {
    const a = ACTIONS[Math.floor(Math.random() * ACTIONS.length)];
    if (seq.length === 0 || seq[seq.length - 1] !== a) seq.push(a);
  }
  return seq;
};

const mouthRatio = (mouth) => {
  const width = Math.hypot(mouth[6].x - mouth[0].x, mouth[6].y - mouth[0].y);
  const height = Math.hypot(mouth[3].x - mouth[9].x, mouth[3].y - mouth[9].y);
  return height / width;
};

const estimateHeadYaw = (landmarks) => {
  const nose = landmarks.getNose();
  const leftEye = landmarks.getLeftEye();
  const rightEye = landmarks.getRightEye();
  const noseCenter = { x: nose.reduce((s, p) => s + p.x, 0) / nose.length, y: nose.reduce((s, p) => s + p.y, 0) / nose.length };
  const leftCenter = { x: leftEye.reduce((s, p) => s + p.x, 0) / leftEye.length, y: leftEye.reduce((s, p) => s + p.y, 0) / leftEye.length };
  const rightCenter = { x: rightEye.reduce((s, p) => s + p.x, 0) / rightEye.length, y: rightEye.reduce((s, p) => s + p.y, 0) / rightEye.length };
  const distLeft = Math.hypot(noseCenter.x - leftCenter.x, noseCenter.y - leftCenter.y);
  const distRight = Math.hypot(noseCenter.x - rightCenter.x, noseCenter.y - rightCenter.y);
  return (distLeft - distRight) / (distLeft + distRight);
};

const drawBox = (ctx, box, color = '#00C6FF') => {
  ctx.strokeStyle = color;
  ctx.lineWidth = 2;
  ctx.strokeRect(box.x, box.y, box.width, box.height);
};

const clearOverlay = (ctx) => ctx.clearRect(0, 0, overlayCanvas.value.width, overlayCanvas.value.height);

const drawProgressRing = (pct) => {
  const canvas = progressCanvas.value;
  const wrapper = frameWrapper.value;
  const size = Math.min(wrapper.clientWidth, wrapper.clientHeight);
  const dpr = window.devicePixelRatio || 1;
  canvas.width = size * dpr;
  canvas.height = size * dpr;
  canvas.style.width = size + 'px';
  canvas.style.height = size + 'px';
  const ctx = canvas.getContext('2d');
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  const radius = (size / 2) - 12;
  const centerX = size / 2;
  const centerY = size / 2;
  ctx.clearRect(0, 0, size, size);

  ctx.beginPath();
  ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
  ctx.strokeStyle = '#333';
  ctx.lineWidth = 8;
  ctx.stroke();

  const end = (-Math.PI / 2) + (Math.PI * 2 * (pct / 100));
  ctx.beginPath();
  ctx.arc(centerX, centerY, radius, -Math.PI / 2, end, false);
  ctx.strokeStyle = '#00C6FF';
  ctx.lineWidth = 8;
  ctx.lineCap = 'round';
  ctx.stroke();
};

const humanizeAction = (a) => {
  if (a === 'smile') return 'smile 😊';
  if (a === 'turn_left') return 'turn your head left';
  if (a === 'turn_right') return 'turn your head right';
  if (a === 'tilt_up') return 'look up';
  return a;
};

// ----- detection loop -----
const startDetection = async () => {
  if (detectLoopRunning) return;
  detectLoopRunning = true;
  const overlayCtx = overlayCanvas.value.getContext('2d');
  overlayCanvas.value.width = video.value.videoWidth;
  overlayCanvas.value.height = video.value.videoHeight;
  drawProgressRing(0);

  const tinyOptions = new faceapi.TinyFaceDetectorOptions({ inputSize: 320, scoreThreshold: 0.5 });

  // Capture neutral vertical ratio
  const captureNeutral = async () => {
    const detection = await faceapi.detectSingleFace(video.value, tinyOptions).withFaceLandmarks();
    if (detection) {
      const nose = detection.landmarks.getNose();
      const eyes = [...detection.landmarks.getLeftEye(), ...detection.landmarks.getRightEye()];
      const noseY = nose.reduce((s, p) => s + p.y, 0) / nose.length;
      const eyesY = eyes.reduce((s, p) => s + p.y, 0) / eyes.length;
      neutralVerticalRatio = (noseY - eyesY) / overlayCanvas.value.height;
    } else {
      setTimeout(captureNeutral, 100);
    }
  };
  await captureNeutral();

  consecutiveCount = 0;
  actionPerformed = false;
  const startTime = Date.now();
  const currentAction = sequence.value[actionIndex.value];

  const loop = async () => {
    if (!video.value || video.value.paused || video.value.ended) {
      rafId = requestAnimationFrame(loop);
      return;
    }

    const detection = await faceapi.detectSingleFace(video.value, tinyOptions).withFaceLandmarks();
    clearOverlay(overlayCtx);

    let detected = false;
    if (detection) {
      const landmarks = detection.landmarks;
      const nose = landmarks.getNose();
      const eyes = [...landmarks.getLeftEye(), ...landmarks.getRightEye()];
      const noseY = nose.reduce((s, p) => s + p.y, 0) / nose.length;
      const eyesY = eyes.reduce((s, p) => s + p.y, 0) / eyes.length;
      const verticalRatio = (noseY - eyesY) / overlayCanvas.value.height;
      const lookUpThreshold = neutralVerticalRatio - 0.03;

      if (currentAction === 'smile' && mouthRatio(landmarks.getMouth()) > 0.25) detected = true;
      else if (currentAction === 'turn_left' && estimateHeadYaw(landmarks) < -0.12) detected = true;
      else if (currentAction === 'turn_right' && estimateHeadYaw(landmarks) > 0.12) detected = true;
      else if (currentAction === 'tilt_up' && verticalRatio < lookUpThreshold) detected = true;

      drawBox(overlayCtx, detection.detection.box, detected ? '#00FF00' : '#FF4444');
    }

    const elapsed = Date.now() - startTime;
    drawProgressRing(Math.min(100, (elapsed / actionMaxDuration) * 100));

    if (detected && !actionPerformed) {
      actionPerformed = true;
      actionIndex.value++;
      detectLoopRunning = false;

      if (actionIndex.value >= sequence.value.length) {
        await performFinalCaptureAndVerify();
        return;
      } else {
        promptText.value = humanizeAction(sequence.value[actionIndex.value]);
        setTimeout(() => startDetection(), 200);
        return;
      }
    }

    if (elapsed >= actionMaxDuration && !actionPerformed) {
      detectLoopRunning = false;
      await Swal.fire({
        title: 'Action Failed ❌',
        text: `You did not complete: ${humanizeAction(currentAction)}\nPlease try a new sequence`,
        icon: 'warning',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
      sequence.value = buildRandomSequence(3);
      actionIndex.value = 0;
      actionPerformed = false;
      promptText.value = humanizeAction(sequence.value[0]);
      setTimeout(() => startDetection(), 200);
      return;
    }

    rafId = requestAnimationFrame(loop);
  };

  rafId = requestAnimationFrame(loop);
};

const goTo = (url) => {
  stopAll(); // Stop camera and loop
  window.location.href = url; // Full page reload
};

// ----- final capture & verify -----
const performFinalCaptureAndVerify = async () => {
  step.value = 'running';
  const cap = document.createElement('canvas');
  cap.width = video.value.videoWidth;
  cap.height = video.value.videoHeight;
  cap.getContext('2d').drawImage(video.value, 0, 0, cap.width, cap.height);
  const imgBase64 = cap.toDataURL('image/jpeg', 0.9).split(',')[1];

  try {
    // Verify face
    const res = await fetch('http://localhost:5000/api/face/verify', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ studentId, image_base64: imgBase64 })
    });
    const data = await res.json();

    if (res.ok && data.verified) {
      step.value = 'verified';

      if (!eventId) {
        await Swal.fire({
          title: 'Error',
          text: 'Event ID not found. Attendance cannot be recorded.',
          icon: 'error'
        });
        stopAll();
        return;
      }

      // --- Create or Update Attendance based on action ---
      const apiBase = 'http://localhost:5000/api/attendance';
      let apiUrl = '';
      let method = 'PUT';

      // Determine API endpoint based on action
      switch(action) {
        case 'morning_timein':
          apiUrl = `${apiBase}/${eventId}/timein`;
          break;
        case 'morning_trivia':
          apiUrl = `${apiBase}/${eventId}/trivia-timein`;
          break;
        case 'morning_timeout':
          apiUrl = `${apiBase}/${eventId}/timeout`;
          break;
        case 'afternoon_timein':
          apiUrl = `${apiBase}/${eventId}/afternoon-timein`;
          break;
        case 'afternoon_trivia':
          apiUrl = `${apiBase}/${eventId}/afternoon-trivia`;
          break;
        case 'afternoon_timeout':
          apiUrl = `${apiBase}/${eventId}/afternoon-timeout`;
          break;
        default:
          apiUrl = '';
      }

      // First ensure a general attendance record exists
      await fetch(apiBase, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({ studentId, eventId })
      });

      // Then update the specific action column
      if (apiUrl) {
        const res2 = await fetch(apiUrl, {
          method,
          headers: { 'Content-Type': 'application/json' },
          credentials: 'include',
          body: JSON.stringify({ studentId })
        });
        const result2 = await res2.json();
        if (!res2.ok) throw new Error(result2.error || 'Failed to record attendance');
      }
      await Swal.fire({
        icon: 'success',
        title: 'Verified ✅',
        text: 'Attendance recorded successfully',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      }).then(() => {
        window.location.replace(`http://localhost:8100/event-attendance?event=${eventId}`);
      });

      stopAll();

    } else {
      step.value = 'failed';
      await Swal.fire({
        title: 'Verification Failed ❌',
        text: `Confidence: ${data.confidence ?? 0}`,
        icon: 'error',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
      stopAll();
    }
  } catch (err) {
    step.value = 'failed';
    await Swal.fire({
      icon: 'error',
      title: 'Error',
      text: err.message,
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
    stopAll();
  }
};


// ----- start / stop -----
const start = async () => {
  actionIndex.value = 0;
  consecutiveCount = 0;
  actionPerformed = false;
  step.value = 'start';
  sequence.value = buildRandomSequence(3);
  promptText.value = humanizeAction(sequence.value[0]);

  await Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri('/models'),
    faceapi.nets.faceLandmark68Net.loadFromUri('/models')
  ]);

  try {
    stream = await navigator.mediaDevices.getUserMedia({ video: { width: 640, height: 480 } });
    video.value.srcObject = stream;
    await nextTick();
    overlayCanvas.value.width = video.value.videoWidth;
    overlayCanvas.value.height = video.value.videoHeight;
    drawProgressRing(0);
    step.value = 'running';
    setTimeout(() => startDetection(), 600);
  } catch (err) {
    await Swal.fire({ title: 'Camera Error', text: err.message, icon: 'error' });
  }
};

const stopAll = () => {
  detectLoopRunning = false;
  if (rafId) cancelAnimationFrame(rafId);
  if (stream) {
    stream.getTracks().forEach(t => t.stop());
    stream = null;
  }
};

onMounted(() => start());
onBeforeUnmount(() => stopAll());
</script>

<style scoped>
.camera-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  margin-top: -80px;
}
.camera-page { --background: linear-gradient(145deg, #0a0c2b 0%, #1e2a78 100%); color: white; text-align: center; display: flex; align-items: center; justify-content: center; }
.header-toolbar { background: #0a0c2b; }
.video-frame-wrapper { position: relative; display: inline-block; width: 320px; height: 320px; border-radius: 50%; overflow: hidden; background: #000; }
.video-frame { width: 100%; height: 100%; object-fit: cover; display: block; transform: scaleX(-1); }
.overlay-canvas, .progress-ring { position: absolute; top: 0; left: 0; pointer-events: none; width: 100%; height: 100%; }
.instruction { margin-top: 12px; font-weight: 600; }
.status-row { margin-top: 8px; display: flex; gap: 12px; justify-content: center; font-size: 13px; opacity: 0.9; }
.step-message { margin-top: 18px; }
.success h2 { color: #8ef0b7; }
.error h2 { color: #ff9b9b; }
.footer {
  position: fixed;
  bottom: 0;
  width: 100%;
  z-index: 100;
}
.footer-icons {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 10px 0;
  top: -32px;
  width: 100%;
  position: absolute;
}
.footer-icons ion-icon {
  color: #fff;
  cursor: pointer;
  padding: 5px;
  background: #08055e;
  border: 2px solid #fff;
  border-radius: 100%;
  width: 17px;
  height: 17px;
}
.instruction {
  color: #fff;
}
</style>
