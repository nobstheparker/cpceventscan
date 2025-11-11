<template>
  <ion-page>
    <!-- Header with Logo -->
    <ion-header>
      <ion-toolbar>
        <div class="logo">
          <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
        </div>
      </ion-toolbar>
    </ion-header>

    <ion-content class="help-center">
      <div id="container">
        <div class="greeting" v-if="studentLoaded">
          <h2>Hello {{ fullName }},</h2>
          <p>How can we help?</p>
          <ion-searchbar
            v-model="searchQuery"
            placeholder="Search FAQ"
            debounce="300"
          ></ion-searchbar>
        </div>

        <!-- FAQ Section as Accordion -->
        <ion-card class="faq-section">
          <ion-card-header>
            <ion-card-title>❓ System Guide</ion-card-title>
          </ion-card-header>
          <ion-card-content>
            <ion-accordion-group>
              <ion-accordion
                v-for="faq in filteredFaqs"
                :key="faq.id"
                :value="faq.value"
              >
                <ion-item slot="header" detail>
                  {{ faq.question }}
                </ion-item>
                <div class="ion-padding" slot="content">
                  {{ faq.answer }}
                </div>
              </ion-accordion>
            </ion-accordion-group>
            <div v-if="filteredFaqs.length === 0" class="ion-padding">
              No results found.
            </div>
          </ion-card-content>
        </ion-card>

        <!-- Contact Support Section -->
        <ion-card class="contact-section">
          <ion-card-header>
            <ion-card-title>📞 Contact Support</ion-card-title>
          </ion-card-header>
          <ion-card-content>
            <ul>
              <li>Visit the SAO or SSG Office during school hours.</li>
              <li>Email us at: cpcevents135@gmail.com</li>
            </ul>
          </ion-card-content>
        </ion-card>
      </div>
    </ion-content>

    <!-- Footer -->
    <div class="footer">
      <div class="footer-icons">
        <ion-icon name="home" @click="goTo('/')"></ion-icon>
        <ion-icon name="calendar" @click="goTo('/calendar-page')"></ion-icon>
        <ion-icon name="scan" @click="goTo('/scanner')"></ion-icon>
        <ion-icon name="notifications" @click="goTo('/notifications')"></ion-icon>
        <ion-icon name="person" class="active" @click="goTo('/profile')"></ion-icon>
      </div>
      <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
    </div>
  </ion-page>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';
import {
  IonPage,
  IonHeader,
  IonToolbar,
  IonCard,
  IonCardHeader,
  IonCardTitle,
  IonCardContent,
  IonAccordionGroup,
  IonAccordion,
  IonItem,
  IonSearchbar,
  IonIcon,
  IonText,
} from '@ionic/vue';

// --- Student Info ---
const student = ref<any>(null);
const studentLoaded = ref(false);

const fullName = computed(() => {
  if (!student.value) return '';
  const s = student.value;
  return `${s.first_name} ${s.last_name}`.toUpperCase();
});

// --- Navigation ---
const goTo = (path: string) => {
  window.location.href = path;
};

// --- FAQ List ---
const faqs = ref([
  { id: 1, value: 'absence', question: 'How to Submit an Absence Request?', answer: 'To submit an absence request, first log in to your account. On the homepage, click any date in the monthly event calendar to view the event details, then scroll to the bottom of the event details and click the “Absence Request” button. Fill out the form with the required information and submit your request. After submitting, wait for the admin’s response and check the status of your request anytime on your Profile Page under Absence Requests.'},
  { id: 2, value: 'volunteer', question: 'How to Submit Volunteer Application?', answer: 'To submit a volunteer application, first log in to your account. On the homepage, click any date in the monthly event calendar to view the event details, then scroll to the bottom of the event details and click the “Volunteer Application” button. Fill out the form with the required information and submit your application. After submitting, wait for the admin’s response and check the status of your application anytime on your Profile Page under Volunteer Applications.' },
  { id: 3, value: 'attendance', question: 'How to Record Attendance?', answer: 'To record attendance, first log in to your account and ensure that your Face ID is registered. To proceed, scan the event’s QR code provided by the SSG officers. You will then be directed to the Attendance Page, where you can record your attendance by clicking the appropriate Attendance button — Time In, Mid Event, or Time Out. Perform facial verification to confirm your identity, and make sure you are physically present at the event location to successfully record your attendance.' },
  { id: 4, value: 'face recognition', question: 'How to Register your Face ID?', answer: 'To register your Face ID, log in to your account and go to your Profile Page. From there, select the Face ID Registration option. Follow the instructions on the screen to register your face by allowing camera access and positioning your face within the frame until the system successfully captures your facial data. Once completed, your Face ID will be saved and used for attendance verification during events.' },
  { id: 5, value: 'password', question: 'How to Change Password?', answer: 'To change your password, log in to your account and go to your Profile Page. Select Account Security, then click the edit icon in the Password section. Enter your current password, followed by your new password, and confirm it to save the changes. Once updated, your new password will take effect immediately, and you can use it the next time you log in.' },
  { id: 6, value: 'personal info', question: 'How to Update my Personal Information?', answer: 'To edit your profile information, log in to your account and go to your Profile Page. Select the Personal Info section, then click the Edit button to update your details such as name, contact information, or other personal data. After making the necessary changes, click Save to apply the updates. Your profile information will be successfully updated once saved.' },
  { id: 7, value: 'account', question: 'How to Secure my Account?', answer: 'To secure your account, it is highly recommended to enable Two-Factor Authentication (2FA). By turning on 2FA, your account gains an extra layer of protection. When you log in on a new device, the system will send a verification code to your registered email, which you must enter to access your account. This ensures that only you can log in, even if someone else knows your password.' },
  { id: 8, value: 'settleattendance', question: 'How to settle my incomplete attendance?', answer: 'To settle incomplete attendance, log in to your account and check your Attendance Records on your Profile Page to identify any events marked as Incomplete. Once confirmed, you must personally visit the SAO Office to settle your attendance. Inform the staff about your incomplete record and provide the necessary details or proof of attendance. The SAO Office will then review your case and update your attendance status once verified.' },
  
]);

// --- Search Functionality ---
const searchQuery = ref('');
const filteredFaqs = computed(() => {
  if (!searchQuery.value) return faqs.value;
  const query = searchQuery.value.toLowerCase();
  return faqs.value.filter(
    (f) =>
      f.question.toLowerCase().includes(query) ||
      f.answer.toLowerCase().includes(query)
  );
});

// --- Fetch student session ---
onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/protected', { withCredentials: true });
    student.value = res.data.student;
    studentLoaded.value = true;
  } catch (error) {
    console.error('Session fetch failed:', error);
  }
});
</script>

<style scoped>
.help-center {
  --background: #f6f6f6;
  padding: 20px;
}
#container { text-align: left; padding-bottom: 20px; height: max-content; display: block; padding-top:10px !important; padding: 0 ; color: #fff; padding-bottom: 300px !important; }
ion-grid.header {
  padding: 10px 0;
}
.greeting {
    background: #07055d;
    border-bottom: 2px solid #fff;
    border-top: 2px solid;
    padding: 0 10px;
}
.greeting h2 {
    margin: 10px 0;
    color: #fff !important;
}
.greeting p {
    color: #fff !important;
    margin-bottom: 0 !important;
}
.greeting ion-searchbar {
    padding: 10px 0;
}
ion-searchbar {
  --background: #f5f5f5;       /* input background */
  --color: #000;            /* input text color */
  --placeholder-color: #999;   /* placeholder color */
  --border-radius: 12px;       /* rounded corners */
  --padding-start: 12px;       /* left padding */
}
.header ion-row {
  align-items: center;
  background-color: #08055e;
  color: #fff;
  border-top: 5px solid #fff;
  border-bottom: 5px solid #fff;
}
.header .image {
  text-align: center;
}
.header img {
  width: 75px;
  height: 75px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #fff;
  background-color: #fff;
}
.header h1 {
  font-weight: 700;
  font-size: 18px;
  color: yellow;
  margin: 0;
  text-transform: uppercase;
}
.header span {
  font-size: 14px;
  color: #fff;
}

/* Greeting */
.greeting h2 {
  font-weight: bold;
  margin-bottom: 4px;
  color: #000;
}
.greeting p {
  margin: 0 0 10px;
  color: #444;
}

/* FAQ Accordion */
.faq-section ion-card-title {
  font-weight: bold;
  font-size: 1rem;
}
ion-accordion {
  border-bottom: 1px solid #ddd;
}
ion-accordion ion-item {
  font-weight: bold;
}

/* Contact Section */
.contact-section ul {
  padding-left: 20px;
}
.contact-section li {
  margin-bottom: 6px;
}

/* Footer */
.footer {
  position: sticky;
  bottom: 0;
  width: 100%;
  z-index: 100;
  margin-top: 20px;
}
.footer-icons {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 10px 0;
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

ion-text {
  margin: 10px 0;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px;
  font-size: 14px;
}
</style>
