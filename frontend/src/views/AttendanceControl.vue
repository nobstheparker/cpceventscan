<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
          <div class="admin-logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
        </div>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ad-background">
      <div class="content-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">
          <router-link to="/dashboard" class="sidebar-title">Dashboard</router-link>
          <ul>
            <li>
              <div class="sidebar-link" @click="toggleStudentMenu">Student Management</div>
              <ul v-show="showStudentMenu">
                <li><router-link to="/register" class="sub">Register Student</router-link></li>
                <li><router-link to="/view" class="sub">View & Manage Students</router-link></li>
                <li><router-link to="/recovery" class="sub">Manage 2FA/Recovery</router-link></li>
                <li><router-link to="/facereset" class="sub">Reset Facial Verification</router-link></li>
              </ul>
            </li>
            <li>
              <div class="sidebar-link" @click="toggleAcadMenu">Academic Curriculum</div>
              <ul v-show="showAcadMenu">
                <li><router-link to="/register-course" class="sub">Register Course</router-link></li>
                <li><router-link to="/view-course" class="sub">View Courses</router-link></li>
                <li><router-link to="/add-year" class="sub">Add Year Level</router-link></li>
                <li><router-link to="/view-year" class="sub">View Year Level</router-link></li>
                <li><router-link to="/add-sec" class="sub">Add Section</router-link></li>
                <li><router-link to="/view-sec" class="sub">View Section</router-link></li>
              </ul>
            </li>
            <li>
              <div class="sidebar-link" @click="toggleEventMenu">Event Management</div>
              <ul v-show="showEventMenu">
                <li><router-link to="/create" class="sub">Create Event</router-link></li>
                <li><router-link to="/event-lists" class="sub">Event List</router-link></li>
                <li><router-link to="/attendance-page" class="sub">Attendance Page Control</router-link></li>
                <li><router-link to="/attendance-records" class="sub">View Attendance Records</router-link></li>
              </ul>
            </li>
            <li><router-link to="/Request" class="sidebar-link">Request Management</router-link></li>
            <li><router-link to="/Notif" class="sidebar-link">Notification Management</router-link></li>
            <li><router-link to="/Feed" class="sidebar-link">Feedback Management</router-link></li>
            <li><router-link to="/Update" class="sidebar-link">Featured Updates</router-link></li>
            <li><router-link to="/account-center" class="sidebar-link">Account Center</router-link></li>
            <li>
              <router-link to="/adminLogIn" class="sidebar-link" @click="confirmLogout">Log Out</router-link>
            </li>
          </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
          <h4>ATTENDANCE CONTROLS</h4>
          <div style="--background: transparent;">
            <!-- Search & Sort -->
            <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
              <ion-col size="7">
              </ion-col>
              <ion-col size="5">
                <ion-searchbar
                  v-model="searchQuery"
                  class="white-searchbar"
                  placeholder="Search..."
                  animated
                />
              </ion-col>
            </ion-row>

            <!-- Attendance Table -->
            <div style="overflow-x: auto;">
              <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
                <thead>
                  <tr>
                    <th style="cursor:pointer;" @click="sortData('eventName')">
                      Event Name
                      <span v-if="sortColumn === 'eventName'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('eventDate')">
                      Date
                      <span v-if="sortColumn === 'eventDate'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('enabledControl')">
                      Enabled Control
                      <span v-if="sortColumn === 'enabledControl'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="attendcontrol in paginatedControls" :key="attendcontrol.eventID">
                    <td>{{ attendcontrol.eventName }}</td>
                    <td>{{ formatDate(attendcontrol.eventDate) }}</td>
                    <td>{{ attendcontrol.enabledControl }}</td>
                    <td>
                      <ion-button size="small" fill="solid"
                        style="--background: #F1C204;--color: black; --border-radius: 3px; font-weight: 600; "
                        expand="block"
                        @click="openTriviaModal(attendcontrol)">
                        Manage Trivia/Mid Event
                      </ion-button>

                      <ion-button size="small" fill="solid"
                        style="--background:#030238;--color: white; --border-radius: 3px; font-weight: 600;"
                        expand="block"
                        @click="openAttendanceModal(attendcontrol)">
                        Attendance Controls
                      </ion-button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Pagination -->
            <div class="pagination-container">
              <button :disabled="currentPage === 1" @click="currentPage--" class="pagination-button">&laquo; Prev</button>
              <button v-for="page in totalPages" :key="page"
                :class="['pagination-button', { active: currentPage === page }]">
                {{ page }}
              </button>
              <button :disabled="currentPage === totalPages" @click="currentPage++" class="pagination-button">Next &raquo;</button>
            </div>
          </div>

          <!-- Trivia Modal -->
          <ion-modal :is-open="isTriviaModalOpen" @didDismiss="isTriviaModalOpen = false">
            <div style="background:white; border-radius:8px; overflow:hidden; margin-top: 10px;">
              <div style="background:#07055D; color:white; padding:10px; display:flex; justify-content:space-between; align-items:center;">
                <b>Create Trivia Question</b>
                <button @click="isTriviaModalOpen = false" style="background:none; border:none; color:white; font-size:18px;">✖</button>
              </div>

              <div style="padding:8px 15px; background:#D9D9D9;">
                <label><b>Question:</b></label>
                <input v-model="trivia.question" placeholder="Enter question"
                  style="width:100%; padding:6px; margin-bottom:8px; margin-top:3px; border:1px solid #b1b1b2; border-radius:4px;background-color: #ffff;font-size: 14px;color: black;" />

                <div v-for="(opt, index) in trivia.options" :key="index">
                  <label>Option {{ index+1 }}:</label>
                  <input v-model="trivia.options[index]" placeholder="Enter option"
                    style="width:100%; padding:6px; margin-bottom:3px; border:1px solid #b1b1b2;background-color: #ffffff; border-radius:4px; margin-top: 3px; color: black; font-size: 14px;" />
                </div>

                <label><b>Correct Answer:</b></label>
                <select v-model="trivia.correct"
                  style="width:100%; padding:4px; border:1px solid #b1b1b2; border-radius:4px; background-color: white; margin: 0 auto; color: black; font-size: 12px;">
                  <option v-for="(opt, i) in trivia.options" :key="i" :value="opt">{{ opt }}</option>
                </select>
                <ion-button fill="solid" style="--background: #07055d;--color: #ffff00; --margin-bottom: 8px; font-weight: 700;margin: 0 auto;display: flex;margin-top: 10px;width: 100px;;" @click="saveTrivia">Save</ion-button>
              </div>
              <div style="background:#07055D; padding:10px; text-align:right; height: 50px;"></div>
            </div>
          </ion-modal>

          <!-- Attendance Controls Modal -->
          <ion-modal :is-open="isAttendanceModalOpen" @didDismiss="isAttendanceModalOpen = false">
            <div style="background:white; border-radius:8px; overflow-y:scroll; margin-top: 10px;">
              <div style="background:#07055D; color:white; padding:10px; display:flex; justify-content:space-between; align-items:center; height: 50px;">
                <b>{{ selectedEvent?.eventName }} Attendance Control</b>
                <button @click="isAttendanceModalOpen = false" style="background:none; border:none; font-size:22px; margin-right: 5px;">✖</button>
              </div>

              <div style="padding:10px; background:#e7e7e7;">
                <p style="color: #000000; margin-top: 2px !important; margin-bottom: 3px !important;"><b>Instructions:</b></p>
                <ul style="color: #000000; margin-top: 2px !important;">
                  <li>Use the toggle to enable or disable specific features for the event.</li>
                  <li>Save & Publish will apply the changes and make the settings live.</li>
                  <li>Changes are automatically reflected on the student’s attendance page once published.</li>
                </ul>

                <table style="width:100%; border-collapse:collapse; margin-top:10px;border: 2px solid #07055d;">
                  <thead>
                    <tr>
                      <th style="border-bottom:1px solid #ddd;">Setting</th>
                      <th style="border-bottom:1px solid #ddd;">Status</th>
                      <th style="border-bottom:1px solid #ddd;">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(setting, idx) in attendanceSettings" :key="idx">
                      <td>{{ setting.label }}</td>
                      <td>{{ setting.active ? 'Active' : 'Inactive' }}</td>
                      <td>
                        <ion-toggle 
                          v-model="setting.active"
                          style="--track-background: #0000bd5c; --track-background-checked: #08055e; --handle-background: #2c2c7a;--handle-background-checked:#2c2c7a;">
                        </ion-toggle>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <ion-button fill="solid" style="--background:#030238;--color:#ffff00;display: flex; margin: auto; margin-top: 15px; margin-bottom: 5px; width: 185px; font-weight: 700;" @click="saveAttendanceControls">Save & Deploy</ion-button>
              </div>
              <div style="background:#07055D; padding:10px; text-align:right; height: 45px;"></div>
            </div>
          </ion-modal>
        </div>
      </div>
    </ion-content>

    <!-- Footer -->
    <div class="footer">
      <ion-text>
        <small>&copy; All Rights Reserved PPG 2025.</small>
      </ion-text>
    </div>
  </ion-page>
</template>

<script setup lang="ts">
import {
  IonButton, IonCol, IonContent, IonHeader, IonIcon, IonPage, IonRow, IonSearchbar, IonText, IonToolbar, IonToggle, IonModal
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { computed, ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();

/* Logout */
const confirmLogout = async () => {
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: 'You will be logged out and redirected to the login page.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, log me out!',
    didOpen: () => {
      document.body.classList.remove("swal2-height-auto");
      document.documentElement.classList.remove("swal2-height-auto");
    }
  });
  if (result.isConfirmed) router.push('/login');
};

// Sidebar toggles
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => showStudentMenu.value = !showStudentMenu.value;
const toggleAcadMenu = () => showAcadMenu.value = !showAcadMenu.value;
const toggleEventMenu = () => showEventMenu.value = !showEventMenu.value;

// Table controls
const sortColumn = ref('');
const sortOrder = ref<'asc' | 'desc'>('asc');
const searchQuery = ref('');
const currentPage = ref(1);
const itemsPerPage = 10;

interface AttendanceControl {
  eventID: number;
  eventName: string;
  eventDate: string;
  enabledControl: string;
  settings?: Record<string, number>;
}

const attendanceControls = ref<AttendanceControl[]>([]);
const filteredData = computed(() => {
  let result = Array.isArray(attendanceControls.value) ? [...attendanceControls.value] : [];
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(item =>
      Object.values(item).some(val => String(val).toLowerCase().includes(query))
    );
  }
  if (sortColumn.value) {
    const column = sortColumn.value as keyof AttendanceControl;
    result.sort((a, b) => {
      let aVal: any = a[column]; let bVal: any = b[column];
      aVal = typeof aVal === 'string' ? aVal.toLowerCase() : aVal;
      bVal = typeof bVal === 'string' ? bVal.toLowerCase() : bVal;
      if (aVal < bVal) return sortOrder.value === 'asc' ? -1 : 1;
      if (aVal > bVal) return sortOrder.value === 'asc' ? 1 : -1;
      return 0;
    });
  }
  return result;
});

const sortData = (column: string) => {
  if (sortColumn.value === column) sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  else { sortColumn.value = column; sortOrder.value = 'asc'; }
  currentPage.value = 1;
};
const totalPages = computed(() => Math.ceil(filteredData.value.length / itemsPerPage));
const paginatedControls = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredData.value.slice(start, start + itemsPerPage);
});

// Modal states
const isTriviaModalOpen = ref(false);
const isAttendanceModalOpen = ref(false);
const selectedEvent = ref<AttendanceControl | null>(null);

const trivia = ref({
  question: "",
  options: ["", "", "", ""],
  correct: ""
});

const attendanceSettings = ref([
  { label: 'Morning Time In', key: 'morning_time_in', active: false },
  { label: 'Morning Mid Event', key: 'morning_mid_event', active: false },
  { label: 'Morning Time Out', key: 'morning_time_out', active: false },
  { label: 'Afternoon Time In', key: 'afternoon_time_in', active: false },
  { label: 'Afternoon Mid Event', key: 'afternoon_mid_event', active: false },
  { label: 'Afternoon Time Out', key: 'afternoon_time_out', active: false },
  { label: 'Feedback Form', key: 'feedback_form', active: false }
]);

const openTriviaModal = (event: AttendanceControl) => {
  selectedEvent.value = event;
  isTriviaModalOpen.value = true;
};

const openAttendanceModal = (event: AttendanceControl) => {
  selectedEvent.value = event;
  const eventSettings = event.settings || {};

  attendanceSettings.value.forEach(s => {
    const val = eventSettings[s.key];
    s.active = Number(val) === 1; // ensure string "1" or number 1 is true
  });

  isAttendanceModalOpen.value = true;
};


const saveTrivia = () => {
  isTriviaModalOpen.value = false;
  Swal.fire({
    title: "Success",
    text: "Trivia question has been set up successfully!",
    icon: "success",
    didOpen: () => {
      document.body.classList.remove("swal2-height-auto");
      document.documentElement.classList.remove("swal2-height-auto");
    }
  });
};

const saveAttendanceControls = async () => {
  if (!selectedEvent.value) return;

  try {
    const payload: Record<string, number> = {};
    attendanceSettings.value.forEach(s => payload[s.key] = s.active ? 1 : 0);

    await axios.put(`http://localhost:5000/api/attendance/controls/${selectedEvent.value.eventID}`, {
      settings: payload
    });

    isAttendanceModalOpen.value = false;
    Swal.fire({
      title: "Success",
      text: "Attendance controls updated successfully!",
      icon: "success",
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });

    // Refresh table
    const res = await axios.get('http://localhost:5000/api/attendance/controls');
    attendanceControls.value = Array.isArray(res.data.attendanceControls) ? res.data.attendanceControls : [];

  } catch (err) {
    console.error(err);
    Swal.fire({ title: "Error", text: "Failed to save attendance controls.", icon: "error" });
  }
};
const formatDate = (dateStr: string) => {
  const options: Intl.DateTimeFormatOptions = { year: 'numeric', month: 'short', day: 'numeric' };
  return new Date(dateStr).toLocaleDateString('en-US', options);
};

onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/attendance/controls');
    attendanceControls.value = Array.isArray(res.data.attendanceControls) ? res.data.attendanceControls : [];
  } catch (err) {
    console.error('Failed to fetch attendance controls:', err);
    attendanceControls.value = [];
  }
});
</script>


<style scoped>
.toolbar-container::part(backdrop) {
  background-color: #07055D !important;
}

.ad-background {
  --background: url('../../public/img/admin-bg.png');
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
}

.content-wrapper {
  display: flex;
  min-height: 100%;
}

.sidebar-link {
  display: block;
  font-size: 22px;
  padding: 5px 10px;
  color: white;
  text-decoration: none;
  font-weight: bold;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.sidebar-link:hover {
  background-color: #2c2c7a; 
  color: #FFFF00; 
}

.sidebar-title {
  font-size: 40px;
  text-transform: uppercase;
  letter-spacing: 5px;
  display: block;
  padding: 3px 10px;
  color: white;
  text-decoration: none;
  font-weight: bold;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.sidebar-title:hover {
  color: #FFFF00; 
}

.sub {
  display: block;
  padding: 3px 10px;
  color: white;
  text-decoration: none;
  border-radius: 4px;
  transition: background-color 0.3s;
  font-size: 18px;
  margin-left: 20px;
  font-weight: normal !important;
}

.sub:hover {
  background-color: #2c2c7a; 
  color: #FFFF00; 
}

.sidebar {
  width: 360px;
  background-color: rgba(7, 5, 93, 0.9);
  color: white;
  padding: 15px;
  margin: 10px 0;
}

.sidebar ul {
  list-style-type: none;
  padding: 0;
}

.sidebar ul li {
  margin: 8px 0;
}

.sidebar ul li a {
  color: white;
  text-decoration: none;
  font-weight: bold;
}

.main-content {
  flex: 1;
  padding: 15px;
}

.admin-logo {
  display: flex;
  height: 75px;
  margin-left: 10px;
  padding: 3px;
}
ion-icon {
  font-size: 35px !important;
  color: #fff !important;
  margin-right: 30px;
}

.footer {
  margin-top: auto;
  text-align: center;
  color: white;
}
h4{
    font-size: 26px;
    margin-top: 0px;
    margin-bottom: 0px !important;
    font-weight: 700;
    text-align: center;
}
.pagination-container {
  margin-top: 12px;
  display: flex;
  gap: 8px;
  justify-content: right;
  flex-wrap: wrap;
}

.pagination-button {
  background: #07055d;
  color: white;
  border: none;
  padding: 6px 12px;
  font-weight: 600;
  border-radius: 6px;
  cursor: pointer;
  user-select: none;
  transition: background-color 0.3s;
}

.pagination-button:hover:not(:disabled) {
  background-color: #2c2c7a;
}

.pagination-button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.pagination-button.active {
  background-color: #ffff00;
  color: #07055d;
}

thead {
  background-color:#07055d;
  color: white;
}

thead th {
  padding: 10px;
  text-align: center;
  white-space: nowrap;
}
tbody{
  background-color: white;
}

table td {
  background-color: white;
  color: black;
  padding: 10px;
  border-bottom: 1px solid #ccc; 
  border: 2px solid #07055d;
  text-align: center;
}
ion-button.edit{
    background: #07055d;
    border: #07055d;
    color: white;
    font-weight: 600;
    width: 100px;
}
.content-wrapper {
  display: flex;
  min-height: 100%;
}

ion-content.form-update{
    background: white !important;
}
ion-select.no-outline::part(native),
ion-select.no-outline::part(text),
ion-select.no-outline::part(container) {
  box-shadow: none !important;
  border: none !important;
  outline: none !important;
}
ion-select.no-outline:focus,
ion-select.no-outline:focus-within,
ion-select.no-outline:active {
  outline: none !important;
  box-shadow: none !important;
}

ion-select.no-outline {
  --highlight-color-focused: transparent;
  --color-focused: inherit;
  width: 105px;
}
ion-title.regCourse {
  text-align: center;
  font-weight: 600;
  padding: 10px;
  font-size: 25px;
}
.white-searchbar {
    --background: #e7e7e7;
    --color: rgb(31, 30, 35);
    --placeholder-color: #888;
    border: none !important;
    padding-inline-end: 0px;
    --border-radius: 4px;

}

.custom-select::part(container) {
  background-color: white !important;
  border-radius: 8px;
  padding: 10px 12px;
  color: black;
  display: flex;
  align-items: center;
  border: 1px solid #ccc;
}

.custom-select::part(icon),
.custom-select::part(text) {
  background-color: unset !important;
  color: black;
}

.custom-select {
  --background: white;
  --color: black;
  --padding-start: 0;
  --padding-end: 0;
  --min-height: 40px;
  width: 100%;
}
select{
   padding: 6px 10px;
    border: 1px solid rgb(204, 204, 204);
    border-radius: 4px;
    margin-left: -3px;
    color: black;
    background: #e6e6e6;
}
b{
  margin: 0 auto;
  font-size: 15px;
}
label{
  color: #202222;
  font-size: 12px;
}
ion-modal {
  --background: transparent !important;
  --ion-background-color: transparent !important;
  --box-shadow: none !important;
  border-radius: 5px !important;
  margin-top: 10px;
}
ion-modal::part(backdrop) {
  background: transparent !important;
}

</style>