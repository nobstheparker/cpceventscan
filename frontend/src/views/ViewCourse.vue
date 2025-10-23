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
                    <th @click="sortData('course_code')">
                      Course Code
                      <span v-if="sortColumn === 'course_code'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th @click="sortData('course_name')">
                      Course Name
                      <span v-if="sortColumn === 'course_name'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="width: 150px; text-align: center;">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="course in paginatedCourse" :key="course.course_id">
                    <td>{{ course.course_code }}</td>
                    <td>{{ course.course_name }}</td>
                    <td class="action-btn">
                      <ion-button @click="openModal(course)" style="--background: #F1C204; --color: black;">Update</ion-button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
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
          <ion-modal :is-open="isModalOpen" @didDismiss="closeModal" class="bootstrap-modal">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Update Course</h5>
                  <button type="button" class="btn-close" @click="closeModal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <ion-item>
                    <ion-label position="floating">Course Code</ion-label>
                    <ion-input v-model="modalCourseCode" />
                  </ion-item>
                  <ion-item>
                    <ion-label position="floating">Course Name</ion-label>
                    <ion-input v-model="modalCourseName" />
                  </ion-item>
                </div>
                <div class="modal-footer">
                  <ion-button color="danger" @click="closeModal">Cancel</ion-button>
                  <ion-button color="primary" @click="updateCourseInModal">Save Changes</ion-button>
                </div>
              </div>
            </div>
          </ion-modal>
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
  IonModal,
  IonInput,
  IonItem,
  IonLabel,
  IonPage,
  IonRow,
  IonSearchbar,
  IonText,
  IonTitle,
  IonToolbar,
  IonButtons,
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { computed, ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const courses = ref<any[]>([]);
const router = useRouter();

const isModalOpen = ref(false);
const modalCourseCode = ref('');
const modalCourseName = ref('');
let currentCourseId = ref(null);

const openModal = (course) => {
  modalCourseCode.value = course.course_code;
  modalCourseName.value = course.course_name;
  currentCourseId.value = course.course_id;
  isModalOpen.value = true;
};

const closeModal = () => {
  isModalOpen.value = false;
};

const updateCourseInModal = async () => {
  try {
    await axios.put(`http://localhost:5000/api/courses/update/${currentCourseId.value}`, {
      CourseCode: modalCourseCode.value,
      CourseName: modalCourseName.value
    });
    Swal.fire({
      icon: 'success',
      title: 'Success',
      text: 'Course updated successfully.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });

    fetchCourses();
    closeModal();
  } catch (error) {
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to update course.',
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

const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);

const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

const searchQuery = ref('');
const sortColumn = ref('courseID');
const sortOrder = ref<'asc' | 'desc'>('asc');

const currentPage = ref(1);
const itemsPerPage = 10;

const filteredCourse = computed(() => {
  let result = [...courses.value];

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter((course) =>
      Object.values(course).some((value) =>
        String(value).toLowerCase().includes(query)
      )
    );
  }

  result.sort((a, b) => {
    let aValue = a[sortColumn.value];
    let bValue = b[sortColumn.value];

    aValue = typeof aValue === 'string' ? aValue.toLowerCase() : aValue;
    bValue = typeof bValue === 'string' ? bValue.toLowerCase() : bValue;

    if (aValue < bValue) return sortOrder.value === 'asc' ? -1 : 1;
    if (aValue > bValue) return sortOrder.value === 'asc' ? 1 : -1;
    return 0;
  });

  return result;
});

const totalPages = computed(() => {
  return Math.ceil(filteredCourse.value.length / itemsPerPage);
});

const paginatedCourse = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredCourse.value.slice(start, start + itemsPerPage);
});

const sortData = (column: string) => {
  if (sortColumn.value === column) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortColumn.value = column;
    sortOrder.value = 'asc';
  }
  currentPage.value = 1;
};

const filterData = () => {
  currentPage.value = 1;
};

const fetchCourses = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/courses/list');
    courses.value = response.data.courses;
  } catch (error) {
    console.error('Failed to fetch courses:', error);
    Swal.fire('Error', 'Failed to load courses.', 'error');
  }
};
fetchCourses();
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
  border: 2px solid #07055d !important;
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
  background-color: #007BFF;
  color: white;
  border: none;
  border-radius: 3px;
  font-size: 14px;
  cursor: pointer;
}

.blue-button:hover {
  background-color: #0069d9; 
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
tbody{
  background: none !important;
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
.main-content ion-title {
  color: #fff !important;
}
.action-btn{
  display: table-cell !important;
  width: 150px !important;
  text-align: center;
}
.action-btn ion-button {
  width: 100px;
}
.bootstrap-modal .modal-dialog {
  width: 100%;
  height: 800%;
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
  --height: 352px !important;
}
</style>

