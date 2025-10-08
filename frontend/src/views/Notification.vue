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
            <li>
              <router-link to="/Request" class="sidebar-link">Request Management</router-link>
            </li>
            <li>
              <router-link to="/Notif" class="sidebar-link">Notification Management</router-link>
            </li>
            <li>
              <router-link to="/Feed" class="sidebar-link">Feedback Management</router-link>
            </li>
            <li>
              <router-link to="/Update" class="sidebar-link">Featured Updates</router-link>
            </li>
            <li><router-link to="/account-center" class="sidebar-link">Account Center</router-link></li>
            <li>
              <router-link to="/adminLogIn" class="sidebar-link" @click="confirmLogout">
                Log Out
              </router-link>
            </li>
          </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
          <h2>NOTIFICATION MANAGEMENT</h2>
          <div style="display: flex; justify-content: flex-end; gap: 15px; margin-top: 20px;">
            <ion-button
              style="--background: green; --color: white; font-weight: 700; --border-radius: 5px; width: 300px;"
              @click="openCreateModal">Add New Notification
            </ion-button>
          </div>

          <!-- Modal -->
          <ion-modal :is-open="isModalOpen" @didDismiss="closeModal">
            <div style="background:white; border-radius:8px; overflow:hidden; margin-top: 10px;">
              <div style="background:#07055D; color:white; padding:10px; display:flex; justify-content:space-between; align-items:center;">
                <b>{{ isEdit ? 'Edit Notification' : 'New Notification' }}</b>
                <button @click="isModalOpen = false" style="background:none; border:none; color:white; font-size:18px;">✖</button>
              </div>
              <div style="padding:15px 15px; background:#D9D9D9;">
                <label><b>Notification Type:</b></label>
                <input v-model="newNotification.type" placeholder="Enter type"
                  style="width:100%; padding:6px; border:1px solid #b1b1b2; border-radius:4px; background-color:white; font-size:14px; color:black; margin-bottom:5px;" />

                <label><b>Message:</b></label>
                <textarea v-model="newNotification.message" placeholder="Enter message"
                  style="width: 100%; padding: 6px; border: 1px solid #b1b1b2; border-radius: 4px; background-color: white; font-size: 14px; color: black; min-height: 40px; max-height: 180px; overflow-y: auto; resize: vertical;">
                </textarea>

                <label><b>Recipient:</b></label>
                <div class="radio-group" style="margin-bottom:10px; margin-top:5px;">
                  <label style="margin-right:10px;">
                    <input type="radio" value="all" v-model="selectionMode" /> All Students
                  </label>
                  <label style="margin-right:10px;">
                    <input type="radio" value="byCourse" v-model="selectionMode" /> By Course
                  </label>
                  <label>
                    <input type="radio" value="manual" v-model="selectionMode" /> Manual Selection
                  </label>
                </div>

                <div v-if="selectionMode === 'byCourse'" style="margin-bottom:10px;">
                  <label>Select Course:</label>
                  <select v-model="selectedCourse" style="width:100%; padding:6px; border:1px solid #b1b1b2; border-radius:4px; background:white;">
                    <option disabled value="">Select a course</option>
                    <option v-for="course in courses" :key="course.id" :value="course.course_id">{{ course.course_code }}</option>
                  </select>
                </div>

                <div v-if="selectionMode === 'manual'" style="margin-bottom:10px;">
                  <label>Manual Selection:</label>
                  <div class="select-wrapper" style="display:flex; gap:5px; margin-bottom:5px;">
                    <input
                      type="text"
                      :value="selectedStudentNames"
                      readonly
                      placeholder="Select students..."
                      style="flex:1; padding:6px; border:1px solid rgb(177,177,178); border-radius:4px; background:#ffffff; color:black;"
                    />
                    <button type="button" @click="showStudentDropdown = !showStudentDropdown"
                      style="padding:6px 10px; background:#07055D; color:white; border:none; border-radius:4px;">
                      Select
                    </button>
                  </div>

                  <div v-if="showStudentDropdown" style="border:1px solid #ccc; border-radius:4px; max-height:200px; overflow:auto; background:white; padding:5px;">
                    <div style="display:flex; justify-content:space-between; margin-bottom:5px;">
                      <label>
                        <input type="checkbox" v-model="selectAll" @change="toggleAllStudents" /> Select All
                      </label>
                      <input type="text" placeholder="Search..." v-model="searchQueryStudents" style="padding:3px; border:1px solid #ccc; border-radius:4px;" />
                    </div>
                    <div class="student-list">
                      <label v-for="student in filteredStudents" :key="student.id" style="display:block; padding:2px 0;">
                        <input type="checkbox" :value="student.id" v-model="selectedStudents" />
                        {{ student.full_name }}
                      </label>
                    </div>
                  </div>
                </div>

                <ion-button fill="solid"
                  style="--background:#07055D; --color:#ffff00; font-weight:700; width:120px; display:flex; margin:15px auto; margin-top:12px;"
                  @click="saveNotification">
                  {{ isEdit ? 'Update' : 'Save' }}
                </ion-button>
              </div>
              <div style="background:#07055D; padding:10px; text-align:right; height:50px;"></div>
            </div>
          </ion-modal>

          <!-- Notification Table -->
          <div style="--background: transparent;">
            <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
              <ion-col size="7">
                <select v-model="sortColumn" style="padding:6px 10px; border:1px solid #ccc; border-radius:4px; margin-left:-3px;">
                  <option disabled value="">Sort By</option>
                  <option value="notif_type">Notification Type</option>
                  <option value="created_at">Date Created</option>
                  <option value="updated_at">Last Modified</option>
                </select>
              </ion-col>
              <ion-col size="5">
                <ion-searchbar v-model="searchQuery" class="white-searchbar" placeholder="Search..." animated />
              </ion-col>
            </ion-row>

            <div style="overflow-x:auto;">
              <table style="width:100%; border-collapse: collapse; font-size:14px;">
                <thead>
                  <tr>
                    <th style="cursor:pointer;" @click="sortData('notif_type')">Notification Type</th>
                    <th style="cursor:pointer;" @click="sortData('notif_message')">Message</th>
                    <th style="cursor:pointer;" @click="sortData('created_at')">Date Created</th>
                    <th style="cursor:pointer;" @click="sortData('updated_at')">Last Modified</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="notif in paginatedNotifications" :key="notif.id">
                    <td>{{ notif.notif_type }}</td>
                    <td>{{ notif.notif_message }}</td>
                    <td>{{ formatDate(notif.created_at) }}</td>
                    <td>{{ formatDate(notif.updated_at) }}</td>
                    <td>
                      <ion-button size="small" fill="solid" style="--background:#F1C204; --color:black; --border-radius:3px; font-weight:600;" expand="block"
                        @click="openEditModal(notif)">Edit</ion-button>
                      <ion-button size="small" fill="solid" style="--background:#ca0404; --color:white; --border-radius:3px; font-weight:600;" expand="block"
                        @click="deleteNotification(notif.id)">Delete</ion-button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Pagination -->
            <div class="pagination-container">
              <button :disabled="currentPage === 1" @click="currentPage--" class="pagination-button">&laquo; Prev</button>
              <button v-for="page in totalPages" :key="page" :class="['pagination-button', { active: currentPage === page }]" @click="currentPage = page">{{ page }}</button>
              <button :disabled="currentPage === totalPages" @click="currentPage++" class="pagination-button">Next &raquo;</button>
            </div>
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
import { IonButton, IonCol, IonContent, IonHeader, IonIcon, IonModal, IonPage, IonRow, IonSearchbar, IonText, IonToolbar } from '@ionic/vue';
import { notificationsOutline } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { ref, reactive, computed, onMounted } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';

const router = useRouter();
const notifications = notificationsOutline;

// Sidebar toggles
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

// Logout
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
      document.body.classList.remove("swal2-height-auto");
      document.documentElement.classList.remove("swal2-height-auto");
    }
  });
  if (result.isConfirmed) router.push('/login');
};

// Modal & form
const isModalOpen = ref(false);
const isEdit = ref(false);
const editId = ref<number | null>(null);
const newNotification = reactive({
  type: '',
  message: '',
  recipient: ''
});

// Backend data
const courses = ref<any[]>([]);
const students = ref<any[]>([]);
const notificationsList = ref<any[]>([]);
const selectionMode = ref<'all' | 'byCourse' | 'manual'>('all');
const selectedCourse = ref('');
const showStudentDropdown = ref(false);
const selectedStudents = ref<number[]>([]);
const selectAll = ref(false);
const searchQueryStudents = ref('');

// Fetch data safely
const fetchCourses = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/courses/list');
    courses.value = Array.isArray(res.data.courses) ? res.data.courses : [];
    console.log('Courses:', courses.value);
  } catch (err) { console.error(err); courses.value = []; }
};
const fetchStudents = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/students/list');
    if (Array.isArray(res.data.students)) {
      students.value = res.data.students.map(s => ({
        ...s,
        full_name: `${s.first_name} ${s.middle_name} ${s.last_name}`
      }));
      console.log('Students:', students.value);
    } else { students.value = []; }
  } catch (err) { console.error(err); students.value = []; }
};
const fetchNotifications = async () => {
  try { const res = await axios.get('http://localhost:5000/api/notifications/list-all'); notificationsList.value = Array.isArray(res.data) ? res.data : []; } catch (err) { console.error(err); notificationsList.value=[]; }
};

onMounted(() => { fetchCourses(); fetchStudents(); fetchNotifications(); });

// Computed
const filteredStudents = computed(() => {
  return students.value.filter(s =>
    s.full_name.toLowerCase().includes(searchQueryStudents.value.toLowerCase())
  );
});

const selectedStudentNames = computed(() => {
  return students.value
    .filter(s => selectedStudents.value.includes(s.id))
    .map(s => s.full_name)
    .join(', ');
});
const searchQuery = ref('');
const sortColumn = ref('');
const sortOrder = ref<'asc'|'desc'>('asc');
const currentPage = ref(1);
const itemsPerPage = 10;

const sortData = (column: string) => {
  if(sortColumn.value === column) sortOrder.value = sortOrder.value==='asc'?'desc':'asc';
  else { sortColumn.value = column; sortOrder.value = 'asc'; }
  currentPage.value = 1;
};
const formatDate = (dateString: string | null) => {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('en-US', {
    month: 'long',    // Full month name
    day: 'numeric',   
    year: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
    hour12: true      // 12-hour format
  }).format(date);
};

const sortedNotifications = computed(() => {
  let data = [...notificationsList.value];
  if(searchQuery.value) {
    const q = searchQuery.value.toLowerCase();
    data = data.filter(n => Object.values(n).some(v => String(v).toLowerCase().includes(q)));
  }
  if(sortColumn.value) {
    data.sort((a,b)=> {
      const aVal = String(a[sortColumn.value]??'').toLowerCase();
      const bVal = String(b[sortColumn.value]??'').toLowerCase();
      return (aVal<bVal?-1:aVal>bVal?1:0)*(sortOrder.value==='asc'?1:-1);
    });
  }
  return data;
});

const totalPages = computed(()=> Math.ceil(sortedNotifications.value.length/itemsPerPage));
const paginatedNotifications = computed(()=> {
  const start = (currentPage.value-1)*itemsPerPage;
  return sortedNotifications.value.slice(start, start+itemsPerPage);
});

// Modal actions
const openCreateModal = () => {
  isEdit.value = false; editId.value = null;
  newNotification.type=''; newNotification.message=''; newNotification.recipient='';
  selectionMode.value='all'; selectedCourse.value=''; selectedStudents.value=[]; selectAll.value=false; showStudentDropdown.value=false; searchQueryStudents.value='';
  isModalOpen.value = true;
};
const openEditModal = (notif:any) => {
  isEdit.value = true; editId.value = notif.id;
  newNotification.type=notif.notif_type; newNotification.message=notif.notif_message;
  selectionMode.value=notif.recipient_mode || 'all';
  selectedCourse.value=''; selectedStudents.value=[]; // optionally map
  isModalOpen.value = true;
};
const closeModal = () => { isModalOpen.value=false; };

const saveNotification = async () => {
  const payload = {
    notif_type: newNotification.type,
    notif_message: newNotification.message,
    recipient_mode: selectionMode.value,
    selected_courses: selectionMode.value === 'byCourse' ? [selectedCourse.value] : [],
    selected_students: selectionMode.value === 'manual' ? selectedStudents.value : []
  };

  try {
    if (isEdit.value && editId.value) {
  // CALL UPDATE API
  await axios.put(`http://localhost:5000/api/notifications/update/${editId.value}`, payload);
    Swal.fire({
      icon: 'success',
      title: 'Notification updated!',
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
  } else {
    // CALL CREATE API
    await axios.post('http://localhost:5000/api/notifications/create', payload);
    Swal.fire({
      icon: 'success',
      title: 'Notification created!',
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
  }
    await fetchNotifications();
    closeModal();
  } catch (err) {
    console.error(err);
    Swal.fire({ icon: 'error', title: 'Error saving notification' });
  }
};


const deleteNotification = async (id:number) => {
  const result = await Swal.fire({
    title:'Delete?',
    text:'This will permanently remove the notification.',
    icon:'warning',
    showCancelButton:true,
    confirmButtonText:'Yes, delete it!',
    didOpen: () => {
      document.body.classList.remove("swal2-height-auto");
      document.documentElement.classList.remove("swal2-height-auto");
   } 
  });
  if (result.isConfirmed) {
  try {
    await axios.delete(`http://localhost:5000/api/notifications/delete/${id}`);
    await fetchNotifications();
    Swal.fire({
      icon: 'success',
      title: 'Deleted!',
      text: 'Notification removed',
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
  } catch (err) {
    console.error(err);
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to delete',
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
  }
}
};

// Select all toggle
const toggleAllStudents = () => { selectedStudents.value = selectAll.value ? students.value.map(s=>s.id):[]; };
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
h4{
    font-size: 24px;
    margin-top: 10px;
    margin-bottom: 0px !important;
    font-weight: 700;
    text-align: center;
}
h2{
    font-size: 24px;
    margin-top: 0px;
    margin-bottom: 0px !important;
    font-weight: 700;
    text-align: center;
}

.requestTable {
  width: 100%;
  border-collapse: collapse;
  font-size: 18px;
}

.requestTable th,
.requestTable td {
  text-align: center;
  padding: 12px;
  border: 1px solid #ccc;
}

.requestTable th {
  background-color: #07055D;
  color: white;
  font-weight: bold;
}
.requestTable tbody{
    color: #19191a;
    background: #d4dce9;
}
.requestTable td{
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
ion-modal {
  --background: transparent !important;
  --ion-background-color: transparent !important;
  --box-shadow: none !important;
  border-radius: 5px !important;
  margin-top: 10px;
}
ion-modal::part(backdrop) {
  background: transparent !important;
}
label{
  color: #202222;
  font-size: 15px !important;
}
b{
  margin: 0 auto;
  font-size: 16px;
}
</style>