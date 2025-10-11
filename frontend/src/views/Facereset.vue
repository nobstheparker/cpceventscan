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
        <div class="main-content">
          <ion-title class="studrecord">FACIAL RECOGNITION RESET</ion-title>

          <ion-content class="ion-padding" style="--background: transparent;">
            <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
              <ion-col size="7">
              </ion-col>
              <ion-col size="5">
                <ion-searchbar
                  v-model="searchQuery"
                  class="white-searchbar"
                  @ionInput="filterData"
                  placeholder="Search..."
                  animated
                />
              </ion-col>
            </ion-row>

            <div style="overflow-x: auto;">
              <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
                <thead>
                  <tr>
                    <th style="cursor:pointer;" @click="sortData('studID')">
                      StudID
                      <span v-if="sortColumn === 'studID'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('name')">
                      Name
                      <span v-if="sortColumn === 'name'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('course')">
                      Course
                      <span v-if="sortColumn === 'course'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('yearSection')">
                      Year & Section
                      <span v-if="sortColumn === 'yearSection'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('lastupdate')">
                      Last Update
                      <span v-if="sortColumn === 'lastupdate'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('lastupdate')">
                      Face ID Status
                      <span v-if="sortColumn === 'FIDstatus'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="student in paginatedStudents" :key="student.studID">
                    <td>{{ student.studID }}</td>
                    <td> {{ student.first_name }} {{ student.middle_name }} {{ student.last_name }}</td>
                    <td>{{ student.course }}</td>
                    <td>{{ student.yearSection }}</td>
                    <td>{{ student.lastupdate }}</td>
                    <td>{{ student.FIDstatus }}</td>
                    <td>
                      <ion-button 
                        size="small" 
                        fill="solid"  
                        style="--background: #970303;--color: white; --border-radius: 3px; font-weight: 600;" 
                        expand="block"
                        @click="deleteFace(student.studID)"
                      >
                        Reset
                      </ion-button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Pagination Controls -->
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
                :class="['pagination-button', { active: currentPage === page }]"
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
          </ion-content>
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
  IonSelect,
  IonSelectOption,
  IonText,
  IonTitle,
  IonToolbar,
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { computed, ref, onMounted } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';

const router = useRouter();
const apiUrl = 'http://localhost:5000/api/face'; // Node.js backend URL

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

// Sidebar menus
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);

const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

// Table & search state
const students = ref<any[]>([]);
const searchQuery = ref('');
const sortColumn = ref('student_id');
const sortOrder = ref<'asc' | 'desc'>('asc');
const currentPage = ref(1);
const itemsPerPage = 10;

// Fetch face records from backend
const fetchStudents = async () => {
  try {
    const { data } = await axios.get(`${apiUrl}/list`);
    students.value = data.faces.map((face: any) => ({
      studID: face.student_id,
      first_name: face.first_name,    
      middle_name: face.middle_name,   
      last_name: face.last_name,       
      course: face.course,
      yearSection: face.yearSection,
      lastupdate: new Date(face.created_at).toLocaleString(),
      FIDstatus: face.image ? 'Registered' : 'Not Registered',
    }));
    console.log(students.value);
  } catch (err) {
    console.error('Error fetching face records', err);
    Swal.fire('Error', 'Failed to fetch face records', 'error');
  }
};

// Reset face for a student
const deleteFace = async (studID: string) => {
  const confirm = await Swal.fire({
    title: 'Confirm Delete',
    text: `Are you sure you want to reset (delete) Face ID for student ${studID}? This action cannot be undone.`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, Delete',
    cancelButtonText: 'Cancel',
   didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    },
  });

  if (!confirm.isConfirmed) return;

  try {
    await axios.post(`${apiUrl}/delete`, { studentId: studID });
    await Swal.fire({
      title: 'Deleted!',
      text: 'Face ID has been deleted.',
      icon: 'success',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
    await fetchStudents(); 
  } catch (err) {
    console.error('Error deleting face', err);
    await Swal.fire('Error', 'Failed to delete Face ID', 'error');
  }
};


// Computed for filtered & sorted students
const filteredStudents = computed(() => {
  let result = [...students.value];

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter((s) =>
      Object.values(s).some((v) => String(v).toLowerCase().includes(query))
    );
  }

  result.sort((a, b) => {
    let aVal = a[sortColumn.value] ?? '';
    let bVal = b[sortColumn.value] ?? '';
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

const sortData = (col: string) => {
  if (sortColumn.value === col) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortColumn.value = col;
    sortOrder.value = 'asc';
      }
  currentPage.value = 1;
};

const filterData = () => (currentPage.value = 1);

// Fetch data on mount
onMounted(fetchStudents);
</script>

<style scoped>
.toolbar-container::part(backdrop) {
  background-color: #07055d !important;
}

.ad-background {
  --background: url('../../public/img/admin-bg.png');
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
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
ion-title.studrecord {
  text-align: center;
  font-weight: 700;
  padding: 10px;
  font-size: 25px;
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
  padding: 10px;
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
</style>

