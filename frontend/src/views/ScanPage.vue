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

    <ion-content fullscreen>
      <div id="container">
        <h1>SCAN & ATTEND</h1>
        <div v-if="isWeb" id="qr-reader" class="scanner-box"></div>
        <p class="scan-text">Scan the event’s QR CODE to attend.</p>
        <div v-if="scannedContent" class="scanned-result">
          <p>Scanned Event: {{ scannedContent }}</p>
          <p v-if="countdown > 0">Redirecting in {{ countdown }}...</p>
        </div>
        <div class="upload-wrapper">
          <ion-button class="file-btn" expand="block" @click="triggerFileInput">
            <ion-icon :icon="imageOutline" slot="icon-only"></ion-icon>
          </ion-button>
          <input
            ref="fileInput"
            type="file"
            accept="image/*"
            @change="onFileSelected"
            style="display: none"
          />
          <label class="upload-label">Upload QR</label>
        </div>
      </div>
      <div id="qr-image-decoder" style="display: none"></div>
      <div class="footer">
        <div class="footer-icons">
          <router-link to="/"><ion-icon name="home"></ion-icon></router-link>
          <router-link to="/calendar"><ion-icon name="calendar"></ion-icon></router-link>
          <router-link to="/scanner"><ion-icon name="scan" class="active"></ion-icon></router-link>
          <router-link to="/notifications"><ion-icon name="notifications"></ion-icon></router-link>
          <router-link to="/profile"><ion-icon name="person"></ion-icon></router-link>
        </div>
        <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
      </div>
    </ion-content>
  </ion-page>
</template>

<script setup lang="ts">
import {
  IonPage,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonButton,
  IonIcon,
} from '@ionic/vue';
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { Capacitor } from '@capacitor/core';
import { imageOutline } from 'ionicons/icons';
import { BarcodeScanner as NativeScanner } from '@capacitor-mlkit/barcode-scanning';
import { Html5Qrcode } from 'html5-qrcode';
import { useRouter } from 'vue-router';
import Swal from 'sweetalert2';

const router = useRouter();
const scannedContent = ref<string | null>(null);
const fileInput = ref<HTMLInputElement | null>(null);
const previewUrl = ref<string | null>(null);
const isWeb = Capacitor.getPlatform() === 'web';
const countdown = ref(10); // 10 seconds countdown
let countdownInterval: number | undefined;

let html5QrScanner: Html5Qrcode | null = null;

function triggerFileInput() {
  fileInput.value?.click();
}

async function onFileSelected(event: Event) {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];

  if (file) {
    const reader = new FileReader();
    reader.onload = async () => {
      previewUrl.value = reader.result as string;

      try {
        const qrDecoder = new Html5Qrcode('qr-image-decoder');
        const decodedText = await qrDecoder.scanFile(file, true);
        scannedContent.value = decodedText;
        await qrDecoder.clear();

        redirectWithCountdown(decodedText);
      } catch (error) {
        Swal.fire('Error', 'Could not scan uploaded QR image', 'error');
      }
    };
    reader.readAsDataURL(file);
  }
}

async function startScan() {
  if (isWeb) {
    html5QrScanner = new Html5Qrcode('qr-reader');
    try {
      await html5QrScanner.start(
        { facingMode: 'environment' },
        { fps: 10, qrbox: 250 },
        (decodedText: string) => {
          scannedContent.value = decodedText;
          html5QrScanner?.stop();
          redirectWithCountdown(decodedText);
        },
        (err) => console.warn('QR scan error:', err)
      );
    } catch (err) {
      console.error('Unable to start web QR scanner:', err);
    }
  } else {
    try {
      const { barcodes } = await NativeScanner.scan();
      const result = barcodes[0]?.rawValue ?? 'No value';
      scannedContent.value = result;
      redirectWithCountdown(result);
    } catch (err) {
      scannedContent.value = 'Scan failed';
      console.error('Native scan error:', err);
    }
  }
}

// Countdown and redirect
function redirectWithCountdown(eventName: string) {
  if (!eventName || eventName.trim() === "" || eventName === "No value") {
    Swal.fire({
      icon: "error",
      title: "Invalid QR",
      text: "The scanned QR code is invalid.",
      didOpen: () => {
        const popup = document.querySelector(".swal2-popup");
        popup?.classList.remove("swal2-popup");
      }
    }).then(() => window.location.reload());
    return;
  }

  // ✅ Always verify against backend (camera + upload)
  fetch(`http://localhost:5000/api/events/list/${eventName}`, { credentials: "include" })
    .then(res => {
      if (!res.ok) throw new Error("Event not found");
      return res.json();
    })
    .then(data => {
      // ⚠️ adjust field name depending on your DB schema
      if (!data || (!data.id && !data.event_id)) throw new Error("Event not found");
      startCountdown(eventName);
    })
    .catch(() => {
      Swal.fire({
        icon: "error",
        title: "Event Not Found",
        text: "This QR code does not match any event.",
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      }).then(() => window.location.reload());
    });
}

// ✅ Extracted countdown logic (your original code)
function startCountdown(eventName: string) {
  scannedContent.value = eventName;
  countdown.value = 10;

  countdownInterval = window.setInterval(() => {
    countdown.value -= 1;
    if (countdown.value <= 0) {
      clearInterval(countdownInterval);
      window.location.href = `/event-attendance?event=${encodeURIComponent(scannedContent.value ?? '')}`;
    }
  }, 1000);
}


onMounted(() => startScan());
onBeforeUnmount(() => {
  if (html5QrScanner) html5QrScanner.stop().catch(() => {});
  if (countdownInterval) clearInterval(countdownInterval);
});
</script>
<style scoped>
.ion-page {
  max-width: 768px;
  margin: 0 auto;
  color: #000;
}
ion-content {
  --padding-top: env(safe-area-inset-top);
  --padding-bottom: env(safe-area-inset-bottom);
  --background: #f6f6f6;
  padding-left: 20px;
  padding-right: 20px;
}
ion-header, ion-toolbar {
  padding-top: env(safe-area-inset-top);
}
#container {
  min-height: 100vh;
  padding-bottom: 80px;
  padding-top: 10px !important;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}
h1 {
  font-weight: 700;
  text-align: center;
  color: yellow;
  margin: 30px 0 !important;
}
.scanner-box {
  width: 100%;
  max-width: 400px;
  margin: auto;
  background: #000;
}
.scanned-result {
  text-align: center;
  background: #08055e;
  color: #fff;
  padding: 10px;
  margin: 15px auto;
  max-width: 400px;
  border-radius: 8px;
}
.form-container {
  background: #08055e;
  border-radius: 5px;
  padding: 15px;
  margin-top: 20px;
}
.qr-section {
  background: #fff;
  padding: 10px;
  border-radius: 5px;
}
.qr-title {
  font-size: 18px;
  font-weight: 700;
  color: #08055e;
  text-align: center;
  margin-bottom: 10px;
}
.image-preview {
  margin-top: 10px;
  text-align: center;
}
.image-preview img {
  max-width: 100%;
  border-radius: 8px;
  height: 250px;
  object-fit: cover;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
}
.file-btn::part(native) {
  background: none !important;
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
  position: absolute;
  width: 100%;
  top: -32px;
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
ion-icon.active {
  width: 24px;
  height: 24px;
  color: yellow;
}
.footer-bottom {
  background-color: #08055e;
  height: 10px;
  border-bottom-right-radius: 5px;
  border-bottom-left-radius: 5px;
}
ion-text {
  margin: 10px 0;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px;
  font-size: 14px;
}
.scan-text {
    color: #fff;
    padding: 20px;

}
.upload-wrapper ion-icon {
    font-size: 40px;
    background: #08055e;
    padding: 5px;
    border-radius: 100%;
    border: 3px solid #fff;
}
.upload-wrapper .upload-label {
    color: #fff;
    margin-bottom: 20px;
}
</style>
