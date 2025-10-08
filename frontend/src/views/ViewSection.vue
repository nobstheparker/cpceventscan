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
              <router-link to="/adminLogIn" class="sidebar-link" @click="confirmLogout">
                Log Out
              </router-link>
            </li>
          </ul>
        </div>
        <div class="main-content">
          <ion-title class="regCourse">Registered Sections</ion-title>

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
                    <th style="cursor:pointer;" @click="sortData('sectionID')">
                      Section ID
                      <span v-if="sortColumn === 'sectionID'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('CourseCode')">
                      Course Code
                      <span v-if="sortColumn === 'CourseCode'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('YearLvl')">
                      Year Level
                      <span v-if="sortColumn === 'YearLvl'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('sec')">
                      Section
                      <span v-if="sortColumn === 'sec'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="width: 150px; text-align: center;">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="sec in paginatedSection" :key="sec.sectionID">
                    <td>{{ sec.sectionID }}</td>
                    <td>{{ sec.CourseCode }}</td>
                    <td>{{ sec.YearLvl }}</td>
                    <td>{{ sec.sec }}</td>
                    <td class="action-btn">
                      <ion-button @click="openModal(sec)" style="--background: #F1C204; --color: black;">Update</ion-button>
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
        </div>
        <ion-modal :is-open="isModalOpen" @didDismiss="closeModal" class="bootstrap-modal">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Edit Section</h5>
                <button type="button" class="btn-close" @click="closeModal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <ion-item>
                  <ion-label position="floating">Course Code</ion-label>
                  <select v-model="modalData.course_code" required style="width:100%; padding:8px;">
                    <option disabled value="">Select Course</option>
                    <option v-for="course in courses" :key="course.course_id" :value="String(course.course_id)">
                      {{ course.course_code }}
                    </option>
                  </select>
                </ion-item> 
                <ion-item>
                  <ion-label position="floating">Year Level</ion-label>
                  <select v-model="modalData.year_level" required style="width:100%; padding:8px;">
                    <option disabled value="">Select Year Level</option>
                    <option v-for="year in yearLevels" :key="year.YearID" :value="String(year.YearID)">
                      {{ year.YearLvl }}
                    </option>
                  </select>
                </ion-item>
                <ion-item>
                  <ion-label position="floating">Section Name</ion-label>
                  <ion-input
                    v-model="modalData.section_name"
                    ref="sectionInput"
                  ></ion-input>
                </ion-item>
              </div>
              <div class="modal-footer">
                <ion-button color="danger" @click="closeModal">Cancel</ion-button>
                <ion-button :disabled="isSaving" color="primary" @click="saveSectionUpdate">
                  {{ isSaving ? 'Saving...' : 'Update Section' }}
                </ion-button>
              </div>
            </div>
          </div>
        </ion-modal>
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
  IonTitle,
  IonToolbar,
  IonItem,
  IonLabel,
  IonInput,
  IonModal
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { computed, ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();
const courses = ref([]);
const yearLevels = ref([]);
const isModalOpen = ref(false);
const modalData = ref({
  section_id: '',
  course_code: '',
  year_level: '',
  section_name: ''
});
const isSaving = ref(false);
const sectionInput = ref();
const section = ref<SectionData[]>([]);

const openModal = (sec: SectionData) => {
  modalData.value = {
    section_id: sec.sectionID,
    course_code: sec.CourseID,
    year_level: sec.YearID,
    section_name: sec.sec,
  };
  isModalOpen.value = true;

  setTimeout(() => {
    sectionInput.value?.$el?.querySelector('input')?.focus();
  }, 300);
};

const closeModal = () => {
  isModalOpen.value = false;
};

const saveSectionUpdate = async () => {
  if (!modalData.value.course_code || !modalData.value.year_level || !modalData.value.section_name) {
    Swal.fire('Error', 'Please complete all fields.', 'error');
    return;
  }

  isSaving.value = true;
  try {
    await axios.put(`http://localhost:5000/api/sections/update/${modalData.value.section_id}`, {
      courseId: Number(modalData.value.course_code),
      yearId: Number(modalData.value.year_level),
      sectionName: modalData.value.section_name
    });
    Swal.fire({
      title: 'Success',
      text: 'Section updated successfully.',
      icon: 'success',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
    fetchSections();
    closeModal();
  } catch (error) {
    console.error('Failed to update section:', error);
    Swal.fire({
      title: 'Error',
      text: 'Failed to update section.',
      icon: 'error',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  } finally {
    isSaving.value = false;
  }
};

const confirmLogout = async () => {
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: 'You will be logged out and redirected to the login page.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, log me out!',
  });

  if (result.isConfirmed) {
    router.push('/login');
  }
};

const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);

const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

interface SectionData {
  sectionID: number;
  CourseID: number; 
  YearID: number;   
  CourseCode: string;
  YearLvl: string;
  sec: string;
}


const fetchSections = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/sections/list');
    section.value = res.data.sections.map((sec: any) => ({
      sectionID: sec.section_id,
      CourseID: String(sec.course_id),  
      YearID: String(sec.year_id),      
      CourseCode: sec.course_code, 
      YearLvl: sec.year_level,   
      sec: sec.section_name,
    }));
  } catch (error) {
    console.error('Failed to fetch sections:', error);
    Swal.fire('Error', 'Failed to load sections.', 'error');
  }
};

const fetchCourses = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/courses/list');
    courses.value = res.data.courses;
  } catch (error) {
    console.error('Failed to fetch courses:', error);
  }
};

const fetchYearLevels = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/year-level/list');
    yearLevels.value = res.data.yearLevels;
  } catch (error) {
    console.error('Failed to fetch year levels:', error);
  }
};

onMounted(() => {
  fetchSections();
  fetchCourses();
  fetchYearLevels();
});

const searchQuery = ref('');
const sortColumn = ref<keyof SectionData>('sectionID');
const sortOrder = ref<'asc' | 'desc'>('asc');
const currentPage = ref(1);
const itemsPerPage = 10;

const filteredSection = computed(() => {
  let result = [...section.value];

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter((sec) =>
      Object.values(sec).some((value) =>
        String(value).toLowerCase().includes(query)
      )
    );
  }

  const column = sortColumn.value;
  result.sort((a, b) => {
    let aValue = a[column];
    let bValue = b[column];

    aValue = typeof aValue === 'string' ? aValue.toLowerCase() : aValue;
    bValue = typeof bValue === 'string' ? bValue.toLowerCase() : bValue;

    if (aValue < bValue) return sortOrder.value === 'asc' ? -1 : 1;
    if (aValue > bValue) return sortOrder.value === 'asc' ? 1 : -1;
    return 0;
  });

  return result;
});

const totalPages = computed(() => {
  return Math.ceil(filteredSection.value.length / itemsPerPage);
});

const paginatedSection = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredSection.value.slice(start, start + itemsPerPage);
});

const sortData = (column: keyof SectionData) => {
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
table th {
  user-select: none;
  border: 1px solid #07055d;
}
select{
   padding: 10px 10px !important;
    border: 1px solid rgb(204, 204, 204);
    border-radius: 4px;
    margin-left: -3px;
    color: black;
    background: #e6e6e6;
}
.action-btn{
  display: table-cell !important;
  width: 150px !important;
  text-align: center;
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
  --height: 450px !important;
}
.bootstrap-modal select {
  width: 100%;
  padding: 10px 5px;
  border: 0;
  background: #cdcaca;
}
</style>

