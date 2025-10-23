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
          <div class="event-overviews">
                <table class="event-table">
                    <thead>
                    <tr>
                        <th>Total Events</th>
                        <th>Upcoming</th>
                        <th>Ongoing</th>
                        <th>Completed</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>{{ totalEvents }}</td>
                        <td>{{ upcomingEvents }}</td>
                        <td>{{ ongoingEvents }}</td>
                        <td>{{ completedEvents }}</td>
                    </tr>
                    </tbody>
                </table>
            </div>
          <h4>EVENT LIST</h4>
          <div style="--background: transparent;">
            <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
              <ion-col size="7">
              </ion-col>
              <ion-col size="5">
                <ion-searchbar
                  v-model="searchQuery"
                  class="white-searchbar"
                  placeholder="Search..."
                  animated
                />
              </ion-col>
            </ion-row>

            <div style="overflow-x: auto;">
              <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
                <thead>
                  <tr>
                    <th style="cursor:pointer;" @click="sortData('eventName')">
                      Event Name
                      <span v-if="sortColumn === 'eventName'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('eventDate')">
                      Date
                      <span v-if="sortColumn === 'eventDate'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('eventLocation')">
                      Location
                      <span v-if="sortColumn === 'eventLocation'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('qrstats')">
                      QR Code Status
                      <span v-if="sortColumn === 'qrstats'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('eventStats')">
                      Event Status 
                      <span v-if="sortColumn === 'eventStats'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="width: 150px; text-align: center;">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="event in paginatedEvents" :key="event.eventID">
                    <td>{{ event.eventName }}</td>
                   <td>
                      <time :datetime="event.eventDate">{{ new Date(event.eventDate).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' }) }}</time>
                    </td>
                    <td>{{ event.eventLocation }}</td>
                    <td>
                      {{ event.qrstats }}
                    </td>
                    <td :class="{
                        'green-text': event.eventStats === 'Completed',
                        'blue-text': event.eventStats === 'Upcoming',
                        'orange-text': event.eventStats !== 'Completed' && event.eventStats !== 'Upcoming'
                      }">
                      {{ event.eventStats }}</td>
                    <td class="action-btn">
                      <ion-button size="small" fill="solid" style="--background: #F1C204;--color: black; --border-radius: 3px; font-weight: 600;" expand="block" @click="openEditModal(event)">Edit</ion-button>
                      <ion-button size="small" fill="solid"
                        style="--background: #970303; --color: white; --border-radius: 3px; font-weight: 600;"
                        expand="block"
                        @click="deleteEvent(event.eventID)"
                      >
                        Delete
                      </ion-button>
                      <ion-button
                        size="small"
                        fill="solid"
                        style="--background:#30e707;--color:black;--border-radius:3px;font-weight:600;width:205px;"
                        expand="block"
                        @click="downloadQR(event.qrCodeImage, event.eventID)"
                      >
                        Download QR
                      </ion-button>
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
        </div>
        <ion-modal :is-open="isModalOpen" @didDismiss="closeModal">
          <ion-content>
            <div class="form-wrapper">
              <ion-card>
                <ion-card-header>
                  <ion-card-title style="    --color: white; font-weight: 700; text-align: center;" class="reg-title">Edit Event</ion-card-title>
                  <button type="button" class="btn-close" @click="closeModal" aria-label="Close"></button>
                </ion-card-header>

                <ion-card-content>
                  <div class="form-row">
                    <label>Event Name</label>
                    <ion-input v-model="modalEvent.eventName" />
                  </div>

                  <div class="form-row-text">
                    <label>Event Description</label>
                    <ion-textarea v-model="modalEvent.eventDesc" />
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
                        :value="startDateTime"
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
                          :value="endDateTime"
                          @ionChange="updateEndFormatted"
                        ></ion-datetime>
                      </ion-modal>
                    </div>
                  </div>
                  <!-- Location Search -->
                  <div class="form-row">
                    <label>Event Location (Leaflet Search)</label>
                    <ion-input v-model="modalEvent.searchQuery" :value="modalEvent.searchQuery" @input="debouncedSearch"></ion-input>
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

                  <!-- Participants -->
                  <div class="form-row double">
                    <div>
                      <label class="form-label">Event Participants</label>
                      <div class="radio-group ">
                        <label><input type="radio" value="all" v-model="modalEvent.selectionMode" /> All Students</label>
                        <label><input type="radio" value="byCourse" v-model="modalEvent.selectionMode" /> By Course</label>
                        <label><input type="radio" value="manual" v-model="modalEvent.selectionMode" /> Manual Selection</label>
                      </div>

                      <!-- Course Selection -->
                      <div v-if="modalEvent.selectionMode === 'byCourse'">
                        <label>Select Course:</label>
                        <select v-model="modalEvent.selectedCourse">
                          <option value="BSIT">BSIT</option>
                          <option value="BSED">BSED</option>
                          <option value="BSHM">BSHM</option>
                        </select>
                      </div>
                    </div>
                  </div>

                  <!-- Program Attachment -->
                  <div class="form-row">
                    <label>Event Program Attachment</label>

                    <div style="display: flex; align-items: center; gap: 150px; margin-top:5px;">
                      <div
                        @click="() => { selectedOption = 'upload'; triggerFileInput(); }"
                        style="display: flex; align-items: center; cursor: pointer;"
                      >
                        <ion-radio
                          :checked="selectedOption === 'upload'"
                          value="upload"
                          style="--background: transparent;"
                          class="file"
                        ></ion-radio>
                        <ion-label style="margin-left: 5px; color:#343333; font-weight: 600;">
                          Upload File
                        </ion-label>
                        <span v-if="modalEvent.fileName && modalEvent.fileName !== 'N/A'" style="margin-left: 10px;">
                          📎 {{ modalEvent.fileName }}
                        </span>
                      </div>

                      <div
                        @click="selectedOption = 'na'; modalEvent.fileName = 'N/A';"
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

                    <!-- Hidden input for file upload -->
                    <input
                      ref="fileInput"
                      type="file"
                      style="display: none"
                      @change="handleFileChange"
                    />
                  </div>
                  <!-- Note -->
                  <div class="form-row-acad">
                    <label>Note</label>
                    <ion-textarea v-model="modalEvent.eventNote" :value="modalEvent.eventNote"></ion-textarea>
                  </div>

                  <!-- Reminder -->
                  <div class="form-row-acad">
                    <label>Reminder</label>
                    <ion-textarea v-model="modalEvent.eventReminder" :value="modalEvent.eventReminder"></ion-textarea>
                  </div>
                <div class="form-row-con">
                  <label>Call To Action Buttons Instruction</label>
                  <ion-input v-model="modalEvent.ctabtn" :value="modalEvent.ctabtn"></ion-input>

                  <div style="display: flex; align-items: center; gap: 150px; margin-top: 10px; margin-bottom: 15px; color: rgb(31, 30, 35); font-weight: 500;">
                    <div style="display: flex; align-items: center;">
                      <ion-checkbox v-model="modalEvent.volunteerApplication"></ion-checkbox>
                      <ion-label style="margin-left: 6px;">Volunteer Application</ion-label>
                    </div>

                    <div style="display: flex; align-items: center;">
                      <ion-checkbox v-model="modalEvent.absenceRequest"></ion-checkbox>
                      <ion-label style="margin-left: 6px;">Absence Request</ion-label>
                    </div>
                  </div>
                </div>

                  <!-- QR Code Option -->
                  <div class="form-row-con">
                    <label>QR Code Generation</label>
                    <select v-model="modalEvent.qrCode">
                      <option value="automatic">Automatic Generation</option>
                      <option value="no_qr">No QR</option>
                    </select>
                  </div>

                  <!-- Save Button -->
                  <div class="modal-footer">
                    <ion-button expand="block" class="ion-margin-top" @click="updateEvent">
                      Save Changes
                    </ion-button>
                  </div>
                </ion-card-content>
              </ion-card>
            </div>
          </ion-content>
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
  IonPage,
  IonRow,
  IonSearchbar,
  IonText,
  IonDatetime,
  IonDatetimeButton,
  IonCheckbox,
  IonInput,
  IonToolbar,
  IonModal,
  IonTextarea,
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();
const events = ref<EventData[]>([]);
const isModalOpen = ref(false);
const fileInput = ref<HTMLInputElement | null>(null);

interface EventData {
  eventID: number;
  eventName: string;
  eventDate: string;
  eventLocation: string;
  qrstats: string;
  eventStats: string;
  eventDesc?: string;
  startDateTime?: string;
  endDateTime?: string;
  searchQuery?: string;
  selectionMode?: string;
  selectedCourse?: string;
  selectedStudents?: any[];
  fileName?: string;
  eventNote?: string;
  eventReminder?: string;
  ctabtn?: string;
  qrCode?: string;
  volunteerApplication?: boolean;
  absenceRequest?: boolean;
  attendanceControls?: boolean;
  customNotification?: boolean;
  midEventCheck?: boolean;
  eventProgramBase64?: string; // <-- add this for base64 content
}



const modalEvent = ref<EventData>({
  eventID: 0,
  eventName: '',
  eventDate: '',
  eventLocation: '',
  qrstats: '',
  eventStats: '',
  eventDesc: '',
  startDateTime: '',
  endDateTime: '',
  searchQuery: '',
  selectionMode: '',
  selectedCourse: '',
  selectedStudents: [],
  fileName: '',
  eventNote: '',
  eventReminder: '',
  ctabtn: '',
  qrCode: '',
  volunteerApplication: false,
  absenceRequest: false,
  attendanceControls: false,
  customNotification: false,
  midEventCheck: false,
  eventProgramBase64: '', // Initialize empty
});

const selectedOption = ref<'upload' | 'na'>('upload');

const startDateTime = ref('');
const endDateTime = ref('');
const formattedStartDateTime = ref('');
const formattedEndDateTime = ref('');
const event_location = ref('');

const formatDateTime = (dateTime: string) => {
  const date = new Date(dateTime);
  return date.toLocaleString('en-US', {
    month: 'long',
    day: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};

const updateStartFormatted = () => {
  formattedStartDateTime.value = formatDateTime(startDateTime.value);
  modalEvent.value.startDateTime = startDateTime.value; // ✅ Save what user picked
};

const updateEndFormatted = () => {
  formattedEndDateTime.value = formatDateTime(endDateTime.value);
  modalEvent.value.endDateTime = endDateTime.value; // ✅ Save what user picked
};
const handleFileChange = async (event: Event) => {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];
  if (file) {
    modalEvent.value.fileName = file.name;
    selectedOption.value = 'upload';

    try {
      modalEvent.value.eventProgramBase64 = await getBase64(file) as string;
    } catch (error) {
      console.error('File to Base64 conversion failed:', error);
      modalEvent.value.eventProgramBase64 = '';
    }
  }
};

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
  event_location.value = loc.display_name;
}

const triggerFileInput = () => {
  fileInput.value?.click();
};

function getBase64(file: File) {
  return new Promise<string>((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => {
      if (typeof reader.result === 'string') {
        resolve(reader.result);
      } else {
        reject('FileReader result not string');
      }
    };
    reader.onerror = error => reject(error);
  });
}

const openEditModal = (event: EventData) => {
  const fullEvent = events.value.find((e) => e.eventID === event.eventID);

  if (fullEvent) {
    modalEvent.value = {
      ...fullEvent,
      volunteerApplication: fullEvent.volunteerApplication === 1 || fullEvent.volunteerApplication === true,
      absenceRequest: fullEvent.absenceRequest === 1 || fullEvent.absenceRequest === true,
      attendanceControls: fullEvent.attendanceControls === 1 || fullEvent.attendanceControls === true,
      customNotification: fullEvent.customNotification === 1 || fullEvent.customNotification === true,
      midEventCheck: fullEvent.midEventCheck === 1 || fullEvent.midEventCheck === true,
      eventProgramBase64: '', // reset file base64 on open
    };

    startDateTime.value = fullEvent.startDateTime ?? '';
    endDateTime.value = fullEvent.endDateTime ?? '';
    formattedStartDateTime.value = formatDateTime(fullEvent.startDateTime ?? '');
    formattedEndDateTime.value = formatDateTime(fullEvent.endDateTime ?? '');

    selectedOption.value = !fullEvent.fileName || fullEvent.fileName === 'N/A' ? 'na' : 'upload';

    isModalOpen.value = true;
  } else {
    Swal.fire('Error', 'Event details not found.', 'error');
  }
};
const closeModal = () => {
  isModalOpen.value = false;
};
const updateEvent = async () => {
  try {
    await axios.put(
      `http://localhost:5000/api/events/update/${modalEvent.value.eventID}`,
      {
        event_name: modalEvent.value.eventName,
        start_date_time: modalEvent.value.startDateTime,
        end_date_time: modalEvent.value.endDateTime,
        event_location: modalEvent.value.searchQuery,
        event_description: modalEvent.value.eventDesc,
        selection_mode: modalEvent.value.selectionMode,
        selected_course: modalEvent.value.selectedCourse,
        selected_students: JSON.stringify(modalEvent.value.selectedStudents),
        event_program_attachment: modalEvent.value.fileName,
        event_program_file_base64: modalEvent.value.eventProgramBase64,  // <-- send base64 here
        event_note: modalEvent.value.eventNote,
        event_reminder: modalEvent.value.eventReminder,
        call_to_action_buttons_instruction: modalEvent.value.ctabtn,
        qr_code_option: modalEvent.value.qrCode,
        volunteer_application: modalEvent.value.volunteerApplication ? 1 : 0,
        absence_request: modalEvent.value.absenceRequest ? 1 : 0,
        attendance_controls: modalEvent.value.attendanceControls ? 1 : 0,
        custom_notification: modalEvent.value.customNotification ? 1 : 0,
        mid_event_check: modalEvent.value.midEventCheck ? 1 : 0,
      }
    );

    Swal.fire({
      icon: 'success',
      title: 'Success',
      text: 'Event updated successfully.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      },
    });

    fetchEvents();
    closeModal();
  } catch (error) {
    console.error('Update failed:', error);
    Swal.fire('Error', 'Failed to update the event.', 'error');
  }
};
const downloadQR = async (qrCodeUrl: string, eventID: number) => {
  try {
    const response = await fetch(qrCodeUrl);
    if (!response.ok) throw new Error('Network response was not ok');

    const blob = await response.blob();
    const url = URL.createObjectURL(blob);

    const link = document.createElement('a');
    link.href = url;
    link.download = `event-${eventID}-QR.png`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    URL.revokeObjectURL(url);
  } catch (error) {
    console.error('QR download failed:', error);
    Swal.fire('Error', 'Failed to download QR code.', 'error');
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

const totalEvents = computed(() => events.value.length);
const upcomingEvents = computed(() => events.value.filter((event) => event.eventStats === 'Upcoming').length);
const ongoingEvents = computed(() => events.value.filter((event) => event.eventStats === 'Ongoing').length);
const completedEvents = computed(() => events.value.filter((event) => event.eventStats === 'Completed').length);

const sortColumn = ref('');
const sortOrder = ref<'asc' | 'desc'>('asc');
const searchQuery = ref('');
const currentPage = ref(1);
const itemsPerPage = 10;

const fetchEvents = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/events/list');
    events.value = response.data.map((event: any) => ({
      eventID: event.id,
      eventName: event.event_name,
      eventDate: event.start_date_time,
      eventLocation: event.event_location,
      qrstats: event.qr_code_option == 'automatic' ? 'Generated' : 'No QR',
      eventStats: determineEventStatus(event.start_date_time, event.end_date_time),
      eventDesc: event.event_description,
      startDateTime: event.start_date_time,
      endDateTime: event.end_date_time,
      selectionMode: event.selection_mode,
      selectedCourse: event.selected_course,
      selectedStudents: event.selected_students ? JSON.parse(event.selected_students) : [],
      fileName: event.event_program_attachment,
      eventNote: event.event_note,
      eventReminder: event.event_reminder,
      ctabtn: event.call_to_action_buttons_instruction,
      qrCode: event.qr_code_option,
      volunteerApplication: event.volunteer_application === 1,
      absenceRequest: event.absence_request === 1,
      attendanceControls: event.attendance_controls === 1,
      customNotification: event.custom_notification === 1,
      midEventCheck: event.mid_event_check === 1,
      qrCodeImage: `http://localhost:5000/uploads/qr/event-${event.id}.png`,
      eventProgramBase64: '',
    }));
  } catch (error) {
    console.error('Failed to fetch events:', error);
  }
};


const determineEventStatus = (startDate: string, endDate: string) => {
  const now = new Date();
  const start = new Date(startDate);
  const end = new Date(endDate);

  if (now < start) return 'Upcoming';
  if (now >= start && now <= end) return 'Ongoing';
  return 'Completed';
};

const filteredData = computed(() => {
  let result = [...events.value];

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter((event) =>
      Object.values(event).some((value) =>
        String(value).toLowerCase().includes(query)
      )
    );
  }

  if (sortColumn.value) {
    const key = sortColumn.value as keyof EventData;
    result.sort((a, b) => {
      let aValue = a[key];
      let bValue = b[key];
      aValue = typeof aValue === 'string' ? aValue.toLowerCase() : aValue;
      bValue = typeof bValue === 'string' ? bValue.toLowerCase() : bValue;
      if (aValue < bValue) return sortOrder.value === 'asc' ? -1 : 1;
      if (aValue > bValue) return sortOrder.value === 'asc' ? 1 : -1;
      return 0;
    });
  }

  return result;
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

const totalPages = computed(() => Math.ceil(filteredData.value.length / itemsPerPage));
const paginatedEvents = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredData.value.slice(start, start + itemsPerPage);
});

const deleteEvent = async (eventId: number) => {
  const confirmDelete = await Swal.fire({
    title: 'Are you sure?',
    text: 'This event will be deleted permanently.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
    confirmButtonText: 'Yes, delete it!',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    },
  });

  if (confirmDelete.isConfirmed) {
    try {
      await axios.delete(`http://localhost:5000/api/events/delete/${eventId}`);
      events.value = events.value.filter((event) => event.eventID !== eventId);
      Swal.fire({
        icon: 'success',
        title: 'Deleted',
        text: 'Event has been deleted.',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        },
      });
    } catch (error) {
      console.error('Delete failed:', error);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Failed to delete the event.',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        },
      });
    }
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
  fetchEvents();
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
.event-overviews h3{
    font-size: 26px;
    margin-top: 0px !important;
    font-weight: 700;
    text-align: center;
    margin-bottom: 10px;
    margin-top: 10px;
}
h4{
    font-size: 26px;
    margin-top: 20px;
    margin-bottom: 0px !important;
    font-weight: 700;
    text-align: center;
}

.event-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 18px;
}

.event-table th,
.event-table td {
  text-align: center;
  padding: 12px;
  border: 1px solid #ccc;
  font-weight: 900;
  font-size: 20px;
}

.event-table th {
  background-color: #07055D;
  color: #fffa00;
  font-weight: bold;
  text-transform: uppercase;
}
.event-table tbody{
    color: #19191a;
    background: #d4dce9;
}
.event-table td{
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
  border-bottom: 0 !important; 
  border: 1px solid #07055d;
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
.action-btn{
  display: flex !important;
  width: auto !important;
  text-align: center;
}
.action-btn ion-button {
  width: 100px;
  display: inline-table;
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
  margin: 0 !important;
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
    gap: 80px;
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
.green-text {
  color: green;
  font-weight: 700;
}
.orange-text {
  color: orange;
  font-weight: 700;
}
.blue-text {
  color: #07055d;
  font-weight: 700;
}

</style>
