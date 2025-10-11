<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-title>
          <div class="admin-logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
        </ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ad-background">
      <div class="container">
        <div class="form">
            <h1 class="adminLogIn-title">LOG IN</h1>

            <div class="ad-user-icon">
            <img src="../../public/img/user-icon.png" alt="user-icon">
            </div>

            <ion-item>
            <ion-label position="stacked">Email:</ion-label>
            <ion-input
                :value="email"
                type="text"
                required
                @ionChange="email = $event.detail.value"
            ></ion-input>
            </ion-item>

            <ion-item>
            <ion-label position="stacked">Password:</ion-label>
            <ion-input
                :value="password"
                type="password"
                required
                @ionChange="password = $event.detail.value"
            ></ion-input>
            </ion-item>

            <ion-button expand="block" class="adLogInbtn" @click="logIn">
            Log In
            </ion-button>
        </div>
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
  IonButton,
  IonContent,
  IonHeader,
  IonInput,
  IonPage,
  IonText,
  IonToolbar,
  IonTitle
} from '@ionic/vue';
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import Swal from 'sweetalert2';

const router = useRouter();
const API_URL = 'http://localhost:5000/api/users/admin-login';

const email = ref('');
const password = ref('');

const logIn = async () => {
  if (!email.value || !password.value) {
    Swal.fire({
      icon: 'error',
      title: 'Missing Fields',
      text: 'Please enter both email and password.',
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
    return;
  }

  try {
    const res = await axios.post(API_URL,
     {
      email: email.value,
      password: password.value
    },
    { withCredentials: true }
    );

    const user = res.data.user;

    if (user.status !== 0 && user.status !== 2) {
      Swal.fire({
        icon: 'error',
        title: 'Account Inactive',
        text: 'Your admin account is deactivated.',
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        }
      });
      return;
    }

    sessionStorage.setItem('adminUser', JSON.stringify(user));
    sessionStorage.setItem('token', res.data.token);

    router.push('/dashboard');

  } catch (err: any) {
    Swal.fire({
      icon: 'error',
      title: 'Login Failed',
      text: err.response?.data?.message || 'Invalid credentials',
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
  }
};
const checkSession = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/check-admin-session', { withCredentials: true });
    if (res.data.loggedIn) {
      router.replace('/dashboard');
    }
  } catch (err) {
    router.push('/adminLogIn');
  }
};
onMounted(() => {
  checkSession();
});
</script>

<style scoped>
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
.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
}
.container .form {
    display: block;
    width: 450px;
    opacity: 0.85;
    padding: 30px 10px;
    background-color: #FFFFFF;
    border-radius: 10px;
    margin: 0 auto;
    margin-bottom: 25px !important;
    font-family: 'Hind Kochi', sans-serif !important;
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
  font-family: 'Hind Kochi', sans-serif !important;
  font-weight: 500;
}

ion-input {
    --padding-start: 10px;
    background-color: #d7d8da;
    margin-top: 10px !important;
    color: #1e1e1e;
    border-radius: 3px;
    font-family: 'Hind Kochi', sans-serif !important;
}

.adLogInbtn {
  --background: #07055D;
  --background-activated: #05044a;
  --border-radius: 8px;
  font-weight: bold;
  margin-top: 10px;
  font-family: 'Hind Kochi', sans-serif !important;
}
.ad-user-icon{
  text-align: center;
}
.ad-user-icon img{
  height: 100px;
}
.ad-background{
    --background: url('../../public/img/admin-bg.png');
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center;
    
}
.admin-logo{
    display: flex;
    height: 75px;
    margin-left: 10px;
    padding: 3px;
}
.adminLogIn-title{
    text-align: center;
    font-size: 30px;
    font-weight: 600;
    font-family: 'Hind Kochi', sans-serif !important;
}
.footer {
    background-color: #07055D;
    color: #fff;
    height: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 20px;
    border-top: 5px solid;
    position: fixed;
    width: 100%;
    bottom: 0;
}
</style>