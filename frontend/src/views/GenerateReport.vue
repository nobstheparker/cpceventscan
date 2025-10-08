<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
          <div class="admin-logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
          <div class="toolbar-icons">
            <ion-button fill="clear" size="small">
              <ion-icon :icon="notifications" slot="icon-only"></ion-icon>
            </ion-button>
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
            <li><router-link to="/adminLogIn" class="sidebar-link" @click.prevent="confirmLogout">Log Out</router-link></li>
          </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
          <h3>Event Report & Analytics</h3>
          <div style="background-color: #d9d9d978; padding: 20px; border-radius: 10px; margin-bottom: 30px;">
            <!-- Event Summary -->
            <div class="event-rec-summary">
              <table class="event-table">
                <thead>
                  <tr>
                    <th>Event Name</th>
                    <th>Date</th>
                    <th>Total Attendees</th>
                    <th>Total Absences</th>
                    <th>Incomplete Attendance</th>
                    <th>Feedbacks</th>
                    <th>Event Status</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>{{ eventName }}</td>
                    <td>{{ eventDate }}</td>
                    <td>{{ totalAttendees }}</td>
                    <td>{{ totalAbsences }}</td>
                    <td>{{ incompleteAttendance }}</td>
                    <td>{{ feedbacks }}</td>
                    <td>{{ eventStats }}</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Analytics Row 1 -->
            <div class="analytics-row" style="margin-top:16px;">
              <div class="analytics-card">
                <div class="card-header">Average Time In</div>
                <div class="card-body">{{ avgTimeIn || '-' }}</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">Average Time-outs</div>
                <div class="card-body">{{ avgTimeOut || '-' }}</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">Complete Attendance</div>
                <div class="card-body">{{ completeAttendance }}</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">Approved Absences</div>
                <div class="card-body">{{ approvedAbsences }}</div>
              </div>
            </div>

            <!-- Analytics Row 2 -->
            <div class="analytics-row" style="margin-top:12px;">
              <div class="analytics-card">
                <div class="card-header">Attendance Rate</div>
                <div class="card-body">{{ attendanceRate }}%</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">Missed Time Ins</div>
                <div class="card-body">{{ missedTimeIns }}</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">Missed Time Outs</div>
                <div class="card-body">{{ missedTimeOuts }}</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">Missed Mid Event Checks</div>
                <div class="card-body">{{ missedMidChecks }}</div>
              </div>
            </div>

            <!-- Program Attendance Rate -->
            <h5 style="margin-top:14px;">Program Attendance Rate</h5>
            <div class="analytics-row" style="margin-top:8px;">
              <div class="analytics-card">
                <div class="card-header">BSIT</div>
                <div class="card-body">{{ programRates.BSIT }}%</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">BSED</div>
                <div class="card-body">{{ programRates.BSED }}%</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">BEED</div>
                <div class="card-body">{{ programRates.BEED }}%</div>
              </div>
              <div class="analytics-card">
                <div class="card-header">BSHM</div>
                <div class="card-body">{{ programRates.BSHM }}%</div>
              </div>
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
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import Swal from 'sweetalert2';
import { IonButton, IonContent, IonHeader, IonIcon, IonPage, IonText, IonToolbar } from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import axios from 'axios';

const router = useRouter();

/* Sidebar toggles */
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

/* Analytics state */
const eventName = ref('');
const eventDate = ref('');
const totalAttendees = ref(0);
const totalAbsences = ref(0);
const incompleteAttendance = ref(0);
const feedbacks = ref(0);
const eventStats = ref('');
const avgTimeIn = ref('');
const avgTimeOut = ref('');
const completeAttendance = ref(0);
const approvedAbsences = ref(0);
const attendanceRate = ref(0);
const missedTimeIns = ref(0);
const missedTimeOuts = ref(0);
const missedMidChecks = ref(0);

/* Program rates */
const programRates = ref({
  BSIT: 0,
  BSED: 0,
  BEED: 0,
  BSHM: 0
});

/* AttendanceDetails (hidden, used for calculations) */
const attendanceDetails = ref<any[]>([]);

/* Helpers */
function parseTimeToMinutes(t: string | null) {
  if (!t) return null;
  const ampmMatch = t.match(/(\d{1,2}):(\d{2})(?::\d{2})?\s*([AaPp][Mm])/);
  if (ampmMatch) {
    let h = parseInt(ampmMatch[1], 10);
    const m = parseInt(ampmMatch[2], 10);
    const ampm = ampmMatch[3].toUpperCase();
    if (ampm === 'PM' && h !== 12) h += 12;
    if (ampm === 'AM' && h === 12) h = 0;
    return h * 60 + m;
  }
  const isoMatch = t.match(/(\d{1,2}):(\d{2})(?::\d{2})?/);
  if (isoMatch) {
    const h = parseInt(isoMatch[1], 10);
    const m = parseInt(isoMatch[2], 10);
    return h * 60 + m;
  }
  return null;
}

function formatMinutesToTime(mins: number) {
  if (mins == null || isNaN(mins)) return '';
  mins = ((mins % (24 * 60)) + (24 * 60)) % (24 * 60);
  const h24 = Math.floor(mins / 60);
  const m = mins % 60;
  const ampm = h24 >= 12 ? 'PM' : 'AM';
  let h12 = h24 % 12;
  if (h12 === 0) h12 = 12;
  return `${String(h12).padStart(2,'0')}:${String(m).padStart(2,'0')} ${ampm}`;
}

function programCodeFromProgYearSec(s: string | undefined) {
  if (!s) return '';
  const parts = s.trim().split(/\s+/);
  return parts[0] || '';
}

/* Fetch and compute analytics */
onMounted(async () => {
  const eventId = window.location.pathname.split('/').pop();
  if (!eventId) return;
  try {
    const res = await axios.get(`http://localhost:5000/api/attendance/details/${eventId}`);
    const payload = res.data;
    attendanceDetails.value = payload.attendanceDetails ?? [];

    if (!attendanceDetails.value.length) return;

    // Event basic info
    const firstEvent = attendanceDetails.value[0];
    eventName.value = firstEvent.event_name ?? '';
    eventDate.value = firstEvent.startDateTime ?? '';

    // Event Status based on start and end date
    const startDate = new Date(firstEvent.startDateTime);
    const endDate = new Date(firstEvent.endDateTime);
    const now = new Date();

    if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
      eventStats.value = 'Unknown';
    } else if (now < startDate) {
      eventStats.value = 'Upcoming';
    } else if (now >= startDate && now <= endDate) {
      eventStats.value = 'Ongoing';
    } else if (now > endDate) {
      eventStats.value = 'Completed';
    }

    // Summary counts
    totalAttendees.value = attendanceDetails.value.length;
    completeAttendance.value = attendanceDetails.value.filter(d => d.timeIn && d.midEventcheck && d.timeOut).length;
    totalAbsences.value = attendanceDetails.value.filter(d => !d.timeIn && !d.midEventcheck && !d.timeOut).length;
    incompleteAttendance.value = attendanceDetails.value.filter(d => {
      const some = d.timeIn || d.midEventcheck || d.timeOut;
      const all = d.timeIn && d.midEventcheck && d.timeOut;
      return some && !all;
    }).length;

    approvedAbsences.value = attendanceDetails.value.filter(d => (d.attendanceStats || '').toLowerCase() === 'excused').length;
    missedTimeIns.value = attendanceDetails.value.filter(d => !d.timeIn).length;
    missedTimeOuts.value = attendanceDetails.value.filter(d => !d.timeOut).length;
    missedMidChecks.value = attendanceDetails.value.filter(d => !d.midEventcheck).length;
    attendanceRate.value = totalAttendees.value === 0 ? 0 : Math.round((completeAttendance.value / totalAttendees.value) * 100);

    // Average time
    const timeInMins = attendanceDetails.value.map(d => parseTimeToMinutes(d.timeIn)).filter(v => v != null) as number[];
    const timeOutMins = attendanceDetails.value.map(d => parseTimeToMinutes(d.timeOut)).filter(v => v != null) as number[];

    avgTimeIn.value = timeInMins.length ? formatMinutesToTime(Math.round(timeInMins.reduce((a,b)=>a+b,0)/timeInMins.length)) : '';
    avgTimeOut.value = timeOutMins.length ? formatMinutesToTime(Math.round(timeOutMins.reduce((a,b)=>a+b,0)/timeOutMins.length)) : '';

    // Program rates
    const rateMap: Record<string, number> = { BSIT:0, BSED:0, BEED:0, BSHM:0 };
    attendanceDetails.value.forEach(d => {
      const code = programCodeFromProgYearSec(d.progYearSec);
      if (code && rateMap.hasOwnProperty(code)) {
        rateMap[code] = parseFloat(d.programAttendanceRate) || 0;
      }
    });
    programRates.value = rateMap;

  } catch(err) {
    console.error(err);
  }
});

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
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });
  if (result.isConfirmed) router.push('/login');
};
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
}
h3{
    font-size: 30px;
    margin-top: 0px !important;
    font-weight: 700;
    text-align: center;
    margin-bottom: 10px;
}
h5{
    font-size: 24px;
    margin-top: 20px !important;
    font-weight: 900;
    text-align: center;
    margin-bottom: 10px;
    color:#08065a;
;
}
.analytics-row {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 15px;
  margin-top: 20px;
}

.analytics-card {
  flex: 1;
  min-width: 200px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
}

.card-header {
  background-color: #08065a;
  color: white;
  font-weight: bold;
  padding: 10px;
  text-align: center;
}

.card-body {
  background-color: #d1d1e1;
  padding: 20px;
  font-size: 22px;
  font-weight: 700;
  text-align: center;
  color: #08065a;
}
.event-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 15px;
}

.event-table th,
.event-table td {
  text-align: center;
  padding: 12px;
  border: 1px solid #ccc;
}

.event-table th {
  background-color: #07055D;
  color: white;
  font-weight: bold;
}
.event-table tbody{
    color: #19191a;
    background: #d4dce9;
}
.event-table td{
    border: 1px solid #07055d !important;
}
</style>
