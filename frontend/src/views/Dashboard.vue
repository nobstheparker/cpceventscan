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
                    <li>
                      <a href="javascript:void(0);" class="sidebar-link" @click="confirmLogout">
                          Log Out
                      </a>
                  </li>
                </ul>
            </div>
        <div class="main-content">
            <div class="dashboard-cards">
                <div class="dashcard">
                    <div class="dashcard-title">Total Students</div>
                    <div class="dashcard-number">{{ totalStudents }}</div>
                </div>
                <div class="dashcard">
                    <div class="dashcard-title">Total Courses</div>
                    <div class="dashcard-number">{{ totalCourses }}</div>
                </div>
                <div class="dashcard date-time">
                    <div class="dashcard-title">Date & Time</div>
                    <div class="dashcard-time">{{ currentTime }}</div>
                    <div class="dashcard-date">{{ currentDate }}</div>
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
import {
  IonButton,
  IonContent,
  IonHeader,
  IonInput,
  IonPage,
  IonText,
  IonToolbar,
  IonTitle,
  IonItem,
  IonLabel
} from '@ionic/vue';
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import Swal from 'sweetalert2';

const router = useRouter();
const API_URL = 'http://localhost:5000/api/users/admin-login';
const totalStudents = ref(0);
const totalCourses = ref(0);

// --- Sidebar Menus ---
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

const fetchTotalCourses = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/courses/count');
    totalCourses.value = res.data.total;
  } catch (err) {
    console.error('Error fetching total courses:', err);
  }
};
const fetchTotalStudents = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/students/count');
    totalStudents.value = res.data.total;
  } catch (err) {
    console.error('Error fetching total students:', err);
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

const email = ref('');
const password = ref('');

const currentTime = ref('');
const currentDate = ref('');


const updateDateTime = () => {
  const now = new Date();
  currentTime.value = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  currentDate.value = now.toLocaleDateString([], { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
};

updateDateTime();

setInterval(updateDateTime, 1000);
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
  await fetchTotalStudents();
  await fetchTotalCourses();
});

const logIn = async () => {
  if (!email.value || !password.value) {
    Swal.fire({
      icon: 'error',
      title: 'Missing Fields',
      text: 'Please enter both email and password.',
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
    return;
  }

  try {
    const res = await axios.post(API_URL, { email: email.value, password: password.value }, { withCredentials: true });
    router.push('/dashboard'); // Redirect after successful login
  } catch (err: any) {
    Swal.fire({
      icon: 'error',
      title: 'Login Failed',
      text: err.response?.data?.message || 'Invalid credentials',
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
  }
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
.sidebar-title:hover{
  color: #FFFF00; 
}
.sub:hover{
    background-color: #2c2c7a; 
    color: #FFFF00; 
}
.sub{
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
  padding: 15px;
}
.dashcard {
    border-radius: 8px;
    display: inline-block;
    margin-left: 5px;
    overflow: hidden;
    width: 32.9%;
    color: white;
    text-align: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

.dashcard-title {
    background-color: rgba(7, 5, 93, 0.9);
    padding: 15px 0;
    font-weight: bold;
    font-size: 25px;
    text-transform: uppercase;
}
.dashcard-number,
.dashcard-time,
.dashcard-date {
  background-color: rgba(255, 255, 255, 0.15);
  padding: 10px 0;
  font-weight: bold;
}
.dashcard-number{
    font-size: 50px;
}

.date-time .dashcard-time {
  font-size: 20px;
  padding: 7px 0;
}
.date-time .dashcard-date {
  font-size: 20px;
  padding: 10px 0;
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
</style>