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
                <li>
                    <router-link to="/account-center" class="sidebar-link">Account Center</router-link>
                </li>
                <li>
                    <router-link to="/adminLogIn" class="sidebar-link" @click="confirmLogout">
                    Log Out
                </router-link>
                </li>
            </ul>
        </div>
        <div class="main-content">
          <div class="form-wrapper">
            <ion-card class="year">
              <ion-card-header>
                <ion-card-title class="addsec">Add Section</ion-card-title>
              </ion-card-header>

              <ion-card-content>
                <div class="form-row">
                  <label>Course</label>
                  <select v-model="selectedCourseId" required>
                    <option disabled value="">Select Course</option>
                    <option v-for="course in courses" :key="course.course_id" :value="course.course_id">
                      {{ course.course_code }}
                    </option>
                  </select>
                </div>

                <div class="form-row">
                  <label>Year Level</label>
                  <select v-model="selectedYearId" required>
                    <option disabled value="">Select Year Level</option>
                    <option v-for="year in yearLevels" :key="year.YearID" :value="year.YearID">
                      {{ year.YearLvl }}
                    </option>
                  </select>
                </div>

                <div class="form-row">
                  <label>Section</label>
                  <ion-input v-model="sec" required></ion-input>
                </div>

                <ion-button expand="block" class="ion-addsec" @click="handleRegister">
                  Add
                </ion-button>
              </ion-card-content>

              <ion-toolbar class="reg-footer"></ion-toolbar>
            </ion-card>
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
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardTitle,
  IonContent,
  IonHeader,
  IonIcon,
  IonInput,
  IonPage,
  IonText,
  IonToolbar
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import Swal from 'sweetalert2';
import axios from 'axios';

const router = useRouter();

const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);

const toggleStudentMenu = () => showStudentMenu.value = !showStudentMenu.value;
const toggleAcadMenu = () => showAcadMenu.value = !showAcadMenu.value;
const toggleEventMenu = () => showEventMenu.value = !showEventMenu.value;

const courses = ref([]);
const yearLevels = ref([]);
const selectedCourseId = ref('');
const selectedYearId = ref('');
const sec = ref('');

const fetchCourses = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/courses/list');
    courses.value = res.data.courses;
  } catch (err) {
    console.error('Failed to fetch courses:', err);
  }
};

const fetchYearLevels = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/year-level/list');
    yearLevels.value = res.data.yearLevels;
  } catch (err) {
    console.error('Failed to fetch year levels:', err);
  }
};

const handleRegister = async () => {
  if (!selectedCourseId.value || !selectedYearId.value || !sec.value) {
    Swal.fire('Error', 'Please complete all fields.', 'error');
    return;
  }

  try {
    await axios.post('http://localhost:5000/api/sections/create', {
      courseId: selectedCourseId.value,
      yearId: selectedYearId.value,
      sectionName: sec.value
    });

    Swal.fire({
      icon: 'success',
      title: 'Success',
      text: 'Section Added Successfully.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });

    selectedCourseId.value = '';
    selectedYearId.value = '';
    sec.value = '';
  } catch (err) {
    console.error('Failed to add section:', err);
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to add section.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};

onMounted(() => {
  fetchCourses();
  fetchYearLevels();
});
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
.birthday-box{
  font-size: 18px;
    background: #d4dce9;
    border: 1px solid gray;
    padding: 8px;
    width: 54vh;
    font-family: 'Open Sans' !important;
    color: #555 ;
}
.birthday-wrapper {
  position: relative;
  width: max-content;
}
.calendar-overlay {
  position: absolute;
  top: 100%;
  left: 0;
  z-index: 1000;
  background: white;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  border-radius: 6px;
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
}
.footer {
  margin-top: auto;
  text-align: center;
  color: white;
}
.addsec{
    text-align: center;
    font-weight: bolder;
    color: white;
}
.main-content {
  --background: #ffffff;
}

.form-wrapper {
  padding: 10px;
    display: block;
    margin: 0 auto;
    width: 800px;
}

.form-row {
  margin-bottom: 10px;
  display: flex;
  flex-direction: column;
}

.form-row.double {
  flex-direction: row;
  gap: 16px;
  margin-bottom: 10px;
}
.form-row.double ion-input{
  width: 54vh;
}
.form-row-acad ion-select{
    width: 35vh;
    border: 1px solid gray;
    border-radius: 0px;
    margin-bottom: 15px;
}

.form-row label {
    margin-bottom: 6px;
    color: #343333;
    margin-top: 13px;
    font-weight: 600;
    font-size: 16px;
}
.form-row-con label{
  margin-bottom: 6px;
  color: #343333;
  margin-top: 13px;
  font-weight: 600;
  font-size: 16px;
}
.form-row-acad label{
  margin-bottom: 6px;
  color: #343333;
  margin-top: 13px;
  font-weight: 600;
  font-size: 16px;
}
.form-row-con ion-input{
  margin-bottom: 10px;
}
  ion-input{
  background: #d4dce9;
  border: 1px #8d8e95 solid;
  margin: 0 auto;
  padding-left: 5px !important;
  color: #19191a;
  font-size: 15px;
  font-weight: 600;
}

ion-card-header{
 background-color: #07055D;
}
ion-card-content{
  background-color: #b3b3b3;
  padding: 0 20px;
}
ion-card{
  background: #b3b3b3 !important;
}
.reg-footer{
   background-color: #07055D;
   margin-top: 10px;
}
ion-input{
  background: #d4dce9;
  border: 1px #8d8e95 solid;
  margin: 0 auto;
  padding-left: 5px !important;
  color: #19191a;
  font-size: 15px;
  font-weight: 600;
}
ion-select,
ion-datetime-button {
  --background: #dce7f7;
  --padding-start: 10px;
  --padding-end: 10px;
  border-radius: 8px;
}
ion-button.ion-addsec{
      margin-bottom: 20px !important;
    margin-top: 20px !important;
    margin: 0 auto;
    display: block;
    width: 250px;
    color: #ffff00;
    font-size: 18px;
    font-family: 'Open Sans';
    font-weight: 700;
    
}
ion-button.ion-addsec::part(native){
  background: #05044D;
}

ion-select{
  width: 54vh;
    font-size: 16px;
    color: #19191a;
    font-weight: 400;
    margin-top: 1px;
    border: 1px solid gray;
    border-radius: 0px;
}
.empty-footer {
  min-height: 10px;
}
ion-card.year{
        margin: 55px auto !important;
}
.main-content select {
  width: 100%;
  padding: 10px 5px;
  border: 0;
  background: #d4dce9;
  color: #000;
}
</style>
