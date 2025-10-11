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
import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
  IonModal,
  IonButton,
  useIonRouter,
} from "@ionic/vue";
import { ref, computed, onMounted, onBeforeUnmount, nextTick, onUnmounted } from "vue";
import axios from 'axios';

const router = useIonRouter();

// --- Date & Calendar ---
const currentDate = ref(new Date());
const year = computed(() => currentDate.value.getFullYear());
const month = computed(() => currentDate.value.getMonth());
const monthName = computed(() => {
  const monthNames = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December",
  ];
  return monthNames[month.value];
});
const daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
const daysInMonth = computed(() => {
  const firstDayOfMonth = new Date(year.value, month.value, 1).getDay();
  const lastDate = new Date(year.value, month.value + 1, 0).getDate();
  const cells: number[] = [];
  for (let i = 0; i < firstDayOfMonth; i++) cells.push(0);
  for (let i = 1; i <= lastDate; i++) cells.push(i);
  return cells;
});

// --- Student & Notifications ---
const student = ref<any>(null);
const studentId = ref<number>(0);
const studentCourseId = ref<number>(0);

interface Notification {
  id: number;
  title: string;
  message: string;
  created_at: string;
  read: boolean;
  label?: string;
}

const notifications = ref<Notification[]>([]);
const unreadCount = computed(() => notifications.value.filter(n => !n.read).length);

const getNotificationLabel = (createdAt: string) => {
  const notifDate = new Date(createdAt);
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);

  const startOfWeek = new Date(today);
  startOfWeek.setDate(today.getDate() - today.getDay());

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

// --- Fetch logged-in student ---
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

// --- Updates/Announcements ---
const updates = ref<{ id: number; name: string; description: string; status: string }[]>([]);
const fetchUpdatesForAnnouncements = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/updates');
    updates.value = res.data.filter((u: any) => u.status === 'Active');
    console.log('Active updates:', updates.value);
  } catch (error) {
    console.error('Failed to fetch updates:', error);
  }
};

// --- Events ---
const events = ref<any[]>([]);
const fetchEvents = async () => {
  try {
    const res = await fetch('http://localhost:5000/api/events/list');
    if (!res.ok) throw new Error('Failed to fetch events');
    const data = await res.json();
    events.value = data.map((event: any) => ({
      ...event,
      date: event.start_date_time.slice(0, 10),
    }));
  } catch (error) {
    console.error(error);
  }
};

const getEventsForDay = (day: number) => {
  if (day === 0) return [];
  const dateStr = `${year.value}-${String(month.value + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
  return events.value.filter(e => e.date === dateStr);
};

const prevMonth = () => {
  currentDate.value = new Date(year.value, month.value - 1, 1);
  closeDropdown();
};
const nextMonth = () => {
  currentDate.value = new Date(year.value, month.value + 1, 1);
  closeDropdown();
};

// --- Dropdown calendar ---
const isDropdownOpen = ref(false);
const dropdownDay = ref<number | null>(null);
const dropdownPosition = ref<{ top: number; left: number } | null>(null);
const dropdownDirection = ref<'left' | 'right'>('right');

const closeDropdown = () => {
  isDropdownOpen.value = false;
  dropdownDay.value = null;
  dropdownPosition.value = null;
};

const positionDropdown = (target: HTMLElement) => {
  const container = target.closest('.calendar-container');
  if (!container) return;
  const containerRect = container.getBoundingClientRect();
  const targetRect = target.getBoundingClientRect();
  const containerWidth = containerRect.width;
  const targetLeft = targetRect.left - containerRect.left;

  if (targetLeft < containerWidth / 2) {
    dropdownDirection.value = 'right';
    dropdownPosition.value = { top: targetRect.bottom - containerRect.top + 6, left: targetLeft };
  } else {
    dropdownDirection.value = 'left';
    dropdownPosition.value = { top: targetRect.bottom - containerRect.top + 6, left: targetLeft + targetRect.width };
  }
};

const dropdownPositionStyle = computed(() => {
  if (!dropdownPosition.value) return {};
  if (dropdownDirection.value === 'right') {
    return { top: `${dropdownPosition.value.top}px`, left: `${dropdownPosition.value.left}px`, right: 'auto' };
  } else {
    return { top: `${dropdownPosition.value.top}px`, right: `${dropdownPosition.value.left}px`, left: 'auto' };
  }
});

const handleDayClick = (day: number, event: MouseEvent | KeyboardEvent) => {
  event.stopPropagation();
  const dayEvents = getEventsForDay(day);
  if (day === 0 || dayEvents.length === 0) {
    closeDropdown();
    return;
  }
  if (isDropdownOpen.value && dropdownDay.value === day) {
    closeDropdown();
    return;
  }
  dropdownDay.value = day;
  isDropdownOpen.value = true;
  nextTick(() => {
    positionDropdown(event.currentTarget as HTMLElement);
  });
};

// --- Modal for event ---
const selectedEvent = ref<any>(null);
const modalOpen = ref(false);

const selectEvent = (event: any) => {
  selectedEvent.value = event;
  modalOpen.value = true;
  closeDropdown();
};

const closeModal = () => {
  modalOpen.value = false;
  selectedEvent.value = null;
};

// --- Click outside & Esc key ---
const onClickOutside = (event: MouseEvent) => {
  const dropdown = document.querySelector('.events-dropdown');
  if (dropdown && !dropdown.contains(event.target as Node)) closeDropdown();
};
const onKeyDown = (event: KeyboardEvent) => {
  if (event.key === 'Escape') closeDropdown();
};

// --- Session check ---
const checkSession = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/protected', { withCredentials: true });
    if (response.data.message === 'Authenticated') {
      router.push('/');
    } else {
      router.push('/login');
    }
  } catch {
    router.push('/login');
  }
};

// --- Notifications ---
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

      return notif.recipient_mode === 'all'
        || selectedStudents.includes(studentId.value)
        || selectedCourses.includes(studentCourseId.value);
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

// --- Event navigation ---
const handleApplyClick = () => {
  modalOpen.value = false;
  const eventName = selectedEvent.value.event_name;
  const eventDate = selectedEvent.value.start_date_time;
  const eventId = selectedEvent.value.id;

  setTimeout(() => {
    router.push({
      path: '/application-form',
      query: { id: eventId, name: eventName, date: eventDate }
    });
  }, 300);
};

const handleAbsenceClick = () => {
  modalOpen.value = false;
  const eventName = selectedEvent.value.event_name;
  const eventDate = selectedEvent.value.start_date_time;
  const eventId = selectedEvent.value.id;

  setTimeout(() => {
    router.push({
      path: '/absence-request-form',
      query: { id: eventId, name: eventName, date: eventDate }
    });
  }, 300);
};

// --- Accessibility ---
const getAriaLabel = (day: number) => {
  if (day === 0) return 'Empty day';
  const evts = getEventsForDay(day);
  return `${day}${evts.length ? ', has event(s)' : ''}`;
};

// --- Lifecycle ---
onMounted(async () => {
  await fetchLoggedInStudent();
  fetchEvents();
  checkSession();
  fetchUpdatesForAnnouncements();
  await refreshNotifications(); // fetch immediately
  document.addEventListener('click', onClickOutside);
  document.addEventListener('keydown', onKeyDown);
  refreshInterval = window.setInterval(refreshNotifications, 10000);
});

onUnmounted(() => {
  if (refreshInterval) clearInterval(refreshInterval);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', onClickOutside);
  document.removeEventListener('keydown', onKeyDown);
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
