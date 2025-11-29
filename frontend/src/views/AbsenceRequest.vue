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
          <ion-toolbar>
            <ion-title class="event-title">ABSENCE REQUEST</ion-title>
          </ion-toolbar>

          <div class="form-box">
            <h2 class="volunter-note" style="margin-top: 0 !important;">
              INSTRUCTIONS:
              <small style="font-weight: 600;">Please fill out this form to request an absence for a school event.</small>
            </h2>

            <!-- Event Name -->
            <ion-item>
              <ion-label position="stacked">Name of Event:</ion-label>
              <ion-input :value="eventName" readonly></ion-input>
            </ion-item>

            <!-- Event Date -->
            <ion-item>
              <ion-label position="stacked">Date of Event:</ion-label>
              <ion-input type="date" :value="eventDate" disabled></ion-input>
            </ion-item>

            <!-- Reason for Absence -->
            <ion-item>
              <ion-label position="stacked">Reason for Absence:</ion-label>
              <ion-input
                v-model="reason"
                placeholder="Enter here"
                @input="handleReasonInput"
                @keydown="(e) => {
                  const allowedKeys = [
                    'Backspace','Tab','Enter','ArrowLeft','ArrowRight','ArrowUp','ArrowDown','Delete','Home','End'
                  ];

                  // Allow navigation keys
                  if (allowedKeys.includes(e.key)) return;

                  const currentValue = reason || '';

                  // Handle space - prevent leading space or double space
                  if (e.key === ' ') {
                    if (currentValue.length === 0 || currentValue.endsWith(' ')) {
                      e.preventDefault();
                      return;
                    }
                    return; // allow single space after a letter
                  }

                  // Allow only letters A–Z, a–z, and ñ/Ñ
                  if (!/^[a-zA-ZñÑ]$/.test(e.key)) {
                    e.preventDefault();
                  }
                }"
              />
            </ion-item>

            <!-- Upload Documentation -->
            <ion-item lines="none">
              <ion-label position="stacked">Upload Documentation:</ion-label>
              <ion-button expand="block" @click="triggerFileInput" class="file-btn">Select File</ion-button>
              <input type="file" ref="fileInput" hidden @change="onFileSelected" accept="image/*,.pdf,.doc,.docx" />
            </ion-item>

            <ion-text v-if="selectedFileName" style=" margin: 0 !important ;">
              <small>Selected: {{ selectedFileName }}</small>
            </ion-text>

            <!-- Parent/Guardian Name -->
           <ion-item>
            <ion-label position="stacked">Full Name of Parent/Guardian:</ion-label>
              <ion-input
                v-model="parentName"
                placeholder="Enter here"
                @input="handleParentNameInput"
                @keydown="(e) => {
                  const allowedKeys = [
                    'Backspace','Tab','Enter','ArrowLeft','ArrowRight','ArrowUp','ArrowDown','Delete','Home','End'
                  ];

                  // Allow navigation keys
                  if (allowedKeys.includes(e.key)) return;

                  const currentValue = parentName || '';

                  // Handle space - prevent leading space or double space
                  if (e.key === ' ') {
                    if (currentValue.length === 0 || currentValue.endsWith(' ')) {
                      e.preventDefault();
                      return;
                    }
                    return; // allow single space after a letter
                  }

                  // Allow only letters A–Z, a–z, and ñ/Ñ
                  if (!/^[a-zA-ZñÑ]$/.test(e.key)) {
                    e.preventDefault();
                  }
                }"
              />
          </ion-item>

            <!-- Contact Info -->
            <ion-item>
              <ion-label position="stacked">Contact Information:</ion-label>
              <ion-input
                v-model="contactInfo"
                placeholder="Enter here"
                type="tel"
                @keydown="(e) => {
                  const allowedKeys = [
                    'Backspace','Enter','ArrowLeft','ArrowRight','ArrowUp','ArrowDown','Delete','Home','End'
                  ];

                  // Allow navigation keys
                  if (allowedKeys.includes(e.key)) return;

                  // Prevent typing beyond 11 characters
                  if (contactInfo && contactInfo.length >= 11) {
                    e.preventDefault();
                    return;
                  }

                  // Prevent space as first character or when empty
                  if (e.key === ' ') {
                    if (!contactInfo || contactInfo.length === 0) {
                      e.preventDefault();
                      return;
                    }
                  }

                  // Allow only digits
                  if (!/^[0-9]$/.test(e.key)) {
                    e.preventDefault();
                  }
                }"
              />
            </ion-item>

            <!-- Agreement -->
            <ion-radio-group>
              <ion-item lines="none" class="agreement">
                <ion-checkbox slot="start" v-model="agreementChecked"></ion-checkbox>
                <ion-label class="checkbox-label">
                  I acknowledge and approve this absence request and confirm that the required documentation has been provided.
                </ion-label>
              </ion-item>
            </ion-radio-group>

            <!-- Submit -->
            <ion-button expand="block" class="login-button" @click="submitForm">Submit</ion-button>
          </div>

          <div class="footer-bottom"></div>
        </div>
      </div>

      <!-- Footer -->
      <div class="footer" keyboard-attach>
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

<script setup lang="ts">
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
  IonSelect,
  IonSelectOption,
  IonRadioGroup,
  IonCheckbox,
  IonButton,
  IonIcon,
} from '@ionic/vue';
import { useRoute } from 'vue-router';
import { ref } from 'vue';
import Swal from 'sweetalert2';
import axios from 'axios';
import { nextTick } from 'vue';

const route = useRoute();
const eventId = ref(route.query.id || null);  // volunteered_id
const eventName = ref(route.query.name || '');
const rawDate = route.query.date as string || '';

const eventDate = ref('');
if (rawDate) {
  const dateObj = new Date(rawDate);
  eventDate.value = dateObj.toISOString().split('T')[0];
}


const fullName = ref('');
const department = ref('');
const yearSection = ref('');
const reason = ref('');
const submissionDate = ref('');
const parentName = ref('');
const contactInfo = ref('');
const selectedFile = ref<File | null>(null);
const selectedFileName = ref('');
const agreementChecked = ref(false);

const fileInput = ref<HTMLInputElement | null>(null);

const triggerFileInput = () => {
  fileInput.value?.click();
};

const onFileSelected = (event: Event) => {
  const files = (event.target as HTMLInputElement).files;
  if (files && files.length > 0) {
    selectedFile.value = files[0];
    selectedFileName.value = files[0].name;
  }
};

const handleReasonInput = (e: Event) => {
  const target = e.target as HTMLInputElement;
  let value = target.value;

  // Remove leading spaces
  value = value.replace(/^\s+/g, "");
  // Replace double (or more) spaces with single space
  value = value.replace(/\s{2,}/g, " ");

  reason.value = value;
};

const handleParentNameInput = (e: Event) => {
  const target = e.target as HTMLInputElement;
  let value = target.value;

  // Remove leading spaces
  value = value.replace(/^\s+/g, "");
  // Replace double (or more) spaces with single space
  value = value.replace(/\s{2,}/g, " ");

  parentName.value = value;
};

// Submit Form
const submitForm = async () => {
  if (!agreementChecked.value) {
    Swal.fire({
      icon: 'warning',
      title: 'Agreement Required',
      text: 'You must agree to the absence request terms to proceed.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
    return;
  }

  const formData = new FormData();
  formData.append('event_id', eventId.value as string);
  formData.append('full_name', fullName.value);
  formData.append('department', department.value);
  formData.append('year_section', yearSection.value);
  formData.append('reason', reason.value);
  formData.append('submission_date', submissionDate.value);
  formData.append('parent_name', parentName.value);
  formData.append('contact_info', contactInfo.value);
  formData.append('agreement', agreementChecked.value ? '1' : '0');

  if (selectedFile.value) {
    formData.append('documentation', selectedFile.value);
  }

  try {
    // tell Axios to expect plain text response
    const response = await axios.post(
      'http://localhost:5000/api/absence-request/apply',
      formData,
      { withCredentials: true }
    );

    console.log("Response data:", response.data);

  Swal.fire({
    icon: 'success',
    title: 'Submitted',
    text: 'Absence request submitted successfully!',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  }).then(() => {
    // reset form
    fullName.value = '';
    department.value = '';
    yearSection.value = '';
    reason.value = '';
    selectedFile.value = null;
    submissionDate.value = '';
    parentName.value = '';
    contactInfo.value = '';
    agreementChecked.value = false;
  });
  } catch (error) {
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to submit absence request',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};
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
  padding-top: 30px !important;
}

.form-container {
  margin: 10px;
  background: #fff;
  border-radius: 5px;
  width: 100%;
}
.form-container ion-input {
    color: black;
    min-height: auto;
    border-radius: 0;
    font-size: 12px;
    border-radius: 3px;
}
.form-container ion-label {
    margin-bottom: 5px;
}
.form-container ::v-deep(.native-wrapper) {
    height: 100%;
    padding: 8px 5px;
    background-color: #B4ACAC;
    margin-top: 5px;
}
.form-container ion-item {
    --inner-padding-end: 0px;
    border-radius: 0 !important;
}
.event-title {
  font-size: 23px;
  color: #ffff00;
  text-align: center;
  font-weight: 700;
}

.form-box {
  padding: 10px;
}

ion-item {
  --highlight-color-focused: #07055D;
  --background: #fff;
  border-radius: 8px;
  --inner-border-width: 0;
}

ion-label {
  font-size: 16px;
  color: #07055D;
}

ion-input,
ion-select {
  color: #000;
}

.radio-label {
  font-size: 16px;
  margin: 16px 0 8px;
  display: block;
  color: #07055D;
}

ion-radio-group ion-item {
  --background: #fff;
  margin-bottom: 10px;
}

.login-button {
  --background: #07055D;
  --background-activated: #05044a;
  font-weight: bold;
  margin-top: 20px;
  border-radius: 8px;
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
ion-item::part(native){
    padding-left: 0;
}
ion-item.select-full-width {
  flex-direction: column !important;
  align-items: stretch !important;
}

ion-item.select-full-width ion-select {
    width: 100% !important;
    display: block !important;
    background: #A1A1A1;
    padding: 0 10px;
    color: #fff;
    border-radius: 5px;
    font-size: 14px;
}

ion-popover.custom-popover-width {
  --width: 94% !important;
  --min-width: 94% !important;
  --max-width: 94% !important;
}
ion-label.checkbox-label {
  font-size: 12px;
}

ion-popover.custom-popover-width .popover-arrow {
  display: none !important;
}
ion-select::part(icon) {
  position: absolute !important;
  right: 0;
  color: #000 !important;
}
.two-column-container {
  display: flex;
  flex-wrap: wrap;
  gap: 0;
}

.two-column-container ion-item {
  flex: 1 1 45%;
  min-width: 140px; 
  margin-bottom: 8px;
  --padding-start: 0; 
}
.two-column-container ion-item::part(native){ 
    min-height: auto;
}
.two-column-container ion-label{
    font-size: 11px !important;
}
::v-deep(ion-radio::part(container)) {
  width: 1rem;
  height: 1rem;
}
.volunter-note {
  font-size: 16px;
  font-weight: 700;
  margin-bottom: 5px;
}
.footer-bottom {
  background-color: #08055e;
  height: 30px;
  border-bottom-right-radius: 5px;
  border-bottom-left-radius: 5px;
}
ion-item.agreement {
  margin-top: 10px;
}
ion-item.agreement::part(native){
  background-color: #CFE5ED;
  padding-left: 10px;
}
ion-item.agreement ion-label{
  font-weight: 700;
}
.image-preview {
  margin-top: 10px;
  text-align: center;
}
.image-preview img {
  max-width: 100%;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
  height: 250px;
}
ion-button.file-btn::part(native) {
  background-color: #08055e;
}
.form-container.input-disabled.sc-ion-input-md-h {
    opacity: 1.38 !important;
}
</style>