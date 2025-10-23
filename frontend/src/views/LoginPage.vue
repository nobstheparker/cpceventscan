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

    <ion-content  class="fixed-content"
      :scrollAssist="false"
      :keyboard-attach="false"
      keyboard-resize="none">
      <div id="container">
        <h1 class="login-title">LOG IN</h1>
        <form @submit.prevent="login">
          <div class="user-icon">
            <img src="../../public/img/user-icon.png" alt="User Icon" />
          </div>

          <ion-item>
            <ion-label position="stacked">ID Number:</ion-label>
            <ion-input v-model="student_id" type="text" required />
          </ion-item>

          <ion-item>
            <ion-label position="stacked">Password:</ion-label>
            <ion-input v-model="password" type="password" required />
          </ion-item>

          <ion-button expand="block" type="submit" class="login-button">
            Login
          </ion-button>
        </form>
      </div>

      <div class="footer">
        <ion-text>
          <small>&copy; All Rights Reserved PPG 2025.</small>
        </ion-text>
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
  IonItem,
  IonLabel,
  IonInput,
  IonButton,
  IonText
} from '@ionic/vue';

import { ref, onMounted } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';
import { useRouter } from 'vue-router';

const student_id = ref('');
const password = ref('');
const router = useRouter();

axios.defaults.withCredentials = true;

const login = async () => {
  console.log('Login clicked:', { student_id: student_id.value, password: password.value });

  if (!student_id.value || !password.value) {
    return Swal.fire('Error', 'Please fill out both fields', 'error');
  }

  try {
    const response = await axios.post(
      'http://localhost:5000/api/students/auth-login',
      { student_id: student_id.value, password: password.value },
      { withCredentials: true }
    );

    // ✅ If Two-Factor Authentication is enabled
    if (response.data.twofa_required) {
  // ✅ Make sure both fields are saved
  localStorage.setItem(
    "pendingTwoFA",
    JSON.stringify({
      student_id: response.data.student_id, // must exist
      email: response.data.email
    })
  );

  Swal.fire({
    icon: 'info',
    title: 'Verification Required',
    text: 'We sent a verification code to your email. Please check it.',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  }).then(() => {
    router.push('/twofa');
  });

  return;
    }

    localStorage.setItem('student', JSON.stringify(response.data.student));
    router.push('/');
  } catch (err: any) {
    console.error('Login error response:', err.response);
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: err.response?.data?.message || 'Login failed.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};

const checkSession = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/protected', { withCredentials: true });
    if (response.data.message === 'Authenticated') {
      router.push('/');
    } else {
      router.push('/login');
    }
  } catch (error) {
    router.push('/login');
  }
};

onMounted(() => {
  checkSession();
});
</script>


<style scoped>
.ion-page {
  max-width: 768px !important;
  margin: 0 auto;
}
.toolbar-container::part(backdrop) {
  background-color: #07055D !important;
}
ion-content {
  --background: #f6f6f6;
  padding: 20px;
}
ion-input::part(native) {
  padding: 0 !important; 
  margin-top: 10px;
}
ion-button {
  width: 200px;
  color: #fff;
  margin: 10px auto !important;
  font-size: 20px;
}
ion-button::part(native){
  padding: 10px;
  border-radius: 10px;
  margin-top: 20px;
  margin-bottom: 0;
}
.login-title {
  color: #fff !important;
}
#container {
  padding-bottom: 100px;
  min-height: max-content;
  max-height: max-content; 
  height: 100%;
}
#container form {
  display: block;
  width: 340px;
  padding: 30px 10px;
  background-color: #d2d1d9;
  border-radius: 10px;
  margin: 0 auto;
}

ion-item {
  --background:none;
  --highlight-color-focused: #07055D;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 0px;
  display: block;
  padding: 0 !important;
  --inner-border-width: 0;
}

ion-label {
  font-size: 24px !important;
  color: #000 !important;
  padding-bottom: 10px !important;
}

ion-input {
  --padding-start: 10px;
  background-color: #fff;
  margin-top: 10px !important;
  color: #000;
}

.login-button {
  --background: #07055D;
  --background-activated: #05044a;
  --border-radius: 8px;
  font-weight: bold;
  margin-top: 10px;
  cursor: pointer;
}
.user-icon {
  text-align: center;
}
.user-icon img {
  height: 100px;
}
.footer {
  position: sticky;
  width: 100%;
  bottom: 0;
}
.fixed-content {
  --keyboard-offset: 0px !important;
  --offset-top: 0px !important;
  --offset-bottom: 0px !important;
}

</style>
