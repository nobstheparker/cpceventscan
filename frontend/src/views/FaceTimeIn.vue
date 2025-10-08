<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-title>
          <div class="logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
        </ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <div id="container">
        <div class="form-container">

          <!-- Step 1: Camera + Progress -->
          <div v-if="step === 1" class="step-container camera-wrapper">
            <video ref="video" autoplay muted playsinline class="video-frame"></video>
            <canvas ref="canvas" class="overlay"></canvas>
            <p>Progress: {{ Math.floor(progress) }}%</p>
          </div>

          <!-- Step 2: Verified -->
          <div v-if="step === 2" class="step-container">
            <h2>Verified ✅</h2>
            <p>Attendance updated successfully!</p>
          </div>

          <!-- Step 3: Failed -->
          <div v-if="step === 3" class="step-container">
            <h2>Verification Failed ❌</h2>
            <ion-button expand="block" @click="retry">Retry</ion-button>
          </div>

        </div>
      </div>

      <!-- Footer -->
      <div class="footer">
        <div class="footer-icons">
          <router-link to="/"><ion-icon name="home" class="active"></ion-icon></router-link>
          <router-link to="/calendar"><ion-icon name="calendar"></ion-icon></router-link>
          <router-link to="/scanner"><ion-icon name="scan"></ion-icon></router-link>
          <router-link to="/notifications"><ion-icon name="notifications"></ion-icon></router-link>
          <router-link to="/profile"><ion-icon name="person"></ion-icon></router-link>
        </div>
        <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
      </div>
    </ion-content>
  </ion-page>
</template>

<script setup>
import { ref, onBeforeUnmount, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import Swal from 'sweetalert2';
import * as faceapi from 'face-api.js';

const student = JSON.parse(localStorage.getItem('student')) || {};
const studentId = student?.student_id;

const step = ref(1);
const progress = ref(0);
const radius = 100;

const route = useRoute();
const eventId = route.query.event;
const action = route.query.action; // timein | trivia | timeout

let video = ref(null);
let canvas = ref(null);
let stream = null;
let detectInterval = null;
let frameDescriptors = [];
const requiredFrames = 20;

// --- Start Camera ---
const startCamera = async () => {
  await Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri('/models'),
    faceapi.nets.faceLandmark68Net.loadFromUri('/models'),
    faceapi.nets.faceRecognitionNet.loadFromUri('/models')
  ]);

  stream = await navigator.mediaDevices.getUserMedia({ video: true });
  video.value.srcObject = stream;

  video.value.onloadedmetadata = () => {
    video.value.play();
    detectInterval = setInterval(detectFace, 100);
  };
};

// --- Detect Face ---
const detectFace = async () => {
  if (!video.value || video.value.readyState !== 4) return;

  const detection = await faceapi
    .detectSingleFace(video.value, new faceapi.TinyFaceDetectorOptions())
    .withFaceLandmarks()
    .withFaceDescriptor();

  drawCircle(detection);

  if (detection) {
    const box = detection.detection.box;
    const cx = video.value.videoWidth / 2;
    const cy = video.value.videoHeight / 2;
    const faceCenterX = box.x + box.width / 2;
    const faceCenterY = box.y + box.height / 2;
    const distanceToCircle = Math.hypot(faceCenterX - cx, faceCenterY - cy);

    if (distanceToCircle <= radius) {
      frameDescriptors.push(detection.descriptor);
      progress.value = Math.min(100, (frameDescriptors.length / requiredFrames) * 100);
    }
  } else {
    progress.value = Math.max(0, progress.value - 0.5);
  }

  if (frameDescriptors.length >= requiredFrames) {
    clearInterval(detectInterval);
    const avgDescriptor = Array.from(frameDescriptors[0]).map((_, i) =>
      frameDescriptors.reduce((sum, d) => sum + d[i], 0) / frameDescriptors.length
    );
    await autoVerify(avgDescriptor);
  }
};

// --- Draw Circle & Progress ---
const drawCircle = (detection) => {
  if (!canvas.value || !video.value) return;

  const ctx = canvas.value.getContext('2d');
  const width = video.value.videoWidth || 640;
  const height = video.value.videoHeight || 480;
  canvas.value.width = width;
  canvas.value.height = height;

  const cx = width / 2;
  const cy = height / 2;

  ctx.clearRect(0, 0, width, height);
  ctx.fillStyle = 'rgba(0,0,0,0.2)';
  ctx.fillRect(0, 0, width, height);

  ctx.globalCompositeOperation = 'destination-out';
  ctx.beginPath();
  ctx.arc(cx, cy, radius, 0, 2 * Math.PI);
  ctx.fill();
  ctx.globalCompositeOperation = 'source-over';

  ctx.strokeStyle = '#2196f3';
  ctx.lineWidth = 3;
  ctx.beginPath();
  ctx.arc(cx, cy, radius, 0, 2 * Math.PI);
  ctx.stroke();

  const startAngle = -Math.PI / 2;
  const endAngle = startAngle + (progress.value / 100) * 2 * Math.PI;
  ctx.strokeStyle = '#4caf50';
  ctx.lineWidth = 4;
  ctx.beginPath();
  ctx.arc(cx, cy, radius + 6, startAngle, endAngle);
  ctx.stroke();

  if (detection) {
    const box = detection.detection.box;
    ctx.strokeStyle = 'yellow';
    ctx.lineWidth = 2;
    ctx.strokeRect(box.x, box.y, box.width, box.height);
  }
};

// --- Auto Verify Face ---
const autoVerify = async (descriptor) => {
  try {
    const res = await fetch('http://localhost:5000/api/face/verify', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ descriptor })
    });

    let data;
    try { data = await res.json(); } 
    catch {
      const text = await res.text();
      console.error('Server did not return JSON:', text);
      Swal.fire({
        icon: 'error',
        title: 'Server Error',
        text: 'Face verification API did not return valid JSON',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
      return;
    }

    if (!data.verified) {
      step.value = 3;
      Swal.fire({
        icon: 'error',
        title: 'Verification Failed ❌',
        text: `Face did not match (distance: ${data.distance?.toFixed(3) || 'N/A'})`,
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
      return;
    }

    step.value = 2;

    // Create or Update Attendance
    const apiBase = 'http://localhost:5000/api/attendance';
    let apiUrl = '';
    let method = 'PUT';

    if (action === 'timein') apiUrl = `${apiBase}/${eventId}/timein`;
    else if (action === 'trivia') apiUrl = `${apiBase}/${eventId}/trivia-timein`;
    else if (action === 'timeout') apiUrl = `${apiBase}/${eventId}/timeout`;

    await fetch(apiBase, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ studentId, eventId })
    });

    const res2 = await fetch(apiUrl, {
      method,
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ studentId })
    });
    const result2 = await res2.json();
    if (!res2.ok) throw new Error(result2.error || 'Failed to record attendance');

    Swal.fire({
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

  } catch (err) {
    step.value = 3;
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: err.message,
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};

// --- Retry ---
const retry = () => {
  step.value = 1;
  progress.value = 0;
  frameDescriptors = [];
  startCamera();
};

// --- Stop Camera ---
const stopCamera = () => {
  if (stream) stream.getTracks().forEach(track => track.stop());
  if (detectInterval) clearInterval(detectInterval);
};

onBeforeUnmount(() => stopCamera());
nextTick(() => startCamera());
</script>

<style scoped>
#container { margin-top: 0; text-align: left; padding-bottom: 20px; height: 100vh; color: #fff; }
.step-container { text-align: center; margin-top: 0; }
.camera-wrapper { position: relative; display: inline-block; }
.video-frame { width: 100%; max-width: 400px; border: 2px solid #2196f3; border-radius: 12px; display: block; }
.overlay { position: absolute; top: 0; left: 0; width: 100%; max-width: 400px; border-radius: 12px; pointer-events: none; }
.footer { position: fixed; bottom: 0; width: 100%; z-index: 100; }
.footer-icons { display: flex; justify-content: space-around; align-items: center; padding: 10px 0; top: -32px; width: 100%; position: absolute; }
.footer-icons ion-icon { color: #fff; cursor: pointer; padding: 5px; background: #08055e; border: 2px solid #fff; border-radius: 100%; width: 17px; height: 17px; }
.form-container { display: flex; align-items: center; justify-content: center; height: 100%; margin-top: -150px; padding: 20px; }
</style>
