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
                    <th @click="sortData('CourseCode')" style="cursor: pointer;">
                      Course Code <span v-if="sortColumn === 'CourseCode'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th @click="sortData('YearLvl')" style="cursor: pointer;">
                      Year Level <span v-if="sortColumn === 'YearLvl'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="width: 150px; text-align: center;">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="item in paginatedYears" :key="item.YearID">
                    <td>{{ item.CourseCode }}</td>
                    <td>{{ item.YearLvl }}</td>
                    <td class="act-btn" style="display: flex;">
                      <ion-button size="small" fill="solid" style="--background: #F1C204; --color: black;" @click="openEditModal(item)">Update</ion-button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

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
          </ion-content>
        </div>

        <!-- Modal -->
        <ion-modal :is-open="isModalOpen" @didDismiss="closeModal" class="bootstrap-modal">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Edit Year Level</h5>
                <button type="button" class="btn-close" @click="closeModal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <ion-item>
                  <ion-label position="floating">Course Code</ion-label>
                  <select v-model="selectedCourseId" required>
                    <option disabled value="">Select Course</option>
                    <option
                      v-for="course in courses"
                      :key="course.course_id"
                      :value="course.course_id"
                    >
                      {{ course.course_code }}
                    </option>
                  </select>
                </ion-item>
                <ion-item>
                  <ion-label position="floating">Year Level</ion-label>
                  <ion-input v-model="newYearLvl" />
                </ion-item>
              </div>
              <div class="modal-footer">
                <ion-button color="danger" @click="closeModal">Cancel</ion-button>
                <ion-button color="primary" @click="updateYearLevel">Save Changes</ion-button>
              </div>
            </div>
          </div>
        </ion-modal>
      </div>
    </ion-content>

    <div class="footer">
      <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
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
  IonModal,
  IonItem,
  IonLabel,
  IonInput,
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import Swal from 'sweetalert2';

interface YearLevel {
  YearID: number;
  CourseCode: string;
  YearLvl: string;
}

const router = useRouter();
const isModalOpen = ref(false);
const year = ref<YearLevel[]>([]);
const courses = ref<{ course_id: number; course_code: string; course_name: string }[]>([]);
const selectedCourseId = ref<number | ''>(''); 
const selectedYear = ref<YearLevel | null>(null);
const newCourseCode = ref('');
const newYearLvl = ref('');

const searchQuery = ref('');
const sortColumn = ref<keyof YearLevel>('YearID');
const sortOrder = ref<'asc' | 'desc'>('asc');
const currentPage = ref(1);
const itemsPerPage = 10;

const closeModal = () => {
  isModalOpen.value = false;
};

const fetchYearLevels = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/year-level/list');
    year.value = res.data.yearLevels;
    courses.value = [...new Set(res.data.yearLevels.map(item => item.CourseCode).filter(Boolean))];
  } catch (error) {
    console.error(error);
  }
};

fetchYearLevels();

const fetchCourses = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/courses/list');
    courses.value = res.data.courses;
  } catch (error) {
    console.error('Failed to fetch courses:', error);
    Swal.fire('Error', 'Failed to load courses.', 'error');
  }
};

fetchCourses();

const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);

const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

const openEditModal = (item: YearLevel) => {
  selectedYear.value = { ...item };
  newYearLvl.value = item.YearLvl;
  selectedCourseId.value = item.CourseID;  // ✅ Use CourseID here from API result
  isModalOpen.value = true;
};

const updateYearLevel = async () => {
  if (!selectedYear.value) return;
  try {
    await axios.put(`http://localhost:5000/api/year-level/update/${selectedYear.value.YearID}`, {
      courseId: selectedCourseId.value,  
      yearLevel: newYearLvl.value  
    });

    Swal.fire({
      icon: 'success',
      title: 'Success',
      text: 'Year Level Updated Successfully.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    }).then(() => {
      // ✅ Reload the page after closing the SweetAlert
      window.location.reload();
    });

  } catch (error) {
    console.error(error);
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to update year level.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};
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
const filteredYear = computed(() => {
  let result = [...year.value];
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(item =>
      Object.values(item).some(val => String(val).toLowerCase().includes(query))
    );
  }

  result.sort((a, b) => {
    const aVal = a[sortColumn.value];
    const bVal = b[sortColumn.value];
    const aStr = typeof aVal === 'string' ? aVal.toLowerCase() : aVal;
    const bStr = typeof bVal === 'string' ? bVal.toLowerCase() : bVal;
    return (aStr < bStr ? -1 : 1) * (sortOrder.value === 'asc' ? 1 : -1);
  });

  return result;
});

const paginatedYears = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredYear.value.slice(start, start + itemsPerPage);
});

const totalPages = computed(() => {
  return Math.ceil(filteredYear.value.length / itemsPerPage);
});

const sortData = (column: keyof YearLevel) => {
  if (sortColumn.value === column) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortColumn.value = column;
    sortOrder.value = 'asc';
  }
};

const filterData = () => {
  currentPage.value = 1;
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
      router.replace('/adminLogIn'); 
    }
  } catch (err) {
    console.error('Session check failed:', err);
    router.replace('/adminLogIn');
  }
});
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
ion-title.regCourse {
  text-align: center;
  font-weight: 600;
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
.act-btn ion-button{
  width: 100px;
  font-size: 0.875rem !important;
}
.main-content ion-title {
   color: #fff;
}
.bootstrap-modal .modal-dialog {
  width: 100%;
  height: 100%;
}

.bootstrap-modal .modal-content {
  border-radius: 0.5rem;
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
  background-color: #fff;
  height: 100%;
}

.bootstrap-modal .modal-header,
.bootstrap-modal .modal-footer {
  padding: 1rem;
  border-bottom: 1px solid #dee2e6;
}
.bootstrap-modal .modal-footer {
  position: absolute;
  bottom: 0;
  width: 100%;
}
.bootstrap-modal .modal-header {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  background: #07055d;
  color: #fff;
}

.bootstrap-modal .modal-title {
  margin: 0;
  font-size: 1.25rem;
}

.bootstrap-modal .btn-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
}

.bootstrap-modal .modal-body {
  padding: 1rem;
  padding-top: 0;
}

.bootstrap-modal .modal-footer {
  border-top: 1px solid #dee2e6;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
.bootstrap-modal ion-label{
  display: block;
  margin-bottom: 25px;
}
.bootstrap-modal ion-input {
  line-height: 0;
  background: #cdcaca;
  padding: 0 10px !important;
}
.bootstrap-modal ion-item{
    --inner-padding-end: 0px;
    --padding-start:0px
}
.bootstrap-modal {
  --height: 360px !important;
}
.bootstrap-modal select {
  width: 100%;
  padding: 10px 5px;
  border: 0;
  background: #cdcaca;
}
.act-btn {
  display: table-cell !important;
  width: 150px !important;
  text-align: center;
}
</style>

