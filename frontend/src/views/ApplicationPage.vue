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
          <ion-title class="event-title">VOLUNTEER APPLICATION</ion-title>
        </ion-toolbar>

        <div class="form-box">
          <!-- Select Role -->
          <ion-item class="select-full-width">
            <ion-select v-model="role" interface="popover" placeholder="Select your role" css-class="custom-popover-width">
              <ion-select-option value="option1">Option 1</ion-select-option>
              <ion-select-option value="option2">Option 2</ion-select-option>
              <ion-select-option value="option3">Option 3</ion-select-option>
            </ion-select>
          </ion-item>

          <!-- Motivation -->
          <ion-label class="radio-label">What motivates you to volunteer with us?</ion-label>
          <ion-radio-group v-model="motivation">
            <div class="two-column-container">
              <ion-item>
                <ion-label>Gaining experience</ion-label>
                <ion-radio slot="start" value="Gaining experience"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Community involvement</ion-label>
                <ion-radio slot="start" value="Community involvement"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Helping students</ion-label>
                <ion-radio slot="start" value="Helping students"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Other</ion-label>
                <ion-radio slot="start" value="Other"></ion-radio>
              </ion-item>
            </div>
          </ion-radio-group>

          <!-- Motivation Other input -->
          <ion-item v-if="motivation === 'Other'">
            <ion-label position="stacked">If other, elaborate your interest below.</ion-label>
            <ion-input v-model="motivationOther" placeholder="Enter here"></ion-input>
          </ion-item>

          <!-- Volunteered Before -->
          <ion-label class="radio-label">Have you volunteered at school events before?</ion-label>
          <ion-radio-group v-model="volunteeredBefore">
            <div class="two-column-container">
              <ion-item>
                <ion-label>Yes</ion-label>
                <ion-radio slot="start" value="Yes"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>No</ion-label>
                <ion-radio slot="start" value="No"></ion-radio>
              </ion-item>
            </div>
          </ion-radio-group>

          <!-- Past Role input -->
          <ion-item v-if="volunteeredBefore === 'Yes'">
            <ion-label position="stacked">If yes, please describe your role and contributions.</ion-label>
            <ion-input v-model="volunteerRole" placeholder="Enter here"></ion-input>
          </ion-item>

          <!-- Skills -->
          <ion-label class="radio-label">Which skills do you bring to this role?</ion-label>
          <ion-radio-group v-model="skills">
            <div class="two-column-container">
              <ion-item>
                <ion-label>Event planning</ion-label>
                <ion-radio slot="start" value="Event planning"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Teamwork</ion-label>
                <ion-radio slot="start" value="Teamwork"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Communication</ion-label>
                <ion-radio slot="start" value="Communication"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Other</ion-label>
                <ion-radio slot="start" value="Other"></ion-radio>
              </ion-item>
            </div>
          </ion-radio-group>

          <!-- Skills Other input -->
          <ion-item v-if="skills === 'Other'">
            <ion-label position="stacked">If other, state your skill and provide an example.</ion-label>
            <ion-input v-model="skillsOther" placeholder="Enter here"></ion-input>
          </ion-item>

          <!-- Availability -->
          <ion-label class="radio-label">Are you available to volunteer for the entire duration of the event?</ion-label>
          <ion-radio-group v-model="available">
            <div class="two-column-container">
              <ion-item>
                <ion-label>Yes</ion-label>
                <ion-radio slot="start" value="Yes"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>No</ion-label>
                <ion-radio slot="start" value="No"></ion-radio>
              </ion-item>
            </div>
          </ion-radio-group>

          <!-- Team Preference -->
          <ion-label class="radio-label">How do you prefer to contribute to a team?</ion-label>
          <ion-radio-group v-model="team_preference">
            <div class="two-column-container">
              <ion-item>
                <ion-label>Leader</ion-label>
                <ion-radio slot="start" value="Leader"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Collaborator</ion-label>
                <ion-radio slot="start" value="Collaborator"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Supportive role</ion-label>
                <ion-radio slot="start" value="Supportive role"></ion-radio>
              </ion-item>
              <ion-item>
                <ion-label>Other</ion-label>
                <ion-radio slot="start" value="Other"></ion-radio>
              </ion-item>
            </div>
          </ion-radio-group>

          <!-- Team Other input -->
          <ion-item v-if="team_preference === 'Other'">
            <ion-label position="stacked">If other, state your skill and provide an example.</ion-label>
            <ion-input v-model="teamOther" placeholder="Enter here"></ion-input>
          </ion-item>

          <!-- Agreement -->
          <h2 class="volunter-note">Volunteer Agreement Note:</h2>
          <small>
            By submitting this application, I acknowledge that I understand the commitment required for the volunteer role and agree to fulfill my responsibilities.
          </small>

          <ion-item lines="none" class="agreement">
            <ion-checkbox slot="start" v-model="agreementChecked"></ion-checkbox>
            <ion-label class="checkbox-label">
              I agree to the terms of commitment and understand the consequences of non-compliance with my volunteer responsibilities.
            </ion-label>
          </ion-item>

          <!-- Submit Button -->
          <ion-button expand="block" class="login-button" @click="submitForm">Submit</ion-button>
        </div>

        <div class="footer-bottom"></div>
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
  IonRadio,
  IonRadioGroup,
  IonButton,
  IonIcon,
  IonCheckbox,
} from '@ionic/vue';
import Swal from 'sweetalert2';
import { ref } from 'vue';
import { useRoute } from 'vue-router';
import axios from 'axios';

const route = useRoute();
const eventName = ref(route.query.name || '');
const eventDate = ref(route.query.date || '');

console.log('Event Name:', eventName.value);
console.log('Event Date:', eventDate.value);

const formData = ref({
  name: '',
  category: '',
  gender: ''
});
const eventId = ref(route.query.id || null);
const role = ref('');
const motivation = ref('');
const motivationOther = ref('');
const volunteeredBefore = ref('');
const volunteerRole = ref('');
const skills = ref('');
const skillsOther = ref('');
const available = ref('');
const team_preference = ref('');
const teamOther = ref('');
const agreementChecked = ref(false);

const submitForm = async () => {
  if (!agreementChecked.value) {
    Swal.fire({
      icon: 'warning',
      title: 'Agreement Required',
      text: 'You must agree to the volunteer commitment note to proceed.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
    return;
  }

  const payload = {
    event_id: eventId.value,   
    role: role.value,
    motivation: motivation.value,
    motivationOther: motivationOther.value,
    volunteeredBefore: volunteeredBefore.value,
    pastRole: volunteerRole.value,
    skills: skills.value,
    skillsOther: skillsOther.value,
    available: available.value,
    team_preference: team_preference.value,
    teamOther: teamOther.value,
    agreement: agreementChecked.value ? 1 : 0
  };

  try {
    const response = await axios.post('http://localhost:5000/api/volunteers/apply', payload, {
      withCredentials: true
    });

    Swal.fire({
      icon: 'success',
      title: 'Submitted',
      text: response.data.message || 'Application submitted successfully!',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    }).then(() => {
      role.value = '';
      motivation.value = '';
      motivationOther.value = '';
      volunteeredBefore.value = '';
      volunteerRole.value = '';
      skills.value = '';
      skillsOther.value = '';
      available.value = '';
      team_preference.value = '';
      teamOther.value = '';
      agreementChecked.value = false;
    });
  } catch (error) {
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: error.response?.data?.message || 'Failed to submit application',
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
    color: #fff;
    min-height: auto;
    border-radius: 0;
}
.form-container ion-label {
    margin-bottom: 10px;
}
.form-container ::v-deep(.native-wrapper) {
    height: 100%;
    padding: 4px 5px;
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
  margin-bottom: 16px;
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
</style>
