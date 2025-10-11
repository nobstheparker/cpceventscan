<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
          <div class="logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <div id="container">
        <div class="form-container">
          <!-- Already Registered Notice -->
          <div v-if="alreadyRegistered" class="step-container">
            <h2>Face Already Registered ✅</h2>
            <p>
              You have already registered your face. To remove or update it,
              please visit the SAO office and request a removal of your face
              verification registration.
            </p>
          </div>

          <!-- Step 1 -->
          <div v-else-if="step === 1" class="step-container">
            <h2>Align your face inside the circle</h2>
            <p>Hold still until progress completes</p>
            <ion-button expand="block" @click="startCamera">Start</ion-button>
          </div>

          <!-- Step 2 -->
          <div v-else-if="step === 2" class="step-container camera-wrapper">
            <video ref="video" autoplay muted playsinline class="video-frame"></video>
            <canvas ref="canvas" class="overlay"></canvas>
            <p>Progress: {{ Math.floor(progress) }}%</p>
          </div>

          <!-- Step 3 -->
          <div v-else-if="step === 3" class="step-container">
            <h2>Confirm Your Face</h2>
            <img :src="capturedImage" class="preview" />
            <ion-button expand="block" color="success" @click="saveFace">Confirm & Save</ion-button>
            <ion-button expand="block" color="medium" @click="retakeFace">Retake</ion-button>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="footer">
        <div class="footer-icons">
          <router-link to="/"><ion-icon name="home"></ion-icon></router-link>
          <router-link to="/calendar"><ion-icon name="calendar"></ion-icon></router-link>
          <router-link to="/scanner"><ion-icon name="scan"></ion-icon></router-link>
          <router-link to="/notifications"><ion-icon name="notifications"></ion-icon></router-link>
          <router-link to="/profile"><ion-icon name="person"  class="active"></ion-icon></router-link>
        </div>
        <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
      </div>
    </ion-content>
  </ion-page>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, nextTick } from 'vue';
import Swal from 'sweetalert2';
import * as faceapi from 'face-api.js';

// ----- student info -----
const student = JSON.parse(localStorage.getItem('student')) || {};
const studentId = student?.student_id || localStorage.getItem('student_id') || null;
const eventId = localStorage.getItem('eventId'); // Make sure eventId is set in localStorage

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
const actionMaxDuration = 3000; // 3 seconds
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

  const currentAction = sequence.value[actionIndex.value];
  let startTime = Date.now();
  actionPerformed = false;

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
      // Action completed
      actionPerformed = true;
      actionIndex.value++;
      detectLoopRunning = false;

      if (actionIndex.value >= sequence.value.length) {
        // All actions done
        await performFinalCaptureAndVerify();
        return;
      } else {
        // Next action
        promptText.value = humanizeAction(sequence.value[actionIndex.value]);
        setTimeout(() => startDetection(), 200);
        return;
      }
    }

    if (elapsed >= actionMaxDuration) {
      detectLoopRunning = false;

      if (!actionPerformed) {
        // Action failed, new sequence
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
        promptText.value = humanizeAction(sequence.value[0]);
        setTimeout(() => startDetection(), 200);
        return;
      } else {
        // proceed to next action
        actionIndex.value++;
        if (actionIndex.value >= sequence.value.length) {
          await performFinalCaptureAndVerify();
          return;
        } else {
          promptText.value = humanizeAction(sequence.value[actionIndex.value]);
          actionPerformed = false;
          startTime = Date.now();
          setTimeout(() => startDetection(), 200);
          return;
        }
      }
    }

    rafId = requestAnimationFrame(loop);
  };

  rafId = requestAnimationFrame(loop);
};

// ----- final capture & verify -----
const performFinalCaptureAndVerify = async () => {
  step.value = 'running';
  const cap = document.createElement('canvas');
  cap.width = video.value.videoWidth;
  cap.height = video.value.videoHeight;
  const cctx = cap.getContext('2d');
  cctx.drawImage(video.value, 0, 0, cap.width, cap.height);
  const imgBase64 = cap.toDataURL('image/jpeg', 0.9).split(',')[1];

  drawProgressRing(0);
  let pct = 0;
  const stepMs = 30;
  const increments = 1600 / stepMs;
  const delta = 100 / increments;

  await new Promise(resolve => {
    const timer = setInterval(() => {
      pct += delta;
      drawProgressRing(Math.min(100, pct));
      if (pct >= 100) {
        clearInterval(timer);
        resolve();
      }
    }, stepMs);
  });

  Swal.fire({
    title: 'Verifying...',
    html: 'Please wait while we check your face',
    allowOutsideClick: false,
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    },
  });

  try {
    const res = await fetch('http://localhost:5000/api/face/verify', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ studentId, image_base64: imgBase64 })
    });
    const data = await res.json();

    if (!res.verified) {
      step.value = 'failed';
      await Swal.fire({
        title: 'Verification Failed ❌',
        text: `Face did not match (distance: ${data.distance?.toFixed(3) || 'N/A'})`,
        icon: 'error',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
      return;
    }

    // ✅ Attendance record
    const apiBase = 'http://localhost:5000/api/attendance';
    const apiUrl = `${apiBase}/${eventId}/timein`;

    // Create attendance
    const res1 = await fetch(apiBase, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ studentId, eventId })
    });
    if (!res1.ok) {
      const err1 = await res1.json();
      throw new Error(err1.error || 'Failed to create attendance');
    }

    // Update attendance
    const res2 = await fetch(apiUrl, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ studentId, eventId })
    });
    const result2 = await res2.json();
    if (!res2.ok) throw new Error(result2.error || 'Failed to record attendance');

    step.value = 'verified';
    await Swal.fire({
      icon: 'success',
      title: 'Verified ✅',
      text: 'Attendance recorded successfully',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });

    // redirect after success
    window.location.href = `http://localhost:8100/event-attendance?event=${eventId}`;

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
  } finally {
    stopAll();
  }
};

// ----- start & stop -----
const start = async () => {
  actionIndex.value = 0;
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
    await Swal.fire({ title: 'Camera Error', text: err.message, icon: 'error', didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }});
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
#container {
  margin-top: 0;
  text-align: left;
  padding-bottom: 20px;
  padding-top: 0 !important;
  padding-left: 0 !important;
  padding-right: 0 !important;
  height: 100vh;
  color: #fff;
}
.form-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  margin-top: -150px;
  padding: 20px;
}
.step-container {
  text-align: center;
  margin-top: 0;
}
.camera-wrapper {
  position: relative;
  display: inline-block;
}
.video-frame {
  width: 100%;
  max-width: 400px;
  border: 2px solid #2196f3;
  border-radius: 12px;
  display: block;
}
.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  max-width: 400px;
  border-radius: 12px;
  pointer-events: none;
}
.preview {
  width: 100%;
  max-width: 400px;
  border-radius: 12px;
  margin-bottom: 20px;
}
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
</style>
