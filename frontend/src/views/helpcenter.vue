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
            <ion-card-title>❓ FAQ (Frequently Asked Questions)</ion-card-title>
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
              <li>Email us at: support@yourdomain.edu</li>
              <li>Call us at: (XXX) XXX-XXXX for urgent matters.</li>
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
  { id: 1, value: 'attendance', question: 'How do I scan my attendance?', answer: 'To scan your attendance, open the app, go to the Attendance section, and scan the QR code provided by your class officer.' },
  { id: 2, value: 'missed-time', question: 'What should I do if I missed time-in or time-out?', answer: 'Report it to your class officer or SAO office immediately for manual correction.' },
  { id: 3, value: 'absence', question: 'How do I request an absence?', answer: 'Submit your absence request via the app or contact the SAO office directly.' },
  { id: 4, value: 'payment', question: 'How do I pay my fines?', answer: 'Fines can be paid at the school cashier or online. Keep a receipt.' },
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
