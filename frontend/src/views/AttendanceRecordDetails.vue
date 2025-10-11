<template>
  <ion-page>
    <!-- Header -->
    <ion-header>
      <ion-toolbar>
        <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
          <div class="admin-logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
        </div>
      </ion-toolbar>
    </ion-header>

    <!-- Content -->
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
              <a href="javascript:void(0);" class="sidebar-link" @click="confirmLogout">
                  Log Out
              </a>
            </li>          </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
          <div class="event-rec-summary">
            <h3>Event Attendance Records Summary</h3>
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
                <tr v-if="attendanceDetails.length === 0">
                  <td colspan="7" style="text-align:center">No records yet</td>
                </tr>
                <tr v-else>
                  <td>{{ eventName }}</td>
                  <td>{{ eventDate }}</td>
                  <td>{{ totalAttendees }}</td>
                  <td>{{ totalAbsences }}</td>
                  <td>{{ incompleteAttendance }}</td>
                  <td>{{ feedbacks }}</td>
                  <td>
                    <span :style="getEventStyle(eventStats)">{{ eventStats }}</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <h4>Attendance Details</h4>

          <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
            <ion-col size="7">
            </ion-col>
            <ion-col size="5">
              <ion-searchbar v-model="searchQuery" class="white-searchbar" placeholder="Search..." animated />
            </ion-col>
          </ion-row>

          <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse; font-size: 14px;" class="responsive-table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Prog,Yr & Sec</th>
                  <th>Time In (AM)</th>
                  <th class="break">Mid-Event Check (AM)</th>
                  <th>Time Out (AM)</th>
                  <th >Time In (PM)</th>
                  <th class="break">Mid-Event Check (PM)</th>
                  <th>Time Out (PM)</th>
                  <th>VA</th>
                  <th>AR</th>
                  <th>Remarks</th>
                  <th >Attendance Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="detail in paginatedDetails" :key="detail.attendance_id">
                  <td>{{ detail.studName }}</td>
                  <td>{{ detail.progYearSec }}</td>
                  <td>{{ detail.timeIn }}</td>
                  <td>{{ detail.midEventcheck }}</td>
                  <td>{{ detail.timeOut }}</td>
                  <td>{{ detail.afternoontimeIn }}</td>
                  <td>{{ detail.afternoonmidEventcheck }}</td>
                  <td>{{ detail.afternoontimeOut }}</td>
                  <td>{{ detail.afternoontimeOut }}</td>
                  <td>{{ detail.afternoontimeOut }}</td>
                  <td>
                    <span :style="getRemarksStyle(detail.remarks)">{{ detail.remarks || '-' }}</span>
                  </td>
                  <td>
                    <span :style="getAttendanceStyle(detail.attendanceStats)">{{ detail.attendanceStats }}</span>
                  </td>
                  <td>
                    <ion-button
                      v-if="detail.attendanceStats.toLowerCase().includes('unsettled') && detail.canSettle"
                      size="small"
                      fill="solid"
                      style="--background: green; --color: white; --border-radius: 3px; font-weight: 600;"
                      expand="block"
                      @click="settleAttendance(detail)"
                    >
                      Settle
                    </ion-button>
                  </td>
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

          <!-- Export & Report Buttons -->
          <div style="display: flex; justify-content: center; gap: 15px; margin-top: 20px;">
            <ion-button style="--background: green; --color: white; font-weight: 700; --border-radius: 5px; width: 330px;" @click="exportData">Export to PDF</ion-button>
            <ion-button style="--background: green; --color: white; font-weight: 700; --border-radius: 5px; width: 330px;" @click="generateReport">Generate Report</ion-button>
          </div>
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
import { IonButton, IonCol, IonContent, IonHeader, IonIcon, IonPage, IonRow, IonSearchbar, IonText, IonToolbar } from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import Swal from 'sweetalert2';
import { computed, ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import axios from 'axios';

/* router & route */
const router = useRouter();
const route = useRoute();
/* read any of possible param names so undefined won't happen */
const eventId = route.params.id || route.params.eventID || route.params.event_id;

/* Sidebar Menu */
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

/* Logout (keeps didOpen removal) */
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

/* Generate Report */
/* Generate Report */
const generateReport = () => {
  if (eventId) {
    window.location.href = `/generate-report/${eventId}`;
    // or: window.location.assign(`/generate-report/${eventId}`);
  } else {
    Swal.fire({
      icon: 'error',
      title: 'Missing Event ID',
      text: 'Unable to generate report because event ID was not found.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};

/* state for summary */
const eventName = ref('');
const eventDate = ref('');
const totalAttendees = ref(0);
const totalAbsences = ref(0);
const incompleteAttendance = ref(0);
const feedbacks = ref(0);
const eventStats = ref('');

/* Attendance details structure */
interface AttendanceDetail {
  attendance_id: number;
  studName: string;
  progYearSec: string;
  timeIn: string | null;
  midEventcheck: string | null;
  timeOut: string | null;
  absenceReq: string | null;
  remarks: string | null;
  attendanceStats: string;
  canSettle?: boolean;
  start_date_time?: string;
  end_date_time?: string;
  event_name?: string;
  afternoontimeIn: string | null;
  afternoonmidEventcheck: string | null;
  afternoontimeOut: string | null;
}

const attendanceDetails = ref<AttendanceDetail[]>([]);

/* helper: safe time formatting (accepts ISO or already formatted) */
function formatTimeSafe(val: any) {
  if (!val && val !== 0) return '';
  // If it's already a formatted string like "12:34 PM", return as-is
  if (typeof val === 'string' && val.match(/(AM|PM|am|pm)/)) return val;
  const d = new Date(val);
  if (!isNaN(d.getTime())) {
    return d.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit', hour12: true });
  }
  // fallback to raw string
  return String(val);
}

/* helper: parse date safely */
function parseDateSafe(val: any) {
  if (!val) return null;
  const d = new Date(val);
  if (!isNaN(d.getTime())) return d;
  const parsed = Date.parse(String(val));
  return isNaN(parsed) ? null : new Date(parsed);
}

/* Fetch attendance details */
const fetchAttendanceDetails = async () => {
  try {
    if (!eventId) {
      console.error('No eventId param found in route.');
      return;
    }

    const res = await axios.get(`http://localhost:5000/api/attendance/details/${eventId}`);
    const rawList = res.data?.attendanceDetails ?? [];

    // Map API response to AttendanceDetail
    attendanceDetails.value = rawList.map((d: any) => {
      const timeIn = formatTimeSafe(d.timeIn);
      const midEventcheck = formatTimeSafe(d.midEventcheck);
      const timeOut = formatTimeSafe(d.timeOut);
      const afternoontimeIn = formatTimeSafe(d.afternoontimeIn);
      const afternoonmidEventcheck = formatTimeSafe(d.afternoonmidEventcheck);
      const afternoontimeOut = formatTimeSafe(d.afternoontimeOut);

      const startDate = parseDateSafe(d.startDateTime);
      const endDate = parseDateSafe(d.endDateTime);
      const now = new Date();
      const eventEnded = endDate ? now > endDate : false;

      let remarks = d.remarks || '';
      let attendanceStats = d.attendanceStats || 'Unsettled';

      // Compute derived remarks & status
      const hasIn = !!timeIn;
      const hasMid = !!midEventcheck;
      const hasOut = !!timeOut;

      if (hasIn && hasMid && hasOut) {
        remarks = 'Present';
        attendanceStats = 'Complete';
      } else if (eventEnded && !hasIn && !hasMid && !hasOut) {
        remarks = 'Missed';
        if (!attendanceStats || attendanceStats.toLowerCase() === 'unsettled') {
          attendanceStats = 'Unsettled';
        }
      } else if (attendanceStats.toLowerCase() === 'excused') {
        remarks = remarks || 'Excused';
        attendanceStats = 'Excused';
      } else if (!hasIn || !hasMid || !hasOut) {
        attendanceStats = attendanceStats || 'Unsettled';
        remarks = remarks || 'Incomplete';
      }

      return {
        attendance_id: d.attendance_id,
        studName: d.studName,
        progYearSec: d.progYearSec,
        timeIn,
        midEventcheck,
        timeOut,
        afternoontimeIn,
        afternoonmidEventcheck,
        afternoontimeOut,
        absenceReq: d.absenceReq ?? '',
        remarks,
        attendanceStats,
        canSettle: Number(d.canSettle ?? 0) === 1,
        start_date_time: d.startDateTime,
        end_date_time: d.endDateTime,
        event_name: d.event_name,
      } as AttendanceDetail;
    });

    // Update summary
    if (attendanceDetails.value.length > 0) {
      const first = attendanceDetails.value[0];
      eventName.value = first.event_name ?? '';
      eventDate.value = parseDateSafe(first.start_date_time)?.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' }) || '';
      const start = parseDateSafe(first.start_date_time);
      const end = parseDateSafe(first.end_date_time);
      const now = new Date();
      if (start && end) {
        eventStats.value = now < start ? 'Upcoming' : now <= end ? 'Ongoing' : 'Done';
      } else {
        eventStats.value = 'Unknown';
      }

      totalAttendees.value = attendanceDetails.value.length;
      totalAbsences.value = attendanceDetails.value.filter(r => r.remarks.toLowerCase() === 'missed').length;
      incompleteAttendance.value = attendanceDetails.value.filter(r => r.remarks.toLowerCase() === 'incomplete').length;
      feedbacks.value = 0;
    } else {
      eventName.value = '';
      eventDate.value = '';
      totalAttendees.value = 0;
      totalAbsences.value = 0;
      incompleteAttendance.value = 0;
      feedbacks.value = 0;
      eventStats.value = '';
    }
  } catch (err) {
    console.error('Error fetching attendance details:', err);
  }
};


onMounted(() => {
  fetchAttendanceDetails();
});

/* Sorting / Searching / Pagination (same logic preserved) */
const sortColumn = ref('');
const sortOrder = ref<'asc' | 'desc'>('asc');
const searchQuery = ref('');
const currentPage = ref(1);
const itemsPerPage = 10;

const filteredData = computed(() => {
  let result = [...attendanceDetails.value];
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase();
    result = result.filter(item => Object.values(item).some(val => String(val ?? '').toLowerCase().includes(q)));
  }
  if (sortColumn.value) {
    const column = sortColumn.value as keyof AttendanceDetail;
    result.sort((a, b) => {
      const aVal = String(a[column] ?? '').toLowerCase();
      const bVal = String(b[column] ?? '').toLowerCase();
      if (aVal < bVal) return sortOrder.value === 'asc' ? -1 : 1;
      if (aVal > bVal) return sortOrder.value === 'asc' ? 1 : -1;
      return 0;
    });
  }
  return result;
});

const totalPages = computed(() => Math.ceil(filteredData.value.length / itemsPerPage));
const paginatedDetails = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredData.value.slice(start, start + itemsPerPage);
});

function sortData(column: keyof AttendanceDetail) {
  if (sortColumn.value === column) sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  else { sortColumn.value = column as string; sortOrder.value = 'asc'; }
  currentPage.value = 1;
}

/* Settle attendance (local update — you can call API here) */
const settleAttendance = async (detail: AttendanceDetail) => {
  const result = await Swal.fire({
    title: 'Settle Attendance Record?',
    text: 'Do you want to settle this attendance record?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, settle it!',
    cancelButtonText: 'Cancel',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });

  if (result.isConfirmed) {
    try {
      // ✅ Call API to settle
      await axios.put(`http://localhost:5000/api/attendance/settle/${detail.attendance_id}`);

      // ✅ Update UI instantly
      detail.attendanceStats = 'Settled';   // 🔥 changed from 'Complete' to 'Settled'
      detail.canSettle = false;

      await Swal.fire({
        icon: 'success',
        title: 'Settled!',
        text: 'Attendance has been updated.',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    } catch (err) {
      console.error(err);
      await Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Failed to settle attendance.',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    }
  }
};

/* PDF export (keeps your original behavior) */
const exportData = () => {
  const doc = new jsPDF();
  doc.setFontSize(14);
  doc.text('Event Attendance Records Summary', 14, 20);

  autoTable(doc, {
    startY: 30,
    head: [['Event Name', 'Date', 'Total Attendees', 'Total Absences', 'Incomplete', 'Feedbacks', 'Status']],
    body: [[eventName.value, eventDate.value, totalAttendees.value, totalAbsences.value, incompleteAttendance.value, feedbacks.value, eventStats.value]]
  });

  const startY = (doc as any).lastAutoTable?.finalY || 60;
  doc.text('Attendance Details', 14, startY + 20);

  autoTable(doc, {
    startY: startY + 30,
    head: [['Name', 'Prog, Yr & Sec', 'Time In', 'Mid-Event', 'Time Out', 'Remarks', 'Status']],
    body: attendanceDetails.value.map(d => [d.studName, d.progYearSec, d.timeIn, d.midEventcheck, d.timeOut, d.remarks, d.attendanceStats]),
    styles: { fontSize: 9 }
  });

  doc.save(`Attendance_${eventName.value || 'Event'}.pdf`);
};

/* color badge helpers (inline styles to avoid dependency on tailwind) */
function getRemarksStyle(remarks: string | null) {
  if (!remarks) return { color: '#374151' }; // gray
  const r = remarks.toLowerCase();
  if (r.includes('present')) return { backgroundColor: '#dcfce7', color: '#166534', padding: '4px 8px', borderRadius: '8px', fontWeight: 600 };
  if (r.includes('missed')) return { backgroundColor: '#fee2e2', color: '#991b1b', padding: '4px 8px', borderRadius: '8px', fontWeight: 600 };
  if (r.includes('incomplete')) return { backgroundColor: '#fff7ed', color: '#92400e', padding: '4px 8px', borderRadius: '8px', fontWeight: 600 };
  return { backgroundColor: '#f3f4f6', color: '#374151', padding: '4px 8px', borderRadius: '8px' };
}

function getAttendanceStyle(status: string | null) {
  if (!status) return { color: '#374151' };
  const s = status.toLowerCase();
  if (s.includes('complete')) return { backgroundColor: '#d1fae5', color: '#065f46', padding: '4px 8px', borderRadius: '8px', fontWeight: 700 };
  if (s.includes('excused')) return { backgroundColor: '#dbf4ff', color: '#075985', padding: '4px 8px', borderRadius: '8px', fontWeight: 700 };
  if (s.includes('unsettled')) return { backgroundColor: '#fff7ed', color: '#b45309', padding: '4px 8px', borderRadius: '8px', fontWeight: 700 };
  if (s.includes('settled')) return { backgroundColor: '#f3e8ff', color: '#6b21a8', padding: '4px 8px', borderRadius: '8px', fontWeight: 700 };
  return { backgroundColor: '#f3f4f6', color: '#374151', padding: '4px 8px', borderRadius: '8px' };
}

function getEventStyle(status: string | null) {
  if (!status) return {};
  const s = status.toLowerCase();
  if (s.includes('upcoming')) return { backgroundColor: '#eff6ff', color: '#1d4ed8', padding: '4px 8px', borderRadius: '8px', fontWeight: 700 };
  if (s.includes('ongoing')) return { backgroundColor: '#ecfdf5', color: '#15803d', padding: '4px 8px', borderRadius: '8px', fontWeight: 700 };
  if (s.includes('done') || s.includes('completed')) return { backgroundColor: '#f3f4f6', color: '#4b5563', padding: '4px 8px', borderRadius: '8px', fontWeight: 700 };
  return {};
}
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

.break {
  width: 100px;
  display: block;
  text-wrap: wrap;
  text-align: center;
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
  padding: 20px;
  width: 100%;
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
.event-rec-summary h3{
    font-size: 24px;
    margin-top: 0px !important;
    font-weight: 700;
    text-align: center;
    margin-bottom: 10px;
}
h4{
    font-size: 24px;
    margin-top: 10px;
    margin-bottom: 0px !important;
    font-weight: 700;
    text-align: center;
}

.event-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 18px;
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
    --padding-inline-start: 0px;
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