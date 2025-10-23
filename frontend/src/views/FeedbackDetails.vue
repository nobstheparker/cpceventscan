<template>
  <ion-page>
    <!-- HEADER -->
    <ion-header>
      <ion-toolbar>
        <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
          <div class="admin-logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
        </div>
      </ion-toolbar>
    </ion-header>

    <!-- CONTENT -->
    <ion-content class="ad-background">
      <div class="content-wrapper">
        <!-- SIDEBAR -->
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
            <li><a href="javascript:void(0);" class="sidebar-link" @click="confirmLogout">Log Out</a></li>
          </ul>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main-content">

          <!-- EVENT SUMMARY TABLE -->
          <div style="overflow-x: auto; margin-bottom: 30px;border-radius: 10px; margin-top: 10px;">
            <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
              <thead style="color: #ffff00; font-weight: 800; text-transform: uppercase; font-size: 20px;">
                <tr>
                  <th style="cursor:pointer;text-align:center" @click="sortData('eventName')">
                    Event Name
                    <span v-if="sortColumn === 'eventName'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;text-align:center" @click="sortData('dateTime')">
                    Date & Time
                    <span v-if="sortColumn === 'dateTime'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;text-align:center" @click="sortData('totalFeedbacks')">
                    Total Feedback Submissions
                    <span v-if="sortColumn === 'totalFeedbacks'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;text-align:center" @click="sortData('eventStatus')">
                    Event Status
                    <span v-if="sortColumn === 'eventStatus'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                </tr>
              </thead>
              <tbody style="font-weight: 700 !important; font-size: 20px !important; text-align: center;">
                <tr v-for="event in paginatedEvents" :key="event.eventID">
                  <td>{{ event.eventName }}</td>
                  <td>{{ event.dateTime }}</td>
                  <td>{{ event.totalFeedbacks }}</td>
                  <td>{{ event.eventStatus }}</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- INDIVIDUAL FEEDBACK TABLE -->
          <h4>STUDENT FEEDBACK LIST</h4>
          <div style="overflow-x: auto; border-radius: 15px; margin-top: 10px;">
            <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
              <thead>
                <tr>
                  <th style="cursor:pointer;text-align:center" @click="sortData('studName')">
                    Student Name
                    <span v-if="sortColumn === 'studName'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;text-align:center" @click="sortData('progYrSec')">
                    Program, Yr & Section
                    <span v-if="sortColumn === 'progYrSec'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;text-align:center" @click="sortData('feedbacks')">
                    Feedback
                    <span v-if="sortColumn === 'feedbacks'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="fb in paginatedFeedbacks" :key="fb.feedback_id">
                  <td>{{ fb.studName }}</td>
                  <td>{{ fb.progYrSec }}</td>
                  <td>{{ fb.feedbacks }}</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="pagination-container" style="margin-top:12px">
            <button :disabled="currentPage === 1" @click="currentPage--" class="pagination-button">&laquo; Prev</button>
            <button v-for="page in totalPages" :key="page" :class="['pagination-button', { active: currentPage === page }]" @click="currentPage = page">{{ page }}</button>
            <button :disabled="currentPage === totalPages" @click="currentPage++" class="pagination-button">Next &raquo;</button>
          </div>

        </div>
      </div>
    </ion-content>

    <!-- FOOTER -->
    <div class="footer">
      <ion-text>
        <small>&copy; All Rights Reserved PPG 2025.</small>
      </ion-text>
    </div>
  </ion-page>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import Swal from 'sweetalert2';
import axios from 'axios';

const route = useRoute();
const router = useRouter();
const eventID = route.params.eventID;

const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

const events = ref<any[]>([]);
const feedbacks = ref<any[]>([]);
const eventTitle = ref('');

const sortColumn = ref('');
const sortOrder = ref<'asc' | 'desc'>('asc');
const currentPage = ref(1);
const itemsPerPage = 10;
const totalPages = computed(() => Math.ceil(feedbacks.value.length / itemsPerPage));

const confirmLogout = async () => {
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: 'You will be logged out.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, log me out!',
  });
  if (result.isConfirmed) {
    try {
      await axios.post('http://localhost:5000/api/users/admin-logout', {}, { withCredentials: true });
      router.push('/adminLogIn');
    } catch (err) {
      Swal.fire('Error', 'Logout failed', 'error');
    }
  }
};

const fetchEventData = async () => {
  try {
    const res = await axios.get(`http://localhost:5000/api/feedback/${eventID}`);
    const list = res.data.feedback || [];
    if (list.length > 0) {
      const f = list[0];
      eventTitle.value = f.event_name;

      events.value = [{
        eventID: f.event_id,
        eventName: f.event_name,
        dateTime: new Date(f.created_at).toLocaleString(),
        totalFeedbacks: f.total_feedback_for_event,
        eventStatus: (() => {
          const now = new Date();
          const start = new Date(f.start_date_time);
          const end = new Date(f.end_date_time);
          if (now < start) return 'Upcoming';
          else if (now <= end) return 'Ongoing';
          return 'Completed';
        })()
      }];

      feedbacks.value = list.map((f: any) => ({
        feedback_id: f.feedback_id,
        studName: `${f.first_name} ${f.last_name}`,
        progYrSec: `${f.course_code} ${f.year_name} ${f.section_name}`,
        feedbacks: f.notes
      }));
    }
  } catch (err) {
    console.error('Failed to fetch feedback:', err);
  }
};

const sortData = (column: string) => {
  if (sortColumn.value === column) sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  else sortColumn.value = column;
  currentPage.value = 1;
};

const paginatedEvents = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return events.value.slice(start, start + itemsPerPage);
});
const paginatedFeedbacks = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return feedbacks.value.slice(start, start + itemsPerPage);
});

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
  fetchEventData();
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

.pagination-container *{
  color: #fff;
}

.sidebar ul li a {
  color: white;
  text-decoration: none;
  font-weight: bold;
}

.main-content {
  flex: 1;
  padding: 20px;
}

.admin-logo {
  display: flex;
  height: 75px;
  margin-left: 10px;
  padding: 3px;
}

.toolbar-icons {
  display: flex;
  align-items: center;
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
  position: fixed;
  width: 100%;
  bottom: 0;
}

h4{
    font-size: 30px;
    margin-top: 0px !important;
    margin-bottom: 0px !important;
    font-weight: 700;
    text-align: center;
}
h2{
    font-size: 30px;
    margin-top: 20px !important;
    margin-bottom: 10px !important;
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
ion-select.sorter{
    background: #e7e7e7;
    max-width: 150px;
    padding: 0 10px;
    border-radius: 4px;
    font-size: 15px;
    color: #1e1e1e;
    font-weight: 500;
    padding-inline-start: 0px;
}
thead {
  background-color:#07055d;
  color: white;
}

thead th {
  padding: 10px;
  text-align: left;
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
