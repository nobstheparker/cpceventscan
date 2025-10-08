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
                    <li><router-link to="/account-center" class="sidebar-link">Account Center</router-link></li>
                    <li>
                        <router-link to="/adminLogIn" class="sidebar-link" @click="confirmLogout">
                        Log Out
                    </router-link>
                    </li>
                </ul>
            </div>
            <div class="main-content">
              <div class="form-wrapper">
                <ion-card>
                  <ion-card-header>
                    <ion-card-title class="reg-title">Student Registration</ion-card-title>
                  </ion-card-header>

                  <ion-card-content>
                    <ion-grid>
                      <ion-row>
                        <ion-col size="12">
                          <div class="form-row">
                            <label style="margin-top: 5px;">Student ID</label>
                            <ion-input
                              type="text"
                              v-model="studentId"
                              inputmode="numeric"
                              pattern="[0-9]*"
                              required
                              @input="onNumberInput"
                            ></ion-input>
                          </div>
                        </ion-col>
                      </ion-row>

                      <ion-row>
                        <ion-col size="6">
                          <div class="form-row">
                            <label>Last Name</label>
                            <ion-input v-model="lastName" required></ion-input>
                          </div>
                        </ion-col>
                        <ion-col size="6">
                          <div class="form-row">
                            <label>First Name</label>
                            <ion-input v-model="firstName" required></ion-input>
                          </div>
                        </ion-col>
                      </ion-row>

                      <ion-row>
                        <ion-col size="6">
                          <div class="form-row">
                            <label>Middle Name</label>
                            <ion-input v-model="middleName"></ion-input>
                          </div>
                        </ion-col>
                        <ion-col size="6" class="birthday-wrapper">
                          <label class="form-label">Birthday</label>
                          <input
                            type="date"
                            class="birthday-input"
                            v-model="birthday"
                          />
                        </ion-col>
                      </ion-row>

                      <ion-row>
                        <ion-col size="12">
                          <div class="sex-selector">
                            <label>Sex</label>
                            <select v-model="sex" placeholder="Select Sex Orientation" required>
                              <option disabled selected hidden value="">Select Sex Orientation</option>
                              <option value="Male">Male</option>
                              <option value="Female">Female</option>
                              <option value="Other">Other</option>
                            </select>
                          </div>
                        </ion-col>
                      </ion-row>

                      <ion-row>
                        <ion-col size="4">
                           <div class="form-row">
                            <label>Course</label>
                            <select v-model="selectedCourseId" required>
                              <option disabled value="">Select Course</option>
                              <option v-for="course in courses" :key="course.course_id" :value="course.course_id">
                                {{ course.course_code }}
                              </option>
                            </select>
                          </div>
                        </ion-col>
                        <ion-col size="4">
                          <div class="form-row">
                            <label>Year Level</label>
                            <select v-model="selectedYearId" required>
                              <option disabled value="">Select Year Level</option>
                              <option v-for="year in yearLevels" :key="year.YearID" :value="year.YearID">
                                {{ year.YearLvl }}
                              </option>
                            </select>
                          </div>
                        </ion-col>
                        <ion-col size="4">
                          <div class="form-row">
                            <label>Section</label>
                            <select v-model="selectedsectionID" required>
                              <option disabled value="">Select Section</option>
                              <option v-for="sectionlist in sections" :key="sectionlist.section_id" :value="sectionlist.section_id">
                                {{ sectionlist.section_name }}
                              </option>
                            </select>
                          </div>
                        </ion-col>
                      </ion-row>

                      <ion-row>
                        <ion-col size="12">
                          <div class="form-row-con">
                            <label>Email</label>
                            <ion-input type="email" v-model="email" required></ion-input>
                          </div>
                        </ion-col>
                      </ion-row>

                      <ion-row>
                        <ion-col size="12">
                          <div class="form-row-con">
                            <label>Password</label>
                            <ion-input type="password" v-model="password" required></ion-input>
                          </div>
                        </ion-col>
                      </ion-row>

                      <ion-row>
                        <ion-col size="12">
                          <ion-button expand="block" class="ion-margin-top" @click="handleRegister">
                            Register
                          </ion-button>
                        </ion-col>
                      </ion-row>
                    </ion-grid>
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
  IonCard, IonCardContent, IonCardHeader, IonCardTitle,
  IonContent,
  IonDatetime,
  IonHeader,
  IonIcon,
  IonInput,
  IonPage,
  IonText,
  IonToolbar
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
const router = useRouter();
const lastName = ref('');
const firstName = ref('');
const middleName = ref('');
const sex = ref('');
const age = ref<number | ''>('');
const courses = ref('');
const selectedCourseId = ref('');
const yearLevels = ref([]);
const selectedYearId = ref('');
const yearLevel = ref('');
const selectedsectionID = ref('');
const sections = ref('');
const email = ref('');
const password = ref('');

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
const fetchYearSection = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/sections/list');
    sections.value = res.data.sections;
  } catch (err) {
    console.error('Failed to fetch year levels:', err);
  }
};
const handleRegister = async () => {
  try {
    const payload = {
      student_id: studentId.value,
      last_name: lastName.value,
      first_name: firstName.value,
      middle_name: middleName.value,
      birthday: birthday.value,
      sex: sex.value,
      age: age.value,
      courseId: selectedCourseId.value,
      yearLevelId: selectedYearId.value,
      sectionID: selectedsectionID.value,
      email: email.value,
      password: password.value,
    };

    const res = await axios.post('http://localhost:5000/api/students/register', payload);
    console.log('Success:', res.data);
    Swal.fire({
      title: 'Student Registered',
      text: 'This student has been successfully registered!',
      icon: 'success',
      confirmButtonText: 'OK',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    }).then((result) => {
      if (result.isConfirmed) {
        window.location.reload();
      }
    });
  } catch (error) {
    console.error(error);
    Swal.fire({
      title: 'Error',
      text: 'Failed to register student',
      icon: 'error',
      confirmButtonText: 'OK',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    }).then((result) => {
      if (result.isConfirmed) {
        window.location.reload();
      }
    });
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
    confirmButtonText: 'Yes, log me out!'
  });

  if (result.isConfirmed) {
    router.push('/login');
  }
};

const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);

const toggleStudentMenu = () => showStudentMenu.value = !showStudentMenu.value;
const toggleAcadMenu = () => showAcadMenu.value = !showAcadMenu.value;
const toggleEventMenu = () => showEventMenu.value = !showEventMenu.value;

const birthday = ref('')
const formattedBirthday = ref('')
const showCalendar = ref(false)

const toggleCalendar = () => {
  showCalendar.value = !showCalendar.value
}

const onDateSelected = (event) => {
  const value = event.detail.value
  birthday.value = value
  formattedBirthday.value = new Date(value).toLocaleDateString()
  showCalendar.value = false
}

const studentId = ref('');

function onNumberInput(event: Event) {
  const input = event.target as HTMLInputElement;
  input.value = input.value.replace(/\D/g, ''); // remove non-digits
  studentId.value = input.value;
}
onMounted(() => {
  fetchCourses();
  fetchYearLevels();
  fetchYearSection();
});
</script>

<style scoped>
.toolbar-container::part(backdrop) {
  background-color: #07055D !important;
}

.ad-background {
 --background: url(/public/img/admin-bg.png) no-repeat center center / cover;
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
  background: #fff;
  border: 1px solid gray;
  padding: 8px;
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
.toolbar-icons {
  display: flex;
  align-items: center;
}
.birthday-input {
  padding: 9.5px;
  width: 100%;
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
.reg-title{
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
  display: flex;
  flex-direction: column;
}

.form-row.double {
  flex-direction: row;
  gap: 16px;
  margin-bottom: 10px;
}
.form-row.double ion-input{
  width: 59.1vh;
}
.form-row-acad ion-select{
    width: 38svh;
    border: 1px solid gray;
    border-radius: 0px;
    margin-bottom: 15px;
}

label {
    margin-bottom: 6px;
    color: #343333;
    margin-top: 0;
    font-weight: 600;
    font-size: 16px;
    display: block;
}

.form-row-con ion-input{
  margin-bottom: 10px;
}
ion-input{
  background: #fff;
  border: 1px #8d8e95 solid;
  margin: 0 auto;
  color: #19191a;
  font-size: 15px;
  font-weight: 600;
  padding: 0 6px !important;
}

ion-card-header{
 background-color: #07055D;
}
ion-card-content{
  background-color: #c8cbd9;
  padding: 0 20px;
}
ion-card{
  background: #b3b3b3 !important;
}
.reg-footer{
   background-color: #07055D;
   margin-top: 10px;
}
ion-select,
ion-datetime-button {
  --background: #dce7f7;
  --padding-start: 10px;
  --padding-end: 10px;
  border-radius: 8px;
}
ion-button.ion-margin-top{
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
ion-button.ion-margin-top::part(native){
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

.double select {
    padding: 11px 12px;
    border: 1px solid gray;
    border-radius: 1px;
    background-color: #d4dce9;
    font-size: 14px;
    color: black;
}
select {
    padding: 11px 12px;
    border: 1px solid gray;
    border-radius: 1px;
    background-color: #fff;
    font-size: 14px;
    color: black;
    width: 100%;
}
</style>
