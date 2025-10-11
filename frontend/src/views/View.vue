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
            </li>
          </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
          <h3>STUDENT RECORDS</h3>
          <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
            <ion-col size="7"></ion-col>
            <ion-col size="5">
              <ion-searchbar
                v-model="searchQuery"
                class="white-searchbar"
                placeholder="Search..."
                animated
              />
            </ion-col>
          </ion-row>

          <div>
            <table style="width: 100%; border-collapse: collapse; font-size: 14px; overflow: scroll;">
              <thead>
                <tr>
                  <th style="cursor:pointer;" @click="sortData('student_id')">
                    Student ID
                    <span v-if="sortColumn === 'student_id'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;" @click="sortData('first_name')">
                    Full Name
                    <span v-if="sortColumn === 'first_name'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;" @click="sortData('course_code')">
                    Course, Yr & Section
                    <span v-if="sortColumn === 'course_code'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;" @click="sortData('birthday')">
                    Birthday
                    <span v-if="sortColumn === 'birthday'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;" @click="sortData('sex')">
                    Sex
                    <span v-if="sortColumn === 'sex'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;" @click="sortData('email')">
                    Email
                    <span v-if="sortColumn === 'email'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th style="cursor:pointer;" @click="sortData('phone')">
                    Phone
                    <span v-if="sortColumn === 'phone'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                  </th>
                  <th :style="{ width: '200px' }">Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="student in paginatedStudents"
                  :key="student.id"
                  :class="{ 'deactivated-row': student.status === 1 }"
                >
                  <td>{{ student.student_id }}</td>
                  <td>{{ student.first_name }} {{ student.middle_name }} {{ student.last_name }}</td>
                  <td>{{ student.course_code }} {{ student.year_level }} {{ student.section_name }}</td>
                  <td>{{ new Date(student.birthday).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' }) }}</td>
                  <td>{{ student.sex }}</td>
                  <td>{{ student.email }}</td>
                  <td>N/A</td>
                  <td style="display: flex;">
                    <ion-button
                      v-if="student.status !== 1"
                      size="small"
                      fill="solid"
                      style="--background: #970303; --color: white;"
                      expand="block"
                      @click="confirmDeactivate(student.id)"
                    >
                      Deactivate
                    </ion-button>
                    <ion-button
                      v-else
                      size="small"
                      fill="solid"
                      style="--background: #0a8f08; --color: white;"
                      expand="block"
                      @click="confirmActivate(student.id)"
                    >
                      Activate
                    </ion-button>
                    <ion-button
                    size="small"
                    fill="solid"
                    style="--background: #07055d; --color: white;"
                    expand="block"
                    :router-link="'/attendance-logs'"
                  >
                    Attendance
                  </ion-button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="pagination-container">
            <button :disabled="currentPage === 1" @click="currentPage--" class="pagination-button">&laquo; Prev</button>
            <button
              v-for="page in totalPages"
              :key="page"
              :class="['pagination-button', { active: currentPage === page }]"
              @click="currentPage = page"
            >
              {{ page }}
            </button>
            <button :disabled="currentPage === totalPages" @click="currentPage++" class="pagination-button">Next &raquo;</button>
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
import { IonButton, IonCol, IonContent, IonHeader, IonPage, IonRow, IonSearchbar, IonText, IonToolbar } from '@ionic/vue';
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import Swal from 'sweetalert2';

const router = useRouter();

// Sidebar toggles
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

// Students
const students = ref<any[]>([]);
const searchQuery = ref('');
const sortColumn = ref('student_id');
const sortOrder = ref<'asc' | 'desc'>('asc');
const currentPage = ref(1);
const itemsPerPage = 10;

// Fetch students
const fetchStudents = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/students/list');
    students.value = res.data.students;
  } catch (err) {
    console.error(err);
  }
};

onMounted(() => fetchStudents());

// Computed: filtered + sorted
const filteredStudents = computed(() => {
  let result = [...students.value];

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(student =>
      Object.values(student).some(val => String(val).toLowerCase().includes(query))
    );
  }

  result.sort((a, b) => {
    let aVal = a[sortColumn.value];
    let bVal = b[sortColumn.value];
    if (typeof aVal === 'string') aVal = aVal.toLowerCase();
    if (typeof bVal === 'string') bVal = bVal.toLowerCase();

    if (aVal < bVal) return sortOrder.value === 'asc' ? -1 : 1;
    if (aVal > bVal) return sortOrder.value === 'asc' ? 1 : -1;
    return 0;
  });

  return result;
});

const totalPages = computed(() => Math.ceil(filteredStudents.value.length / itemsPerPage));
const paginatedStudents = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredStudents.value.slice(start, start + itemsPerPage);
});

// Sorting
const sortData = (column: string) => {
  if (sortColumn.value === column) sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  else { sortColumn.value = column; sortOrder.value = 'asc'; }
  currentPage.value = 1;
};

// Activate / Deactivate
const confirmDeactivate = async (id: number) => {
  const res = await Swal.fire({
    title: 'Deactivate student?',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });
  if (res.isConfirmed) {
    await axios.put(`http://localhost:5000/api/students/deactivate/${id}`);
    fetchStudents();
    Swal.fire({ title: 'Deactivated!', icon: 'success', didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }});
  }
};

const confirmActivate = async (id: number) => {
  const res = await Swal.fire({
    title: 'Activate student?',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });
  if (res.isConfirmed) {
    await axios.put(`http://localhost:5000/api/students/activate/${id}`);
    fetchStudents();
    Swal.fire({ title: 'Activated!', icon: 'success', didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }});
  }
};

// Logout
const confirmLogout = async () => {
  const res = await Swal.fire({
    title: 'Are you sure?',
    text: 'You will be logged out.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, log me out!',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });
  if (res.isConfirmed) {
    await axios.post('http://localhost:5000/api/users/admin-logout', {}, { withCredentials: true });
    router.push('/adminLogIn');
  }
};
</script>

<style scoped>
.toolbar-container::part(backdrop) {
  background-color: #07055d !important;
}
.ad-background {
 --background: url(/public/img/admin-bg.png) no-repeat center center / cover;
}
ion-select.sorter{
    background: #fff;
    max-width: 150px;
    padding: 0 10px;
    border-radius: 4px;
    font-size: 15px;
    color: #1e1e1e;
    font-weight: 500;
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

table td {
  background-color: white;
  color: black;
  padding: 3px 4px;
  border-bottom: 1px solid #ccc; 
  border: 2px solid #07055d;
  font-size: 12px;
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
ion-title.studrecord {
  text-align: center;
  font-weight: 600;
  padding: 10px;
  font-size: 22px;
}
.white-searchbar {
  --background: white;
  --color: rgb(31, 30, 35);
  --placeholder-color: #888;
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
  color: #ffff00;
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
  color: #ffff00;
}
.blue-button {
  background-color: #007BFF; /* Bootstrap blue or customize */
  color: white;
  border: none;
  border-radius: 3px;
  font-size: 14px;
  cursor: pointer;
}

.blue-button:hover {
  background-color: #0069d9; /* Slightly darker on hover */
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
  color: #ffff00;
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
  user-select: none;
}

.footer {
  margin-top: auto;
  text-align: center;
  color: white;
}

table th {
  user-select: none;
  border: 1px solid #07055d;
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
ion-col select.sort{
    background: #e7e7e7;
    max-width: 150px;
    padding: 0 10px;
    border-radius: 4px;
    font-size: 15px;
    color: #1e1e1e;
    font-weight: 500;
    padding-inline-start: 0px;
}
 h3{
    font-size: 24px;
    margin-top: 0px !important;
    font-weight: 700;
    text-align: center;
    margin-bottom: 8px;
}
.scroll-table {
  overflow-x: auto;
  width: 100%;
  max-width: 100%;
}

.scroll-table table {
  min-width: 900px;
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}
.deactivated-row td {
  color: red;
}
.main-content h3 {
  color: #fff !important;
}
td ion-button {
  width: 100px;
}
</style>
