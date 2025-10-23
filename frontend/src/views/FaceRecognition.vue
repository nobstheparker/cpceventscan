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
import { ref, nextTick, onBeforeUnmount, onMounted } from 'vue';
import * as faceapi from 'face-api.js';
import Swal from 'sweetalert2';
import axios from 'axios';

const step = ref(1);
const video = ref(null);
const canvas = ref(null);
const capturedImage = ref(null);
const faceDescriptor = ref(null);
const progress = ref(0);
let stream = null;
let detectInterval = null;
const progressSpeed = 0.5;
const alreadyRegistered = ref(false);

// Check if user already has a face registered
const checkFaceRegistration = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/face/check', {
      withCredentials: true,
    });
    alreadyRegistered.value = res.data.registered || false;
  } catch (err) {
    console.error('Failed to check face registration:', err);
  }
};

const startCamera = async () => {
  step.value = 2;
  await nextTick();

  await Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri('/models'),
    faceapi.nets.faceLandmark68Net.loadFromUri('/models'),
    faceapi.nets.faceRecognitionNet.loadFromUri('/models'),
  ]);

  stream = await navigator.mediaDevices.getUserMedia({ video: true });
  video.value.srcObject = stream;

  detectInterval = setInterval(async () => {
    if (!video.value || video.value.readyState !== 4) return;

    const detection = await faceapi
      .detectSingleFace(video.value, new faceapi.TinyFaceDetectorOptions())
      .withFaceLandmarks()
      .withFaceDescriptor();

    if (!canvas.value) return;
    const ctx = canvas.value.getContext('2d');
    canvas.value.width = video.value.videoWidth;
    canvas.value.height = video.value.videoHeight;
    ctx.clearRect(0, 0, canvas.value.width, canvas.value.height);

    const cx = canvas.value.width / 2;
    const cy = canvas.value.height / 2;
    const radius = Math.min(cx, cy) / 2;

    // Circle overlay
    ctx.fillStyle = 'rgba(0,0,0,0.2)';
    ctx.beginPath();
    ctx.arc(cx, cy, radius, 0, 2 * Math.PI);
    ctx.fill();

    ctx.strokeStyle = '#2196f3';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.arc(cx, cy, radius + 5, 0, 2 * Math.PI);
    ctx.stroke();

    // Progress ring
    ctx.strokeStyle = '#4caf50';
    ctx.lineWidth = 6;
    ctx.beginPath();
    ctx.arc(
      cx,
      cy,
      radius + 10,
      -Math.PI / 2,
      -Math.PI / 2 + (2 * Math.PI * (progress.value / 100))
    );
    ctx.stroke();

    if (detection) {
      faceDescriptor.value = Array.from(detection.descriptor);
      const box = detection.detection.box;
      const faceX = box.x + box.width / 2;
      const faceY = box.y + box.height / 2;
      const dx = faceX - cx;
      const dy = faceY - cy;
      const distance = Math.sqrt(dx * dx + dy * dy);

      if (distance < radius * 0.8) {
        progress.value = Math.min(100, progress.value + progressSpeed);
      } else {
        progress.value = Math.max(0, progress.value - progressSpeed * 0.5);
      }

      ctx.strokeStyle = '#0f0';
      ctx.lineWidth = 2;
      ctx.strokeRect(box.x, box.y, box.width, box.height);

      if (progress.value >= 100) {
        clearInterval(detectInterval);
        await autoCapture();
      }
    } else {
      progress.value = Math.max(0, progress.value - progressSpeed * 0.5);
    }
  }, 100);
};

const autoCapture = async () => {
  const ctx = canvas.value.getContext('2d');
  ctx.drawImage(video.value, 0, 0, canvas.value.width, canvas.value.height);
  capturedImage.value = canvas.value.toDataURL('image/png');
  step.value = 3;
};

const saveFace = async () => {
  if (!capturedImage.value) return;

  await fetch('http://localhost:5000/api/face/register', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify({ image_base64: capturedImage.value.split(',')[1] }) // send Base64 only
  });

  Swal.fire({
    icon: 'success',
    title: 'Face Registered',
    text: 'You can now verify your face.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      },
    willClose: () => {
      window.location.reload();
    }
  });

  stopCamera();
  step.value = 1;
  progress.value = 0;
  capturedImage.value = null;
};


const retakeFace = () => {
  step.value = 2;
  progress.value = 0;
  startCamera();
};

const stopCamera = () => {
  if (stream) stream.getTracks().forEach((t) => t.stop());
  if (detectInterval) clearInterval(detectInterval);
};

onBeforeUnmount(() => stopCamera());
onMounted(() => checkFaceRegistration());
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
