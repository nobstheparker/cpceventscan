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
        <div class="form-container">
          <!-- Yellow Title Bar -->
          <div class="title-bar">
            <span>ACCOUNT SECURITY</span>
          </div>

          <!-- Password Management -->
          <ion-card class="security-card">
            <ion-card-content>
              <div class="section-header">
                <strong>Password Management</strong>
                <ion-icon name="create-outline" @click="showPasswordModal = true"></ion-icon>
              </div>
              <div class="input-row">
                <ion-label>Password:</ion-label>
                <ion-input type="password" value="********" readonly></ion-input>
              </div>
            </ion-card-content>
          </ion-card>

          <!-- Recovery & Verification -->
          <ion-card class="security-card">
            <ion-card-content>
              <div class="section-header">
                <strong>Recovery & Verification</strong>
              </div>
              <div class="input-row">
                <ion-label>Linked Email:</ion-label>
                <ion-input :value="email" readonly></ion-input>
              </div>
            </ion-card-content>
          </ion-card>

          <!-- Security Settings -->
          <ion-card class="security-card">
            <ion-card-content>
              <div class="section-header">
                <strong>Security Settings</strong>
              </div>
              <ion-item lines="none" class="no-bg">
                <ion-label class="label-80">Enable Two-Factor Authentication (2FA)</ion-label>
                <ion-toggle
                  class="toggle-20"
                  :checked="auth === 1"
                  @ionChange="handleAuthToggle"
                ></ion-toggle>
              </ion-item>
              <ion-item button detail class="no-bg" @click="logoutAllDevices">
                <ion-label>Log Out from All Devices</ion-label>
              </ion-item>
            </ion-card-content>
          </ion-card>
        </div>
      </div>

      <!-- Password Change Modal -->
      <ion-modal :is-open="showPasswordModal" @didDismiss="showPasswordModal = false">
        <ion-header>
          <ion-toolbar>
            <ion-title style="font-weight: 700;margin-left: 10px;">Change Password</ion-title>
            <ion-buttons slot="end">
              <ion-button @click="showPasswordModal = false">Close</ion-button>
            </ion-buttons>
          </ion-toolbar>
        </ion-header>
        <ion-content class="modal-content">
            <ion-list>
              <ion-item>
                <ion-label position="stacked" style="font-size: 18px !important; margin-bottom: 6px;">Current Password</ion-label>
                <ion-input type="password" v-model="currentPassword" required></ion-input>
              </ion-item>
              <ion-item>
                <ion-label position="stacked" style="font-size: 18px !important; margin-bottom: 6px;">New Password</ion-label>
                <ion-input type="password" v-model="newPassword" required></ion-input>
              </ion-item>
              <ion-item>
                <ion-label position="stacked" style="font-size: 18px !important; margin-bottom: 6px;">Confirm Password</ion-label>
                <ion-input type="password" v-model="confirmPassword" required></ion-input>
              </ion-item>
            </ion-list>
            <ion-button expand="block" @click="submitPasswordChange" style="margin: 15px; --background: #08055e !important; color: #ffff00;font-weight: 600;">
              Change Password
          </ion-button>
        </ion-content>
      </ion-modal>

      <!-- Footer -->
      <div class="footer">
        <div class="footer-icons">
          <router-link to="/"><ion-icon name="home"></ion-icon></router-link>
          <router-link to="/calendar"><ion-icon name="calendar"></ion-icon></router-link>
          <router-link to="/scanner"><ion-icon name="scan"></ion-icon></router-link>
          <router-link to="/notifications"><ion-icon name="notifications"></ion-icon></router-link>
          <router-link to="/profile"><ion-icon name="person" class="active"></ion-icon></router-link>
        </div>
        <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
      </div>
    </ion-content>
  </ion-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';
import { addIcons } from 'ionicons';
import { createOutline } from 'ionicons/icons';
import {
  IonPage,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonText,
  IonItem,
  IonLabel,
  IonInput,
  IonIcon,
  IonCard,
  IonCardContent,
  IonToggle,
  IonModal,
  IonButtons,
  IonButton,
  IonList
} from '@ionic/vue';

addIcons({
  'create-outline': createOutline
});

const email = ref('');
const phone = ref('');
const auth = ref(0);
const showPasswordModal = ref(false);

const currentPassword = ref('');
const newPassword = ref('');
const confirmPassword = ref('');

const submitPasswordChange = async () => {
  console.log('Clicked Change Password button');
  if (newPassword.value !== confirmPassword.value) {
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'New password and confirm password do not match!',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
    return;
  }

  console.log('Validation passed, starting API call...');
  try {
    console.log('Inside try block before axios call');
    const response = await axios.post(
      'http://localhost:5000/api/students/change-password',
      {
        currentPassword: currentPassword.value,
        newPassword: newPassword.value,
      },
      { withCredentials: true }
    );
    console.log('Response:', response);

    if (response.status === 200) {
  Swal.fire({
    icon: 'success',
    title: 'Success',
    text: response.data.message || 'Password changed successfully!',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });
  showPasswordModal.value = false;
  currentPassword.value = '';
  newPassword.value = '';
  confirmPassword.value = '';
      } else {
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: response.data.message || 'An error occurred',
          didOpen: () => {
            document.body.classList.remove('swal2-height-auto');
            document.documentElement.classList.remove('swal2-height-auto');
          }
        });
      }
      } catch (error) {
        console.error('Axios error:', error);
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: error.response?.data?.message || 'Error occurred during password change',
          didOpen: () => {
            document.body.classList.remove('swal2-height-auto');
            document.documentElement.classList.remove('swal2-height-auto');
          }
        });
      }
};

const handleAuthToggle = async (event: CustomEvent) => {
  const newValue = event.detail.checked ? 1 : 0;

  const result = await Swal.fire({
    title: newValue === 1 ? 'Enable 2FA?' : 'Disable 2FA?',
    text:
      newValue === 1
        ? 'Are you sure you want to enable Two-Factor Authentication?'
        : 'Are you sure you want to disable Two-Factor Authentication?',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes',
    cancelButtonText: 'No',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    },
  });

  if (!result.isConfirmed) {
    event.target.checked = auth.value === 1;
    return;
  }

  try {
    const studentRes = await axios.get('http://localhost:5000/api/protected', {
      withCredentials: true,
    });
    const student = studentRes.data.student;

    // 🔐 Send update to backend
    const response = await axios.post('http://localhost:5000/api/twofa/update-by-student', {
      student_id: student.student_id,
      status: newValue,
    });

    auth.value = newValue;

    Swal.fire({
      icon: 'success',
      title: 'Success',
      text: response.data.message,
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      },
    });
  } catch (error) {
    console.error('Error updating 2FA:', error);
    event.target.checked = auth.value === 1;
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: error.response?.data?.error || 'Failed to update 2FA setting',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      },
    });
  }
};

const logoutAllDevices = async () => {
  const result = await Swal.fire({
    title: 'Log Out from All Devices?',
    text: 'Are you sure you want to log out from all devices for this account?',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, log me out',
    cancelButtonText: 'Cancel',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });

  if (!result.isConfirmed) return;

  try {
    const response = await axios.post(
      'http://localhost:5000/api/students/logout-all',
      {},
      { withCredentials: true }
    );
    if (response.status === 200) {
      Swal.fire({
        icon: 'success',
        title: 'Logged Out',
        text: response.data.message || 'All sessions have been terminated.',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
      window.location.href = '/login';
    }
  } catch (error) {
    console.error('Failed to log out all devices:', error);
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: error.response?.data?.message || 'Could not log out from all devices.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};


onMounted(async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/protected', {
      withCredentials: true,
    });

    if (response.data && response.data.student) {
      const student = response.data.student;
      email.value = student.email || '';
      phone.value = student.phone || '';

      // 🧠 Fetch 2FA status
      const twofaRes = await axios.get('http://localhost:5000/api/twofa');
      const record = twofaRes.data.find((r) => r.student_id === student.student_id);
      auth.value = record?.twofa_status ?? 0;
    }
  } catch (error) {
    console.error('Failed to fetch student or 2FA data', error);
  }
});
</script>


<style scoped>
.ion-page {
  max-width: 768px;
  margin: 0 auto;
  color: #000;
}

ion-content {
  --background: #f6f6f6;
  padding: 20px;
}

#container {
  margin-top: 0;
  text-align: left;
  padding-bottom: 20px;
  padding-top: 0px !important;
  padding: 0;
}

.form-container {
  margin: 0px;
  width: 100%;
  margin-bottom: 200px;
}

/* Yellow Header Bar */
.title-bar {
  color: yellow;
  padding: 12px;
  text-align: center;
  font-weight: bold;
  font-size: 25px;
}

/* Account Security Cards */
.security-card {
  background: #fff;
  box-shadow: none;
  border-radius: 0;
  margin-bottom: 15px !important; 
  padding: 0 !important;
  margin: 0;
}

.section-header {
  display: block;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 10px;
  background-color: #07055D;
  padding: 10px;
  border: solid 2px #fff;
  color: #fff;
}

.input-row {
  display: flex;
  align-items: center;
  padding-bottom: 10px !important; 
  padding: 0 10px;
}

ion-input {
  background: #e9e9e9;
  border: none;
  border-radius: 0;
  color: #343333;
  font-weight: 500;
  padding-left: 10px !important;
  margin-left: 10px; /* Space between label and input */
  flex: 1; /* Allow input to take remaining space */
}

ion-label {
  font-weight: 600;
  font-size: 14px !important;
  color: #343333;
  margin-top: 5px;
  display: block;
}

.no-bg {
  --background: transparent;
}

ion-card-content {
  padding: 0 !important;
  background-color: #BAB7B7;
}

/* Footer */
.footer {
  position: sticky;
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

ion-icon.active {
  width: 24px;
  height: 24px;
  color: yellow;
}

ion-text {
  margin: 10px 0;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px;
  font-size: 14px;
}

.footer-bottom {
  background-color: #08055e;
  height: 30px;
  border-bottom-right-radius: 5px;
  border-bottom-left-radius: 5px;
}
ion-item.no-bg {
  display: flex !important;
  justify-content: space-between !important;
  align-items: center !important;
}

.no-bg {
  display: flex !important;
  align-items: center;
}

ion-toggle {
  --handle-background-checked: #fff;  /* knob color when checked */
}
ion-toggle::part(track) {
  background: #05044D;
}
.label-80 {
  flex: 0 0 88%;
  white-space: normal; /* wrap text if needed */
}

.toggle-20 {
  flex: 0 0 12%;
  margin-left: auto; /* push toggle to right */
}
ion-icon {
    float: right;
    font-size: 25px;
    color: #fff !important;
    font-weight: bold;
    margin-right: 5px; 
}
ion-modal, .modal-content { 
    padding: 20px; 
    max-height: 53vh; 
    overflow-y: auto; 
    padding-top: 50px; 
} 
ion-modal ion-input { 
    background-color: #cdcaca; 
    margin-left: 0 !important; 
}

</style>