<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
          <div class="logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <div id="container">
        <div class="welcome">
          <h1>Hello, <span>CPCnian's!</span></h1>
          <small>Welcome to Your Hub for Engagement and Growth!</small>
          <p>
            We’re thrilled to have you on board! Use our platform to keep track
            of your attendance, get involved in volunteer opportunities, and
            connect with your fellow students. Together, let’s make a
            difference and create lasting memories!
          </p>
        </div>
        <div class="calendar-container" ref="calendarContainer">
          <h1>Monthly Events Calendar</h1>
          <div class="box-container">
            <div class="calendar-header">
              <button @click="prevMonth" aria-label="Previous Month">&lt;</button>
              <h2>{{ monthName }} <span>{{ year }}</span></h2>
              <button @click="nextMonth" aria-label="Next Month">&gt;</button>
            </div>
            <div class="calendar-grid" role="grid" aria-label="Monthly calendar grid">
              <div
                class="calendar-cell header-cell"
                v-for="day in daysOfWeek"
                :key="day"
                role="columnheader"
              >
                {{ day }}
              </div>
              <div
                v-for="(day, index) in daysInMonth"
                :key="index"
                class="calendar-cell"
                :class="{ 'inactive': day === 0, 'event': getEventsForDay(day).length > 0, 'selected': isDropdownOpen && dropdownDay === day }"
                @click="handleDayClick(day, $event)"
                role="gridcell"
                tabindex="0"
                @keydown.enter.prevent="handleDayClick(day, $event)"
                :aria-label="getAriaLabel(day)"
              >
                {{ day === 0 ? '' : day }}

                <div
                  v-if="isDropdownOpen && dropdownDay === day && dropdownPosition"
                  class="events-dropdown"
                  :class="dropdownDirection === 'left' ? 'dropdown-left' : 'dropdown-right'"
                  :style="dropdownPositionStyle"
                  tabindex="0"
                  role="list"
                  @click.stop
                  @keydown.escape="closeDropdown"
                  ref="dropdownRef"
                >
                  <div class="dropdown-header">
                    Events on {{ monthName }} {{ day }}, {{ year }}
                  </div>
                  <ul>
                    <li
                      v-for="(event, i) in getEventsForDay(day)"
                      :key="i"
                      role="listitem"
                      tabindex="0"
                      class="dropdown-event-item"
                      @click="selectEvent(event)"
                    >
                      {{ event.event_name  }}
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
          <small class="notes">Note: Click on dates to see event details.</small>
        </div>
        <div class="bottom-content">
          <h2>Announcements &amp; Reminders:</h2>
          <ul>
            <li v-for="update in updates" :key="update.id">
              <p>{{ update.name }}: {{ update.description }}</p>
            </li>
          </ul>
          <p v-if="updates.length === 0">No announcements at the moment.</p>
        </div>
        <div class="footer">
          <div class="footer-icons">
            <router-link to="/">
              <ion-icon name="home" class="active"></ion-icon>
            </router-link>

            <router-link to="/calendar-page">
              <ion-icon name="calendar"></ion-icon>
            </router-link>

            <router-link to="/scanner">
              <ion-icon name="scan"></ion-icon>
            </router-link>
            <div class="notif-icon-wrapper">
              <router-link to="/notifications">
                <ion-icon name="notifications"></ion-icon>
                <span v-if="unreadCount > 0" class="badge-footer">{{ unreadCount }}</span>
              </router-link>
            </div>
            <router-link to="/profile">
              <ion-icon name="person"></ion-icon>
            </router-link>
          </div>
          <ion-text>
            <small>&copy; All Rights Reserved PPG 2025.</small>
          </ion-text>
        </div>
      </div>
      <ion-modal
        :is-open="modalOpen"
        @didDismiss="closeModal"
        class="custom-modal"
        aria-modal="true"
        role="dialog"
        aria-labelledby="modal-title"
      >
        <ion-content>
          <ion-toolbar>
            <ion-title id="modal-title" class="event-title">
              {{ selectedEvent.event_name }}
            </ion-title>
          </ion-toolbar>
          <div class="modal-content" role="document" v-if="selectedEvent">
             <p class="notes">Notes: {{ selectedEvent.event_note }}</p>

            <div class="image">
             <img
                :src="`http://localhost:5000/${selectedEvent.event_program_attachment}`"
                alt="Program Itinerary"
                class="program-img"/>
            </div>

            <div class="reminders">
              <h4>Reminder:</h4>
              <p>{{ selectedEvent.event_reminder }}</p>
              <h4 class="call">Call to Action: </h4>
              <p>
               {{ selectedEvent.call_to_action_buttons_instruction }}
              </p>
            </div>
            <div class="button-container">
              <ion-button
                v-if="selectedEvent.volunteer_application"
                class="btn-apply"
                fill="solid"
                shape="round"
                size="default"
                @click="handleApplyClick"
              >
                Apply Here
              </ion-button>

              <ion-button
                v-if="selectedEvent.absence_request"
                class="btn-absence"
                fill="solid"
                shape="round"
                size="default"
                @click="handleAbsenceClick"
              >
                Absence Request
              </ion-button>
            </div>
          </div>
        </ion-content>
        <div class="footer-modal"></div>
      </ion-modal>
    </ion-content>
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
  max-width: 768px !important;
  margin: 0 auto;
  color: #fff;
}

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
.login-title {
  color: #fff !important;
}
#container {
    margin-top: 0 !important;
    text-align:  left !important;
    padding-top: 20px !important;
    padding: 0;
    display: block !important;
}
.welcome {
    padding-left: 20px !important;
    padding-right: 20px !important;
    padding: 20px;
}
.welcome h1 {
    font-weight: 700;
    color: #fff;
    margin-bottom: 0 !important;
    font-size: 32px;
}
.welcome h1 span {
    color: #FFFF00;
}
.welcome small {
    color: #fff;
    font-weight: 500;
    margin-top: 8px !important;
    display: block;
    font-size: 15px;
}
.welcome p {
    color: #fff;
    font-weight: 300;
    font-size: 15px;
    line-height: 1.8em;
}
.box-container {
    border: 1px solid #07055D;
    padding: 5px;
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
.notes {
    color: #07055D !important;
}
ion-label {
  font-size: 24px !important;
  color: #000 !important;
  padding-bottom: 10px !important;
}

ion-input {
  --padding-start: 10px;
  background-color: #fff;
  margin-top: 10px !important;
  color: #000;
}

.login-button {
  --background: #07055D;
  --background-activated: #05044a;
  --border-radius: 8px;
  font-weight: bold;
  margin-top: 10px;
}
.user-icon{
  text-align: center;
}
.user-icon img{
  height: 100px;
}

.calendar-container {
  background-color: #fff;
  padding: 16px;
  margin-top: 30px;
  color: #333;
  padding-top: 12px;
}
.calendar-container h1 {
    text-align: center;
    font-size: 20px;
    margin-top: 0;
    color: #07055D;
    font-weight: 600;
}

.calendar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
  text-transform: uppercase;
}

.calendar-header h2 {
  font-size: 1.5em;
  margin: 0;
  color: #07055D;
  font-weight: 700;
}

.calendar-header button {
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  padding: 5px 10px;
  color: #07055D;
}

.calendar-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 5px;
}

.calendar-cell {
  text-align: center;
  padding: 0;
  border: 1px solid #07055D;
  color: #07055D;
}

.header-cell {
  font-weight: bold;
  text-transform: uppercase;
  color: #07055D;
  border: 0;
  font-size: 14px;
}

.inactive {
  color: #ccc;
}

.event {
  background-color: yellow;
}

.bottom-content {
    padding-left: 20px !important;
    padding-right: 20px !important;
    padding-bottom: 40px !important;
}
.bottom-content h2 {
    font-size: 20px;
    color: #FFFF00;
    text-align: center;
    margin-top: 40px;
    margin-bottom: 20px;
}
.bottom-content p{
    color: #fff;
    font-size: 14px;
    margin: 5px 0;
}
.footer {
    position: sticky;
    bottom: 0;
    width: 100%;
    display: block;
}
ion-text {
    margin: 10px 0;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px;
    font-size: 14px;
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

.copyright {
  text-align: center;
  color: #fff;
  display: block;
}
ion-footer {
    position: relative;
}
.modal-content {
  padding: 10px;
  margin-top: 55px;
}

.custom-modal {
  --width: auto;
  --height: auto;
  --max-width: 80%;
  --max-height: 80%; 
  --overflow: hidden;
  --border-radius: 10px;
}

.custom-modal ion-toolbar {
    position: fixed;
}

.custom-modal::part(content) {
  position: relative;
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;
  border-radius: 10px;
  overflow: hidden;
}
ion-title.event-title {
    text-align: center;
    color: #FFFF00;
    font-weight: 700;
}
.modal-content .date {
    text-align: center;
    margin: 0;
    color: #07055D;
    font-weight: 500;
}
.modal-content .notes{
    font-size: 12px !important;
}
.reminders {
    margin-bottom: 10px;
}
.reminders h4 {
    font-weight: 700;
    color: #07055D;
    font-size: 14px;
    margin-bottom: 0;
    margin-top: 8px;
}
.reminders p {
    font-size: 11px !important;
    color: #07055D;
    margin-bottom: 0;
    margin-top: 5px;
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
.call {
    margin-top: 15px !important;
}
.button-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
  margin: 0 auto;
}

ion-button.btn-apply {
  color: #fff;
  font-weight: 600;
  width: 100% !important;
  font-size: 12px !important;
  border-radius: 5px;
}

ion-button.btn-absence {
  --color: #4f46e5;
  font-weight: 600;
  width: 100% !important;
  font-size: 12px !important;
  border-radius: 5px;
}
.button-container ion-button {
    font-size: 12px !important;
    text-transform: uppercase;
    color: #FFFF00 !important;
    background: #07055D !important;
}
.button-container ion-button::part(native){
    margin: 0 !important;
    background-color: transparent !important;
    border: 0 !important;
}
.footer-modal {
    display: block;
    height: 20px;
    background: #07055d;
}
.events-dropdown {
  position: absolute;
  background: #fff;
  border: 1px solid #07055D;
  border-radius: 8px;
  box-shadow: 0 8px 16px rgba(7, 5, 93, 0.3);
  z-index: 1000;
  width: 220px;
  max-height: 200px;
  overflow-y: auto;
  padding: 8px 12px;
  font-size: 14px;
  color: #07055D;
  user-select: none;
}

.events-dropdown.dropdown-left {
  right: 18% !important;
  left: auto;
  margin-right: 6px;
  top: auto !important;
}

.events-dropdown.dropdown-right {
  left: 0 !important;
  margin-left: 14px;
  top: auto !important;
}

.events-dropdown .dropdown-header {
  font-weight: 700;
  margin-bottom: 8px;
  border-bottom: 1px solid #ddd;
  padding-bottom: 4px;
  user-select: none;
}

.events-dropdown ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.events-dropdown li {
  padding: 6px 4px;
  cursor: default;
  user-select: text;
  transition: background-color 0.2s ease;
  border-bottom: 2px solid;
  text-align: left;
  font-weight: 400;
}
.events-dropdown li:hover{
  background-color: red;
}

.events-dropdown li:hover,
.events-dropdown li:focus {
  background-color: #07055d22;
  outline: none;
}

.calendar-cell.selected {
  background-color: #ffff00aa;
  color: #07055D !important;
  font-weight: 700;
  box-shadow: 0 0 5px #ffff00cc inset;
  position: relative;
}
</style>