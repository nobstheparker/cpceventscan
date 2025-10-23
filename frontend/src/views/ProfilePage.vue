<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <div class="logo">
          <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
        </div>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <div id="container">
        <!-- Profile Header -->
        <ion-grid class="header">
          <ion-row>
            <!-- Profile Image or Initials -->
            <ion-col size="3" class="image">
              <div v-if="!studentImage" class="initials-placeholder">
                {{ getInitials(student.first_name, student.last_name) }}
              </div>
              <img
                v-else
                :src="studentImage"
                alt="Profile Image"
                @error="onImageError"
              />
            </ion-col>

            <!-- Student Info -->
            <ion-col size="9" class="info">
              <h1>{{ fullName }}</h1>
              <span>{{ courseSection }}</span>
            </ion-col>
          </ion-row>
        </ion-grid>

        <!-- Menu Options -->
        <ion-list class="menu-list">
          <ion-item button lines="none" detail="false" @click="goTo('/personal-info')">
            <ion-label>Personal Information</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>

          <ion-item button lines="none" detail="false" @click="goTo('/account-security')">
            <ion-label>Account Security</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>

          <ion-item button lines="none" detail="false" @click="goTo('/student-attendance-record')">
            <ion-label>Attendance Records</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>

          <ion-item button lines="none" detail="false" @click="goTo('/facial-recognition')">
            <ion-label>Facial Recognition</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>

          <ion-item button lines="none" detail="false" @click="goTo('/student-absent-request')">
            <ion-label>Absence Requests</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>

          <ion-item button lines="none" detail="false" @click="goTo('/student-volunteer-applications')">
            <ion-label>Volunteer Applications</ion-label>
            <ion-icon :icon="chevronForwardOutline" slot="end" />
          </ion-item>

          <ion-item button lines="none" detail="false" @click="goTo('/help-center')">
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
          <div class="notif-icon-wrapper">
            <router-link to="/notifications">
              <ion-icon name="notifications" @click="goTo('/notifications')"></ion-icon>
              <span v-if="unreadCount > 0" class="badge-footer">{{ unreadCount }}</span>
            </router-link>
          </div>
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

// --- Student Data ---
const student = ref({
  first_name: '',
  middle_name: '',
  last_name: '',
  course_id: '',
  section_id: '',
  year_id: '',
  face_image: ''
});

const courses = ref([]);
const sections = ref([]);
const yearLevels = ref([]);

const studentImage = ref('');
const studentId = ref<number>(0);
const studentCourseId = ref<number>(0);

const fullName = computed(() => {
  const s = student.value;
  return `${s.last_name}, ${s.first_name} ${s.middle_name?.charAt(0) || ''}.`.toUpperCase();
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

// --- Fetch Lists ---
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

// --- Notifications ---
interface Notification {
  id: number;
  title: string;
  message: string;
  created_at: string;
  read: boolean;
  label?: string;
}

const notifications = ref<Notification[]>([]);
const unreadCount = ref(0);

const getNotificationLabel = (createdAt: string) => {
  const notifDate = new Date(createdAt);
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);

  if (notifDate.toDateString() === today.toDateString()) return 'Today';
  else if (notifDate.toDateString() === yesterday.toDateString()) return 'Yesterday';
  else
    return notifDate.toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric'
    });
};

const fetchNotifications = async () => {
  if (!studentId.value) return;

  try {
    const res = await axios.get('http://localhost:5000/api/notifications/list', {
      params: { student_id: studentId.value }
    });

    const filtered = (res.data || []).filter((notif: any) => {
      const selectedStudents = Array.isArray(notif.selected_students)
        ? notif.selected_students
        : JSON.parse(notif.selected_students || '[]');

      const selectedCourses = Array.isArray(notif.selected_courses)
        ? notif.selected_courses
        : JSON.parse(notif.selected_courses || '[]');

      return (
        notif.recipient_mode === 'all' ||
        selectedStudents.includes(studentId.value) ||
        selectedCourses.includes(studentCourseId.value)
      );
    });

    notifications.value = filtered.map((notif: any) => ({
      id: notif.id,
      title: notif.notif_type,
      message: notif.notif_message,
      created_at: notif.created_at,
      read: notif.read,
      label: getNotificationLabel(notif.created_at)
    }));

    unreadCount.value = notifications.value.filter((n) => !n.read).length;
  } catch (err) {
    console.error('Failed to fetch notifications:', err);
  }
};

// --- Initials fallback ---
const getInitials = (first: string, last: string) => {
  if (!first && !last) return '';
  const firstInitial = first ? first.charAt(0).toUpperCase() : '';
  const lastInitial = last ? last.charAt(0).toUpperCase() : '';
  return `${firstInitial}${lastInitial}`;
};

// --- Lifecycle ---
onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/protected', { withCredentials: true });

    if (res.data.message !== 'Authenticated') {
      window.location.href = '/login';
      return;
    }

    student.value = res.data.student;
    studentId.value = student.value.id;
    studentCourseId.value = student.value.course_id;

    // ✅ If face image exists, show it; otherwise fallback to initials
    if (student.value.face_image) {
      studentImage.value = `http://localhost:5000/uploads/${student.value.face_image}`;
    } else {
      studentImage.value = '';
    }
  } catch (error) {
    console.error('Session fetch failed:', error);
    window.location.href = '/login';
  }

  await fetchCourses();
  await fetchSections();
  await fetchYearLevels();
  await fetchNotifications();
});

// --- Fallback Avatar ---
const onImageError = (event: Event) => {
  const target = event.target as HTMLImageElement;
  target.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(
    fullName.value
  )}&background=ffffff&color=08055e&bold=true&size=128`;
};

// --- Navigation & Logout ---
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
      await axios.post('http://localhost:5000/api/students/logout-all', {}, { withCredentials: true });

      await Swal.fire({
        title: 'Logged out',
        text: 'You have been logged out.',
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
ion-item ion-icon {
  color: #08055e;
  font-size: 20px;
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

ion-list.menu-list {
  background: #fff !important;
}

ion-item {
  --background: #fff !important;
  --color: #000 !important;
  color: #000 !important;
}

ion-item::part(native) {
  color: #000 !important;
}

ion-label {
  color: #000 !important;
  font-weight: 500;
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
.logout-button ion-button::part(native) {
    font-weight: 700;
    --background: #fff !important;
    border-radius: 10px;
    color: #000 !important;
    box-shadow: 0 2px 5px rgba(0, 0, 0, .15);
    background: #fff !important;
}
.initials-placeholder {
    margin: 0 auto;
    display: flex;
    align-items: center;
    border-radius: 100%;
    font-size: 26px;
    justify-content: center;
    background: #ff0;
    color: #08055e;
    width: 70px;
    height: 70px;
    padding: 5px 0 !important;
    font-weight: 700;
    border: 3px solid #fff;
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
.notif-icon-wrapper {
  position: relative;
  display: inline-block;
}

.badge-footer {
  position: absolute;
  top: -5px;
  right: -10px;
  background-color: red;
  color: white;
  border-radius: 50%;
  font-size: 12px;
  padding: 2px 6px;
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
