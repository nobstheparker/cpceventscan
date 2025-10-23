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
        <!-- Sidebar (UNCHANGED) -->
        <div class="sidebar">
          <router-link to="/dashboard" class="sidebar-title">Dashboard</router-link>
          <ul>
            <li>
              <div class="sidebar-link" @click="toggleStudentMenu">
                Student Management
              </div>
              <ul v-show="showStudentMenu">
                <li><router-link to="/register" class="sub">Register Student</router-link></li>
                <li><router-link to="/view" class="sub">View & Manage Students</router-link></li>
                <li><router-link to="/recovery" class="sub">Manage 2FA/Recovery</router-link></li>
                <li><router-link to="/facereset" class="sub">Reset Facial Verification</router-link></li>
              </ul>
            </li>
            <li>
              <div class="sidebar-link" @click="toggleAcadMenu">
                Academic Curriculum
              </div>
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
              <div class="sidebar-link" @click="toggleEventMenu">
                Event Management
              </div>
              <ul v-show="showEventMenu">
                <li><router-link to="/create" class="sub">Create Event</router-link></li>
                <li><router-link to="/event-lists" class="sub">Event List</router-link></li>
                <li><router-link to="/attendance-page" class="sub">Attendance Page Control</router-link></li>
                <li><router-link to="/attendance-records" class="sub">View Attendance Records</router-link></li>
              </ul>
            </li>
             <template v-if="admin && admin.status !== 0">
              <li><router-link to="/Request" class="sidebar-link">Request Management</router-link></li>
              <li><router-link to="/Notif" class="sidebar-link">Notification Management</router-link></li>
              <li><router-link to="/Feed" class="sidebar-link">Feedback Management</router-link></li>
              <li><router-link to="/Update" class="sidebar-link">Featured Updates</router-link></li>
            </template>
            <template v-if="admin && admin.status !== 2">
              <li><router-link to="/Account-center" class="sidebar-link">Account Center</router-link></li>
            </template>
             <li>
                <a href="javascript:void(0);" class="sidebar-link" @click="confirmLogout">
                    Log Out
                </a>
            </li>
          </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
          <div style="--background: transparent;">
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
                    <th style="cursor:pointer;" @click="sortData('totalAttendees')">
                      Total Attendees
                      <span v-if="sortColumn === 'totalAttendees'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('totalAbsences')">
                      Total Absences
                      <span v-if="sortColumn === 'totalAbsences'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('incompleteAttendance')">
                      Incomplete Attendance
                      <span v-if="sortColumn === 'incompleteAttendance'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('eventStats')">
                      Event Status
                      <span v-if="sortColumn === 'eventStats'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="attendanceRecord in paginatedRecords" :key="attendanceRecord.eventID">
                    <td>{{ attendanceRecord.eventName }}</td>
                    <td>{{ attendanceRecord.eventDate }}</td>
                    <td>{{ attendanceRecord.totalAttendees }}</td>
                    <td>{{ attendanceRecord.totalAbsences }}</td>
                    <td>{{ attendanceRecord.incompleteAttendance }}</td>
                    <td>{{ attendanceRecord.eventStats }}</td>
                    <td>
                      <ion-button
                        size="small"
                        fill="solid"
                        style="--background: #F1C204; --color: black; --border-radius: 3px; font-weight: 600; width: 120px !important; margin: 0 auto;"
                        expand="block"
                        :disabled="attendanceRecord.totalAttendees === 0"
                        @click="goToDetails(attendanceRecord.eventID)"
                      > Details
                      </ion-button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Pagination -->
            <div class="pagination-container">
              <button 
                :disabled="currentPage === 1" 
                @click="currentPage--"
                class="pagination-button"
                aria-label="Previous page"
              >
                &laquo; Prev
              </button>

              <button 
                v-for="page in totalPages"
                :key="page"
                :class="['pagination-button', { active: currentPage === page }] "
                @click="currentPage = page"
                :aria-current="currentPage === page ? 'page' : false"
              >
                {{ page }}
              </button>

              <button 
                :disabled="currentPage === totalPages" 
                @click="currentPage++"
                class="pagination-button"
                aria-label="Next page"
              >
                Next &raquo;
              </button>
            </div>
          </div>
        </div>
      </div>
    </ion-content>

    <div class="footer">
      <ion-text>
        <small>&copy; All Rights Reserved PPG 2025.</small>
      </ion-text>
    </div>
  </ion-page>
</template>

<script setup lang="ts">
import {
  IonButton,
  IonCol,
  IonContent,
  IonHeader,
  IonIcon,
  IonPage,
  IonRow,
  IonSearchbar,
  IonText,
  IonToolbar
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { computed, ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();

const confirmLogout = async () => {
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: 'You will be logged out.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, log me out!',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    },
  });

  if (result.isConfirmed) {
    try {
      await axios.post('http://localhost:5000/api/users/admin-logout', {}, { withCredentials: true });
      router.push('/adminLogIn'); // redirect to login page
    } catch (err) {
      console.error(err);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Logout failed',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    }
  }
};

const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => showStudentMenu.value = !showStudentMenu.value;
const toggleAcadMenu = () => showAcadMenu.value = !showAcadMenu.value;
const toggleEventMenu = () => showEventMenu.value = !showEventMenu.value;

const sortColumn = ref('');
const sortOrder = ref<'asc' | 'desc'>('asc');
const searchQuery = ref('');
const currentPage = ref(1);
const itemsPerPage = 10;

const goToDetails = (eventID: number) => {
  router.push(`/attendance-details/${eventID}`);
};

interface AttendanceRecord {
  eventID: number;
  eventName: string;
  eventDate: string;
  totalAttendees: number;
  totalAbsences: number;
  incompleteAttendance: number;
  eventStats: string;
}

// ====== FETCH DYNAMIC DATA FROM BACKEND ======
const attendanceRecords = ref<AttendanceRecord[]>([]);

const fetchAttendanceRecords = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/attendance/summary'); 
    const events = Array.isArray(res.data) ? res.data : res.data.events || [];

    attendanceRecords.value = events.map((event: any) => {
      return {
        eventID: event.eventID,
        eventName: event.eventName,
        eventDate: new Date(event.start_date_time).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }),
        totalAttendees: Number(event.totalAttendees),
        totalAbsences: Number(event.totalAbsences),
        incompleteAttendance: Number(event.incompleteAttendance),
        eventStats: event.eventStats
      };
    });
  } catch (err) {
    console.error('Error fetching attendance records:', err);
  }
};


const admin = ref<any>(null);

onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/check-admin-session', {
      withCredentials: true
    });

    if (res.data.loggedIn && res.data.admin) {
      admin.value = res.data.admin;
    } else {
      router.replace('/adminLogIn'); // redirect if not logged in
    }
  } catch (err) {
    console.error('Session check failed:', err);
    router.replace('/adminLogIn');
  }
  fetchAttendanceRecords();
});

// ====== SORT & FILTER ======
const filteredData = computed(() => {
  let result = [...attendanceRecords.value];

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(item =>
      Object.values(item).some(val =>
        String(val).toLowerCase().includes(query)
      )
    );
  }

  if (sortColumn.value) {
    const column = sortColumn.value as keyof AttendanceRecord;

    result.sort((a, b) => {
      let aVal = a[column];
      let bVal = b[column];

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
  else sortColumn.value = column, sortOrder.value = 'asc';
  currentPage.value = 1;
};

const totalPages = computed(() => Math.ceil(filteredData.value.length / itemsPerPage));
const paginatedRecords = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredData.value.slice(start, start + itemsPerPage);
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
    font-size: 25px;
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
</style>
