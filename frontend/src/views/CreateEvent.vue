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
          <div class="form-wrapper">
            <ion-card>
              <ion-card-header>
                <ion-card-title class="reg-title">Create Event</ion-card-title>
              </ion-card-header>

              <ion-card-content>
                <div class="form-row">
                  <label>Event Name</label>
                  <ion-input v-model="eventName" required></ion-input>
                </div>

                <div class="form-row-text">
                  <label>Event Description</label>
                  <ion-textarea auto-grow="true"  v-model="eventDesc" required></ion-textarea>
                </div>

                <div class="form-row">
                  <label class="form-label">Event Start Date & Time</label>
                  <div class="input-wrapper" style="position: relative;">
                    <ion-input
                      :value="formattedStartDateTime"
                      readonly
                      placeholder="Select Start Date & Time"
                      class="input-with-button"
                    ></ion-input>

                    <ion-datetime-button
                      datetime="start-datetime"
                      class="inside-input-btn"
                      style="position: absolute; top: 50%; right: 10px; transform: translateY(-50%);"
                    ></ion-datetime-button>

                    <ion-modal :keep-contents-mounted="true">
                      <ion-datetime
                        id="start-datetime"
                        presentation="date-time"
                        v-model="startDateTime"
                        :format-options="formatOptions"
                        @ionChange="updateStartFormatted"
                      ></ion-datetime>
                    </ion-modal>
                  </div>
                </div>

                <div class="form-row">
                  <label class="form-label">Event End Date & Time</label>
                  <div class="input-wrapper" style="position: relative;">
                    <ion-input
                      :value="formattedEndDateTime"
                      readonly
                      placeholder="Select End Date & Time"
                      class="input-with-button"
                    ></ion-input>

                    <ion-datetime-button
                      datetime="end-datetime"
                      class="inside-input-btn"
                      style="position: absolute; top: 50%; right: 10px; transform: translateY(-50%);"
                    ></ion-datetime-button>

                    <ion-modal :keep-contents-mounted="true">
                      <ion-datetime
                        id="end-datetime"
                        presentation="date-time"
                        v-model="endDateTime"
                        :format-options="formatOptions"
                        @ionChange="updateEndFormatted"
                      ></ion-datetime>
                    </ion-modal>
                  </div>
                </div>

                <!-- LOCATION SEARCH AUTOCOMPLETE -->
                <div class="form-row">
                  <label>Event Location (Leaflet Search)</label>
                  <div style="position: relative;">
                    <ion-input
                      v-model="searchQuery"
                      placeholder="Search event location"
                      @input="debouncedSearch"
                      clear-input
                    ></ion-input>

                    <ul
                      v-if="locationResults.length"
                      style="position: absolute; top: 100%; left: 0; right: 0; background: white; max-height: 150px; overflow-y: auto; border: 1px solid #ccc; z-index: 1000; margin: 0; padding: 0; list-style: none;"
                    >
                      <li
                        v-for="(loc, index) in locationResults"
                        :key="index"
                        @click="selectLocation(loc)"
                        style="padding: 8px; cursor: pointer;"
                        @mouseover="hoverIndex = index"
                        @mouseleave="hoverIndex = null"
                        :style="{ backgroundColor: hoverIndex === index ? '#eee' : 'transparent' }"
                      >
                        {{ loc.display_name }}
                      </li>
                    </ul>
                  </div>
                </div>
                <div class="form-row double">
                  <div>
                    <label class="form-label">Event Participants</label>

                    <div class="radio-group">
                      <label><input type="radio" value="all" v-model="selectionMode" /> All Students</label>
                      <label><input type="radio" value="byCourse" v-model="selectionMode" /> By Course</label>
                      <label><input type="radio" value="manual" v-model="selectionMode" /> Manual Selection</label>
                    </div>

                    <div v-if="selectionMode === 'byCourse'" class="dropdown-section">
                      <label>Select Course:</label>
                      <select v-model="selectedCourse">
                        <option disabled value="Select A Course">Select a course</option>
                        <option value="BSIT">BSIT</option>
                        <option value="BSED">BSED</option>
                        <option value="BSHM">BSHM</option>
                      </select>
                    </div>

                    <div v-if="selectionMode === 'manual'" class="manual-selection">
                      <label>Manual Selection:</label>

                      <div class="select-wrapper">
                        <input
                          type="text"
                          :value="selectedStudentNames"
                          readonly
                          placeholder="Select students..."
                        />
                        <button class="select-btn" @click="showStudentDropdown = !showStudentDropdown">
                          Select
                        </button>
                      </div>

                      <div v-if="showStudentDropdown" class="dropdown-box">
                        <div class="dropdown-header">
                          <div class="left">
                            <label>
                              <input type="checkbox" v-model="selectAll" @change="toggleAllStudents" /> Select All
                            </label>
                          </div>
                          <div class="right">
                            <input type="text" placeholder="Search..." v-model="searchQueryStudents" />
                          </div>
                        </div>

                        <div class="student-list">
                          <label v-for="student in filteredStudents" :key="student.id">
                            <input type="checkbox" :value="student.id" v-model="selectedStudents" />
                            {{ student.name }}
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="form-row">
                  <label>Event Program Attachment</label>

                  <div style="display: flex; align-items: center; gap: 150px; margin-top:5px;">

                    <div
                      @click="selectUploadOption"
                      style="display: flex; align-items: center; cursor: pointer;"
                    >
                      <ion-radio
                        :checked="selectedOption === 'upload'"
                        value="upload"
                        style="--background: transparent;"
                        class="file"
                      ></ion-radio>
                      <ion-label style="margin-left: 5px; color:#343333; font-weight: 600;">Upload File</ion-label>
                      <span v-if="fileName" style="margin-left: 10px;">📎 {{ fileName }}</span>
                    </div>

                    <div
                      @click="selectNAOption"
                      style="display: flex; align-items: center; cursor: pointer; color:#343333; font-weight: 600;"
                    >
                      <ion-radio
                        :checked="selectedOption === 'na'"
                        value="na"
                        style="--background: transparent;"
                      ></ion-radio>
                      <ion-label style="margin-left: 5px;">N/A</ion-label>
                    </div>
                  </div>

                  <input
                    ref="fileInput"
                    type="file"
                    style="display: none"
                    @change="handleFileChange"
                  />
                </div>

                <div class="form-row-acad">
                  <div>
                    <label>Note</label>
                    <ion-textarea auto-grow="true" v-model="eventNote" required></ion-textarea>
                  </div>
                </div>
                <div class="form-row-acad">
                  <div>
                    <label>Reminder</label>
                    <ion-textarea auto-grow="true" v-model="eventReminder" required></ion-textarea>
                  </div>
                </div>

                <div class="form-row-con">
                  <label>Call To Action Buttons Instruction</label>
                  <ion-input v-model="ctabtn" required></ion-input>

                  <div style="display: flex; align-items: center; gap: 150px; margin-top: 10px; margin-bottom: 15px;color: rgb(31, 30, 35);font-weight: 500;">
                    <div style="display: flex; align-items: center;">
                      <ion-checkbox v-model="volunteerApplication"></ion-checkbox>
                      <ion-label style="margin-left: 6px;">Volunteer Application</ion-label>
                    </div>

                    <div style="display: flex; align-items: center;">
                      <ion-checkbox v-model="absenceRequest"></ion-checkbox>
                      <ion-label style="margin-left: 6px;">Absence Request</ion-label>
                    </div>
                  </div>
                </div>

                <div class="form-row-con">
                  <label>QR Code Generation</label>
                  <select v-model="qrCode" class="native-select" placeholder="Select QR Option" style="color: #343333;" required>
                    <option disabled value="">Select QR Option</option>
                    <option value="automatic">Automatic Generation</option>
                    <option value="no_qr">No QR</option>
                  </select>
                </div>

                <ion-button expand="block" class="ion-margin-top" @click="handleRegister">
                  Create
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
  IonCheckbox,
  IonContent,
  IonDatetime,
  IonDatetimeButton,
  IonHeader,
  IonIcon,
  IonInput,
  IonLabel,
  IonModal,
  IonPage,
  IonRadio,
  IonText,
  IonTextarea,
  IonToolbar
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { computed, ref, watch, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();

// --- Logout Confirmation ---
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

// --- Sidebar Menus ---
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

// --- Event Form Fields ---
const eventName = ref('');
const eventDesc = ref('');
const eventLoc = ref('');
const eventNote = ref('');
const eventReminder = ref('');
const ctabtn = ref('');
const volunteerApplication = ref(false);
const absenceRequest = ref(false);
const attendanceControls = ref(false);
const customNotification = ref(false);
const midEventCheck = ref(false);
const selectionMode = ref('');
const selectedCourse = ref('');
const searchQueryStudents = ref('');
const selectedStudents = ref<number[]>([]);
const showStudentDropdown = ref(false);
const selectAll = ref(false);
const qrCode = ref('');

// --- Student List ---
const students = [
  { id: 1, name: 'Anna Cruz' },
  { id: 2, name: 'Brian Santos' },
  { id: 3, name: 'Carla Reyes' },
  { id: 4, name: 'David Flores' },
  { id: 5, name: 'Ella Garcia' }
];

const filteredStudents = computed(() =>
  students.filter((s) => s.name.toLowerCase().includes(searchQueryStudents.value.toLowerCase()))
);

const toggleAllStudents = () => {
  if (selectAll.value) {
    selectedStudents.value = filteredStudents.value.map((s) => s.id);
  } else {
    selectedStudents.value = [];
  }
};

watch(filteredStudents, () => {
  if (!selectAll.value) return;
  selectedStudents.value = filteredStudents.value.map((s) => s.id);
});

const selectedStudentNames = computed(() => {
  const selected = students.filter((s) => selectedStudents.value.includes(s.id));
  if (selected.length === 0) return '';
  const names = selected.map((s) => s.name);
  return names.length > 2 ? `${names.slice(0, 2).join(', ')} +${names.length - 2} more` : names.join(', ');
});

// --- File Upload ---
const selectedOption = ref('');
const fileName = ref('');
const fileInput = ref<HTMLInputElement | null>(null);
const eventDataFileBase64 = ref<string | null>(null);

const selectUploadOption = () => {
  selectedOption.value = 'upload';
  fileInput.value?.click();
};

const selectNAOption = () => {
  selectedOption.value = 'na';
  fileName.value = '';
  eventDataFileBase64.value = null;
};

const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  const file = target.files ? target.files[0] : null;
  if (file) {
    fileName.value = file.name;

    const reader = new FileReader();
    reader.onload = () => {
      eventDataFileBase64.value = reader.result as string;
    };
    reader.readAsDataURL(file);
  } else {
    fileName.value = '';
    eventDataFileBase64.value = null;
  }
};

// --- Datetime ---
const getCurrentISODateTime = (): string => new Date().toISOString().slice(0, 19);

const startDateTime = ref(getCurrentISODateTime());
const endDateTime = ref(getCurrentISODateTime());
const formattedStartDateTime = ref('');
const formattedEndDateTime = ref('');

const formatOptions = { weekday: 'short', year: 'numeric', month: 'long', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: true };

function formatDateTime(value: string) {
  if (!value) return '';
  const date = new Date(value);
  if (isNaN(date.getTime())) return '';
  return date.toLocaleString(undefined, formatOptions);
}

const updateStartFormatted = (event: CustomEvent) => {
  const val = event.detail.value;
  if (val) {
    startDateTime.value = val;
    formattedStartDateTime.value = formatDateTime(val);
  } else {
    formattedStartDateTime.value = '';
  }
};

const updateEndFormatted = (event: CustomEvent) => {
  const val = event.detail.value;
  if (val) {
    endDateTime.value = val;
    formattedEndDateTime.value = formatDateTime(val);
  } else {
    formattedEndDateTime.value = '';
  }
};

formattedStartDateTime.value = formatDateTime(startDateTime.value);
formattedEndDateTime.value = formatDateTime(endDateTime.value);

// --- Location Search ---
const searchQuery = ref('');
const locationResults = ref<Array<{ display_name: string; lat: string; lon: string }>>([]);
const hoverIndex = ref<number | null>(null);
const selectedLocationLat = ref<string | null>(null);
const selectedLocationLon = ref<string | null>(null);

function simpleDebounce(func: () => void, wait = 300) {
  let timeout: number | undefined;
  return () => {
    clearTimeout(timeout);
    timeout = window.setTimeout(() => func(), wait);
  };
}

const fetchLocationResults = async () => {
  if (searchQuery.value.length < 3) {
    locationResults.value = [];
    return;
  }
  try {
    const response = await fetch(
      `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(searchQuery.value)}&addressdetails=1&limit=5`
    );
    const results = await response.json();
    locationResults.value = results;
  } catch (error) {
    console.error('Location search error:', error);
    locationResults.value = [];
  }
};

const debouncedSearch = simpleDebounce(fetchLocationResults, 300);

function selectLocation(loc: { display_name: string; lat: string; lon: string }) {
  searchQuery.value = loc.display_name;
  locationResults.value = [];
  selectedLocationLat.value = loc.lat;
  selectedLocationLon.value = loc.lon;
  eventLoc.value = loc.display_name;
}

// --- Register Event ---
const handleRegister = async () => {
  try {
    const eventData = {
      event_name: eventName.value,
      event_description: eventDesc.value,
      event_location: eventLoc.value,
      start_date_time: startDateTime.value,
      end_date_time: endDateTime.value,
      selection_mode: selectionMode.value,
      selected_course: selectedCourse.value || null,
      selected_students: selectedStudents.value.length > 0 ? selectedStudents.value : null,
      event_program_attachment_base64: eventDataFileBase64.value,
      event_note: eventNote.value || null,
      event_reminder: eventReminder.value || null,
      call_to_action_buttons_instruction: ctabtn.value || null,
      volunteer_application: volunteerApplication.value,
      absence_request: absenceRequest.value,
      attendance_controls: attendanceControls.value,
      custom_notification: customNotification.value,
      mid_event_check: midEventCheck.value,
      qr_code_option: qrCode.value || null,
      latitude: selectedLocationLat.value,
      longitude: selectedLocationLon.value
    };

    const response = await fetch('http://localhost:5000/api/events', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(eventData),
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || 'Unknown server error');
    }

    const data = await response.json();
    await Swal.fire({
      title: 'Event Created',
      text: 'Your event has been successfully created!',
      icon: 'success',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
      }
    });
    window.location.reload();
  } catch (error: any) {
    Swal.fire({
      title: 'Failed to create event',
      text: error.message,
      icon: 'error',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
      }
    });
  }
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
.native-select {
    width: 100%;
    padding: 10px 12px;
    font-size: 16px;
    border: 1px solid gray;
    background-color: #d4dce9;
    color: #333;
    font-weight: 600;
}
ion-select {
  --background: #f5f5f5;
  --padding-start: 12px;
  --padding-end: 12px;
  --padding-top: 10px;
  --padding-bottom: 10px;
  --border-radius: 6px;
  --border: 1px solid #ccc;
  --color: #000;
  width: 100%;
}
.form-row-perimeter {
  margin-top: 15px;
    color: #343333;
    font-weight: 600;
    font-size: 16px;

}

ion-select-option {
  --background: #ffffff;
  --color: #000;
}
ion-checkbox {
  --size: 20px;
  --border-width: 1px;
  --border-radius: 4px;

  --checkbox-background: lightgray;       
  --checkbox-border-color: gray;          
  --checkmark-color: white;            
  --checkbox-color: royalblue;           
}

.eventdate-box{
  font-size: 18px;
    background: #d4dce9;
    border: 1px solid gray;
    padding: 8px;
    width: 54vh;
    font-family: 'Open Sans' !important;
    color: #555 ;
}
.eventDate {
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
  margin-bottom: 10px;
  display: flex;
  flex-direction: column;
}
.form-row-text {
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
ion-textarea::part(textarea) {
  min-height: 40px;
  padding: 4px 10px;       /* Tighter and clean padding */
  font-size: 16px;
  line-height: 1.4;
  box-sizing: border-box;
  resize: none;            /* Optional: remove manual resize handle */
}
ion-textarea {
  --padding-top: 3px !important;
  --padding-bottom: 3px !important;
  --padding-start: 0;
  --padding-end: 0;
  width: 100%;
  margin-bottom: 15px !important;
}

.form-row label {
    margin-bottom: 6px;
    color: #343333;
    font-weight: 600;
    font-size: 16px;
}
.form-row-text label {
    margin-bottom: 6px;
    color: #343333;
    font-weight: 600;
    font-size: 16px;
}

.form-row-acad label{
  --margin-bottom: 10px !important;
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
  margin-bottom: 10px !important;
}
.form-row-con ion-select{
      background: #b3b3b3;
}

  ion-input{
  background: #d4dce9;
  border: 1px #8d8e95 solid;
  margin: 0 auto;
  padding-left: 1px !important;
  color: #19191a;
  font-size: 15px;
  font-weight: 600;
}
ion-textarea{
  background: #d4dce9;
  border: 1px #8d8e95 solid;
  margin: 0 auto;
  padding-left: 1px !important;
  color: #19191a;
  font-size: 15px;
  font-weight: 600;
  padding: 5px !important;
}

ion-card-header{
 background-color: #07055D;
 margin-bottom: 15px;
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
.form-row ion-textarea{
  --margin-bottom: 0 important;
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
      width: 123vh;
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
.form-group {
  margin-bottom: 16px;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-with-button {
  width: 100%;
  padding-right: 40px; /* space for the button */
}

.inside-input-btn {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 2;
  --background: transparent;
  --box-shadow: none;
  pointer-events: auto;
}
.radio-group {
    margin-top: 10px;
    gap: 120px;
    margin-bottom: 5px;
    display: flex;
}

.dropdown-section,
.manual-selection {
  margin-top: 5px;
}
.dropdown-section label{
    margin-right: 10px;
    font-size: 15px;
    font-weight: 600;
}
.dropdown-section select{
    padding: 5px;
    background: #edeff2;
    border: 1px solid gray;
}
.dropdown-section option{
    background: #d4dce9;
    border: 1px solid gray;
    color: #19191a;
}

.select-wrapper {
  display: flex;
  position: relative;
  margin-top: 0.5rem; 
}

.select-wrapper input {
  flex: 1;
  padding: 6px;
  background: #d4dce9;
  border: 1px solid gray;
}

.select-btn {
    padding: 5px 10px;
    margin-left: 8px;
    cursor: pointer;
    border-radius: 3px;
    background: #2c2c7a;
}

.dropdown-box {
  border: 1px solid #888;
  padding: 10px;
  margin-top: 8px;
  background: #d4dce9;;
}
.dropdown-header input{
    background: #fff;
    border: 1px solid gray;
    padding: 4px;
    border-radius: 5px;
    color: #19191a;
}

.dropdown-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.student-list {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
body.swal2-height-auto{
  height: 100% !important;
  overflow: visible !important;
}

</style>
