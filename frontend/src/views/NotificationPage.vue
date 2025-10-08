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
        <!-- Sub-header -->
        <div class="header-bottom">
          <ion-buttons slot="start"></ion-buttons>
          <h2>NOTIFICATIONS</h2>
          <!-- <ion-button @click="markAllRead" fill="clear" size="small">Mark All Read</ion-button> -->
        </div>

        <!-- Grouped Notification List -->
        <div v-for="(group, label) in groupedNotifications" :key="label" class="notification-group">
          <h4 class="group-label">{{ label }}</h4>
          <ion-list>
            <ion-item
              v-for="notification in group"
              :key="notification.id"
              :class="{ unread: !notification.read }"
              @click="openNotification(notification)"
            >
              <ion-label class="notification-label">
                <span v-if="!notification.read" class="notification-dot"></span>
                <div class="notification-text">
                  <h3>{{ notification.title }}</h3>
                  <p>{{ notification.message }}</p>
                  <!-- <small>{{ formatDate(notification.created_at) }}</small> -->
                </div>
              </ion-label>
            </ion-item>
          </ion-list>
        </div>
      </div>
    </ion-content>

    <!-- Footer -->
    <div class="footer">
      <div class="footer-icons">
        <ion-icon name="home" @click="goTo('/')"></ion-icon>
        <ion-icon name="calendar" @click="goTo('/calendar-page')"></ion-icon>
        <ion-icon name="scan" @click="goTo('/scanner')"></ion-icon>
        <ion-icon name="notifications" @click="goTo('/notifications')"></ion-icon>
        <div class="notif-icon-wrapper">
          <ion-icon name="notifications" @click="goTo('/notifications')" class="active"></ion-icon>
          <span v-if="unreadCount > 0" class="badge-footer">{{ unreadCount }}</span>
        </div>
        <ion-icon name="person" @click="goTo('/profile')"></ion-icon>
      </div>
      <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
    </div>
  </ion-page>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';
import {
  IonPage,
  IonHeader,
  IonContent,
  IonItem,
  IonLabel,
  IonButtons,
  IonBackButton,
  IonIcon,
  IonText,
  IonList,
  IonButton
} from '@ionic/vue';

interface Notification {
  id: number;
  title: string;
  message: string;
  created_at: string;
  read: boolean;
  label?: string;
}

// Logged-in student data
const student = ref<any>(null);
const studentId = ref<number>(0);
const studentCourseId = ref<number>(0);

// Notifications list
const notifications = ref<Notification[]>([]);

// Computed unread count
const unreadCount = computed(() => notifications.value.filter(n => !n.read).length);

// Helper to categorize notifications
const getNotificationLabel = (createdAt: string) => {
  const notifDate = new Date(createdAt);
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);

  const startOfWeek = new Date(today);
  startOfWeek.setDate(today.getDate() - today.getDay()); // Sunday as start

  if (
    notifDate.getFullYear() === today.getFullYear() &&
    notifDate.getMonth() === today.getMonth() &&
    notifDate.getDate() === today.getDate()
  ) {
    return 'Today';
  } else if (
    notifDate.getFullYear() === yesterday.getFullYear() &&
    notifDate.getMonth() === yesterday.getMonth() &&
    notifDate.getDate() === yesterday.getDate()
  ) {
    return 'Yesterday';
  } else if (notifDate >= startOfWeek) {
    return 'This Week';
  } else {
    return notifDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  }
};

// Fetch logged-in student info
const fetchLoggedInStudent = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/protected', { withCredentials: true });
    student.value = res.data.student;
    studentId.value = student.value.id;          
    studentCourseId.value = student.value.course_id;
  } catch (err) {
    console.error('Failed to get logged-in student:', err);
  }
};

// Fetch notifications for the logged-in student
const fetchNotifications = async () => {
  try {
    if (!studentId.value) return;

    const res = await axios.get('http://localhost:5000/api/notifications/list', {
      params: { student_id: studentId.value }
    });

    notifications.value = (res.data || [])
      .filter((notif: any) => {
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
      })
      .map((notif: any) => ({
        id: notif.id,
        title: notif.notif_type,
        message: notif.notif_message,
        created_at: notif.created_at,
        read: notif.read,
        label: getNotificationLabel(notif.created_at)
      }));
  } catch (err) {
    console.error('Failed to fetch notifications:', err);
  }
};

// Computed grouped notifications
const groupedNotifications = computed(() => {
  const groups: Record<string, Notification[]> = {};
  notifications.value.forEach(notif => {
    const label = notif.label || 'Older';
    if (!groups[label]) groups[label] = [];
    groups[label].push(notif);
  });
  return groups;
});

// Open a notification (mark as read)
const openNotification = async (notification: Notification) => {
  if (!notification.read) {
    try {
      await axios.put(
        `http://localhost:5000/api/notifications/mark-read/${notification.id}`,
        { student_id: studentId.value }
      );
      notification.read = true;
    } catch (err) {
      console.error(err);
      Swal.fire('Error', 'Failed to mark notification as read', 'error');
      return;
    }
  }

  Swal.fire({
    icon: 'info',
    title: notification.title,
    text: notification.message,
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });
};

const goTo = (path: string) => {
  window.location.href = path;
};

// Mark all notifications as read
const markAllRead = async () => {
  try {
    await Promise.all(
      notifications.value.map(n =>
        axios.put(`http://localhost:5000/api/notifications/mark-read/${n.id}`, {
          student_id: studentId.value
        })
      )
    );
    notifications.value.forEach(n => (n.read = true));

    Swal.fire({
      icon: 'success',
      title: 'All notifications marked as read!',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  } catch (err) {
    console.error(err);
    Swal.fire('Error', 'Failed to mark all notifications as read', 'error');
  }
};

// Format date nicely
const formatDate = (dateStr: string | null | undefined) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  if (isNaN(date.getTime())) return '';
  return date.toLocaleString('en-US', { dateStyle: 'medium', timeStyle: 'short' });
};

// ----- Auto-refresh interval -----
let refreshInterval: number | undefined;

const refreshNotifications = async () => {
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
  } catch (err) {
    console.error('Failed to refresh notifications:', err);
  }
};

// On component mount
onMounted(async () => {
  await fetchLoggedInStudent();
  await fetchNotifications();

  // Start auto-refresh every 10 seconds
  refreshInterval = window.setInterval(refreshNotifications, 10000);
});

// Clear interval on unmount
onUnmounted(() => {
  if (refreshInterval) clearInterval(refreshInterval);
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
  padding: 0;
  text-align: left;
  padding-bottom: 20px;
  height: 100%;
  display: block;
  text-align: center;
  padding-top: 0 !important;
}

h2 {
  color: yellow;
  font-weight: 700;
}

/* Notification group label */
.group-label {
  font-weight: bold;
  margin: 10px 0;
  color: #fff;
  background-color: #08055e;
  text-align: left;
  border-top: 2px solid #fff;
  border-bottom: 2px solid #fff;
  padding: 2px 15px;
}
.list-md {
  background-color: #D9D9D9 !important;
}
::v-deep(ion-item::part(native)) {
  background-color: #D9D9D9;
}
/* Footer styles */
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

/* Badge on footer notifications icon */
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

/* Unread notifications highlight */
ion-item.unread {
  background-color: #fff3cd;
  border-left: 5px solid #07055D;
}

.notification-label {
  display: flex;
  align-items: center;
  color: #07055D;
}

.notification-dot {
  width: 10px;
  height: 10px;
  background-color: red;
  border-radius: 50%;
  margin-right: 10px;
}

.notification-text h3 {
  font-weight: bold;
}
</style>
