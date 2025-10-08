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
        <!-- Profile Header -->
        <ion-grid class="header">
          <ion-row>
            <ion-col size="3" class="image">
              <img
                src="../../public/img/user.jpg"
                alt="Profile Image"
                @error="onImageError"
              >
            </ion-col>
            <ion-col size="9" class="info">
              <h1>{{ fullName }}</h1>
              <span>{{ courseSection }}</span>
            </ion-col>
          </ion-row>
        </ion-grid>

        <!-- Menu Options -->
        <ion-list class="menu-list">
          <ion-item button lines="none" @click="goTo('/personal-info')">
            <ion-label>Personal Information</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>
          <ion-item button lines="none" @click="goTo('/account-security')">
            <ion-label>Account Security</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>
          <ion-item button lines="none" @click="goTo('/student-attendance-record')">
            <ion-label>Attendance Records</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>
          <ion-item button lines="none" @click="goTo('/facial-recognition')">
            <ion-label>Facial Recognition</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>
          <ion-item button lines="none" @click="goTo('/student-absent-request')">
            <ion-label>Absence Requests</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>
          <ion-item button lines="none" @click="goTo('/student-volunteer-applications')">
            <ion-label>Volunteer Applications</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>
          <ion-item button lines="none" @click="goTo('/help-center')">
            <ion-label>Help Center</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>
        </ion-list>

        <!-- Log Out Button -->
        <div class="logout-button">
          <ion-button expand="block" color="light" @click="logout">Log Out</ion-button>
        </div>
      </div>

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
  IonIcon,
  IonGrid,
  IonRow,
  IonCol,
  IonList,
  IonItem,
  IonLabel,
  IonButton
} from '@ionic/vue';
import { chevronForwardOutline } from 'ionicons/icons';
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';

const student = ref({
  first_name: '',
  middle_name: '',
  last_name: '',
  course_id: '',
  section_id: '',
  year_level_id: '',
});

const courses = ref([]);
const sections = ref([]);
const yearLevels = ref([]);

const fullName = computed(() => {
  const s = student.value;
  return `${s.last_name}, ${s.first_name} ${s.middle_name?.charAt(0)}.`.toUpperCase();
});

const getCourseName = (id: number | string) => {
  const found = courses.value.find((crs) => crs.course_id == id);
  return found ? found.course_code : '';
};
const getYearLabel = (id: number | string) => {
  const found = yearLevels.value.find((lvl) => lvl.YearID == id);
  return found ? found.YearLvl : '';
};
const getSectionName = (id: number | string) => {
  const found = sections.value.find((sec) => sec.section_id == id);
  return found ? found.section_name : '';
};

const courseSection = computed(() => {
  return `${getCourseName(student.value.course_id)} ${getYearLabel(student.value.year_id)} ${getSectionName(student.value.section_id)}`.toUpperCase();
});

const fetchYearLevels = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/year-level/list');
    yearLevels.value = res.data.yearLevels || [];
  } catch (error) {
    console.error('Failed to fetch year levels:', error);
  }
};
const fetchCourses = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/courses/list');
    courses.value = res.data.courses || [];
  } catch (error) {
    console.error('Failed to fetch courses:', error);
  }
};
const fetchSections = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/sections/list');
    sections.value = res.data.sections || [];
  } catch (error) {
    console.error('Failed to fetch sections:', error);
  }
};

// Check session and fetch student
onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/protected', { withCredentials: true });
    if (!res.data.student) {
      window.location.href = '/login';
      return;
    }
    student.value = res.data.student;
  } catch (error) {
    console.error('Session fetch failed:', error);
    window.location.href = '/login';
  }
  await fetchCourses();
  await fetchSections();
  await fetchYearLevels();
});

// Fallback avatar
const onImageError = (event: Event) => {
  const target = event.target as HTMLImageElement;
  target.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(
    fullName.value
  )}&background=ffffff&color=08055e&bold=true&size=128`;
};

// Navigate
const goTo = (path: string) => {
  window.location.href = path;
};

const logout = async () => {
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: 'This will log you out from all devices.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, logout!',
    cancelButtonText: 'Cancel',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });

  if (result.isConfirmed) {
    try {
      await axios.post(
        'http://localhost:5000/api/students/logout-all',
        {},
        { withCredentials: true }
      );

      await Swal.fire({
        title: 'Logged out',
        text: 'You have been logged out from all devices.',
        icon: 'success',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });

      window.location.href = '/login';
    } catch (error) {
      console.error('Logout failed:', error);
      await Swal.fire({
        title: 'Error',
        text: 'Logout failed. Please try again.',
        icon: 'error',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    }
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
  text-align: left;
  padding-bottom: 20px;
  height: 100%;
  display: block;
  padding: 0 !important;
}

/* Profile Header */
ion-grid.header {
  padding: 10px 0;
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

/* Menu Items */
.menu-list {
  background: #fff;
  margin: 5px 10px 0 10px;
  border-radius: 5px;
  padding: 0;
}
ion-item {
  --background: #fff;
  border-bottom: 2px solid #eee;
}
ion-item ion-label {
  font-weight: 600;
  color: #08055e;
}

/* Log Out */
.logout-button {
  margin: 20px 10px;
}
.logout-button ion-button {
  font-weight: bold;
  --background: #fff;
  --color: #08055e;
  border: 2px solid #08055e;
  border-radius: 10px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
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
