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
      <div class="content-wrapper" style="display:flex;">

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
              <a href="javascript:void(0);" class="sidebar-link" @click="confirmLogout">Log Out</a>
            </li>
          </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content" style="flex:1; padding-left:16px;">
          <h4>Attendance Log</h4>

          <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
            <ion-col size="7"></ion-col>
            <ion-col size="5">
              <ion-searchbar v-model="searchQuery" class="white-searchbar" placeholder="Search..." animated />
            </ion-col>
          </ion-row>

          <div style="overflow-x:auto;">
            <table style="width:100%; border-collapse: collapse; font-size:14px;">
              <thead>
                <tr>
                  <th @click="sortData('event_name')" style="cursor:pointer">Event Name <span v-if="sortColumn==='event_name'">{{ sortOrder==='asc'?'▲':'▼' }}</span></th>
                  <th>Time In</th>
                  <th>Trivia Time In</th>
                  <th>Time Out</th>
                  <th>Afternoon Time In</th>
                  <th>Afternoon Trivia In</th>
                  <th>Afternoon Time Out</th>
                  <th>AR</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="detail in paginatedDetails" :key="detail.attendance_id">
                  <td>{{ detail.event_name }}</td>
                  <td>{{ detail.time_in_formatted || '-' }}</td>
                  <td>
                    <span :style="getTriviaStyle(detail.trivia_time_in_formatted)">
                      {{ detail.trivia_time_in_formatted || '-' }}
                    </span>
                  </td>
                  <td>{{ detail.time_out_formatted || '-' }}</td>
                  <td>{{ detail.afternoon_time_in_formatted || '-' }}</td>
                  <td>
                    <span :style="getTriviaStyle(detail.afternoon_trivia_time_in_formatted)">
                      {{ detail.afternoon_trivia_time_in_formatted || '-' }}
                    </span>
                  </td>
                  <td>{{ detail.afternoon_time_out_formatted || '-' }}</td>
                  <td :style="getStatusStyle(detail.request_status)">
                    {{ detail.request_status }}
                  </td>
                  <td :style="getAttendanceStatusStyle(detail.attendance_status)">
                    {{ detail.attendance_status }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="pagination-container" style="margin-top:12px;">
            <button :disabled="currentPage===1" @click="currentPage--">&laquo; Prev</button>
            <button v-for="page in totalPages" :key="page" :class="{ active: currentPage===page }" @click="currentPage=page">{{ page }}</button>
            <button :disabled="currentPage===totalPages" @click="currentPage++">Next &raquo;</button>
          </div>
        </div>

      </div>
    </ion-content>

    <!-- Footer -->
    <div class="footer" style="text-align:center; padding:8px; background:#f3f4f6;">
      <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
    </div>
  </ion-page>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from 'axios';
import Swal from 'sweetalert2';

const route = useRoute();
const router = useRouter();
const studentId = route.params.student_id || route.params.id;

const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

const confirmLogout = async () => {
  const result = await Swal.fire({
    title:'Are you sure?', text:'You will be logged out.', icon:'warning', showCancelButton:true, confirmButtonText:'Yes, log me out!'
  });
  if(result.isConfirmed){
    await axios.post('http://localhost:5000/api/users/admin-logout', {}, {withCredentials:true});
    router.push('/adminLogIn');
  }
}

interface AttendanceDetail {
  attendance_id:number;
  event_name:string;
  time_in_formatted:string|null;
  trivia_time_in_formatted:string|null;
  time_out_formatted:string|null;
  afternoon_time_in_formatted:string|null;
  afternoon_trivia_time_in_formatted:string|null;
  afternoon_time_out_formatted:string|null;
  remarks:string|null;
  request_status:string|null;
  attendance_status:string|null;
}

const attendanceDetails = ref<AttendanceDetail[]>([]);
const searchQuery = ref('');
const sortColumn = ref('event_name');
const sortOrder = ref<'asc'|'desc'>('asc');
const currentPage = ref(1);
const itemsPerPage = 10;

const fetchAttendanceDetails = async () => {
  if(!studentId) return;
  const res = await axios.get(`http://localhost:5000/api/students/attendance-logs/${studentId}`);
  const logs = res.data.attendanceLogs ?? [];
  attendanceDetails.value = logs.map((d:any)=>({
    attendance_id:d.attendance_id,
    event_name:d.event_name,
    time_in_formatted:d.time_in_formatted,
    trivia_time_in_formatted:d.trivia_time_in_formatted,
    time_out_formatted:d.time_out_formatted,
    afternoon_time_in_formatted:d.afternoon_time_in_formatted,
    afternoon_trivia_time_in_formatted:d.afternoon_trivia_time_in_formatted,
    afternoon_time_out_formatted:d.afternoon_time_out_formatted,
    remarks:d.remarks,
    request_status:d.request_status,
    attendance_status:d.attendance_status
  }));
}

const admin = ref<any>(null);
onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/check-admin-session', {
      withCredentials: true
    });

    if (res.data.loggedIn && res.data.admin) {
      admin.value = res.data.admin;
      router.push(`/attendance-logs/${studentId}`);
    } else {
      router.replace('/adminLogIn'); // redirect if not logged in
    }
  } catch (err) {
    console.error('Session check failed:', err);
    router.replace('/adminLogIn');
  }
  fetchAttendanceDetails();
});

const filteredData = computed(()=>{
  let result = [...attendanceDetails.value];
  if(searchQuery.value){
    const q = searchQuery.value.toLowerCase();
    result = result.filter(item => Object.values(item).some(val=>String(val ?? '').toLowerCase().includes(q)));
  }
  if(sortColumn.value){
    const col = sortColumn.value as keyof AttendanceDetail;
    result.sort((a,b)=>{
      const aVal = String(a[col] ?? '').toLowerCase();
      const bVal = String(b[col] ?? '').toLowerCase();
      if(aVal < bVal) return sortOrder.value==='asc'?-1:1;
      if(aVal > bVal) return sortOrder.value==='asc'?1:-1;
      return 0;
    });
  }
  return result;
});

const totalPages = computed(()=>Math.ceil(filteredData.value.length/itemsPerPage));
const paginatedDetails = computed(()=>{
  const start = (currentPage.value-1)*itemsPerPage;
  return filteredData.value.slice(start, start+itemsPerPage);
});

function sortData(column:keyof AttendanceDetail){
  if(sortColumn.value===column) sortOrder.value = sortOrder.value==='asc'?'desc':'asc';
  else { sortColumn.value = column as string; sortOrder.value='asc'; }
  currentPage.value=1;
}

function getStatusStyle(request_status:string){
  if(request_status==='Approved') return {backgroundColor:'#d1fae5',color:'#065f46',padding:'4px 8px',borderRadius:'6px',fontWeight:600};
  if(request_status==='Rejected') return {backgroundColor:'#fee2e2',color:'#991b1b',padding:'4px 8px',borderRadius:'6px',fontWeight:600};
  if(request_status==='Pending') return {backgroundColor:'#fef3c7',color:'#92400e',padding:'4px 8px',borderRadius:'6px',fontWeight:600};
  return {backgroundColor:'#f3f4f6',color:'#374151',padding:'4px 8px',borderRadius:'6px',fontWeight:600};
}

function getAttendanceStatusStyle(attendance_status:string|null){
  if(attendance_status==='Settled') return {backgroundColor:'#d1fae5',color:'#065f46',padding:'4px 8px',borderRadius:'6px',fontWeight:600};
  if(attendance_status==='Unsettled') return {backgroundColor:'#fee2e2',color:'#991b1b',padding:'4px 8px',borderRadius:'6px',fontWeight:600};
  return {backgroundColor:'#f3f4f6',color:'#374151',padding:'4px 8px',borderRadius:'6px',fontWeight:600};
}

function getTriviaStyle(val:string|null){
  if(val==='Missed') return {backgroundColor:'#fee2e2',color:'#991b1b',padding:'4px 6px',borderRadius:'6px',fontWeight:600};
  return {backgroundColor:'#d1fae5',color:'#065f46',padding:'4px 6px',borderRadius:'6px',fontWeight:600};
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