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

    <!-- Content -->
    <ion-content class="ad-background">
      <div class="content-wrapper">
        <!-- Sidebar -->
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

        <!-- Main Content -->
        <div class="main-content">
          <!-- Request Overview -->
          <div class="request-overviews">
            <h3>Students Request And Application Overview</h3>
            <table class="requestTable">
              <thead>
                <tr>
                  <th>TOTAL</th>
                  <th>APPROVED</th>
                  <th>REJECTED</th>
                  <th>PENDING</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>{{ totalReqs }}</td>
                  <td>{{ approvedReqs }}</td>
                  <td>{{ rejectedReqs }}</td>
                  <td>{{ pendingReqs }}</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Absence Requests Table -->
          <h2>Absence Requests</h2>
          <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
            <ion-col size="7">
            </ion-col>
            <ion-col size="5">
              <ion-searchbar
                :value="absenceSearch"
                @ionInput="onAbsenceSearch($event.detail.value)"
                placeholder="Search Absence Requests">
              </ion-searchbar>
            </ion-col>
          </ion-row>

          <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse;">
              <thead>
                <tr>
                  <th @click="sortTable('studNameName','absence')">Student Name {{ getSortIcon('studNameName','absence') }}</th>
                  <th @click="sortTable('eprogYearSec','absence')">Program, Yr. & Sec {{ getSortIcon('eprogYearSec','absence') }}</th>
                  <th>Type</th>
                  <th @click="sortTable('reqDate','absence')">Date Requested {{ getSortIcon('reqDate','absence') }}</th>
                  <th @click="sortTable('reqstats','absence')">Status {{ getSortIcon('reqstats','absence') }}</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="req in paginatedAbsenceRequests" :key="req.request_id">
                  <td>{{ req.first_name }} {{ req.middle_name }} {{ req.studNameName }}</td>
                  <td>{{ req.eprogYearSec }}</td>
                  <td>{{ req.reqType }}</td>
                  <td>{{ formatDate(req.reqDate) }}</td>
                  <td>{{ req.reqstats }}</td>
                  <td>
                    <ion-button size="small" style="--background:#e2cb0c;--color:black; font-weight: 600; margin: 0 auto !important; display: flex;" @click="openAbsenceModal(req)">View Details</ion-button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination for Absence -->
          <div class="pagination-container">
            <button :disabled="currentPage.absence === 1" @click="currentPage.absence--" class="pagination-button">&laquo; Prev</button>
            <button v-for="page in totalPagesAbsence" :key="page" @click="currentPage.absence = page" :class="['pagination-button',{active: currentPage.absence===page}]">{{ page }}</button>
            <button :disabled="currentPage.absence === totalPagesAbsence" @click="currentPage.absence++" class="pagination-button">Next &raquo;</button>
          </div>

          <!-- Volunteer Requests Table -->
          <h2>Volunteer Applications</h2>
          <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
            <ion-col size="7"></ion-col>
            <ion-col size="5">
              <ion-searchbar
                :value="volunteerSearch"
                @ionInput="onVolunteerSearch($event.detail.value)"
                placeholder="Search Volunteer Applications">
              </ion-searchbar>
            </ion-col>
          </ion-row>

          <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse;">
              <thead>
                <tr>
                  <th @click="sortTable('studNameName','volunteer')">Student Name {{ getSortIcon('studNameName','volunteer') }}</th>
                  <th @click="sortTable('eprogYearSec','volunteer')">Program, Yr. & Sec {{ getSortIcon('eprogYearSec','volunteer') }}</th>
                  <th>Type</th>
                  <th @click="sortTable('reqDate','volunteer')">Date Requested {{ getSortIcon('reqDate','volunteer') }}</th>
                  <th @click="sortTable('reqstats','volunteer')">Status {{ getSortIcon('reqstats','volunteer') }}</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="req in paginatedVolunteerRequests" :key="req.request_id">
                  <td>{{ req.first_name }} {{ req.middle_name }} {{ req.studNameName }}</td>
                  <td>{{ req.eprogYearSec }}</td>
                  <td>{{ req.reqType }}</td>
                  <td>{{ formatDate(req.reqDate) }}</td>
                  <td>{{ req.reqstats }}</td>
                  <td>
                    <ion-button size="small" style="--background:#e2cb0c;--color:black; font-weight: 600; margin: 0 auto !important; display: flex;" @click="openVolunteerModal(req)">View Details</ion-button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination for Volunteer -->
          <div class="pagination-container">
            <button :disabled="currentPage.volunteer === 1" @click="currentPage.volunteer--" class="pagination-button">&laquo; Prev</button>
            <button v-for="page in totalPagesVolunteer" :key="page" @click="currentPage.volunteer = page" :class="['pagination-button',{active: currentPage.volunteer===page}]">{{ page }}</button>
            <button :disabled="currentPage.volunteer === totalPagesVolunteer" @click="currentPage.volunteer++" class="pagination-button">Next &raquo;</button>
          </div>
        </div>
      </div>
    </ion-content>

    <div class="footer">
      <ion-text>
        <small>&copy; All Rights Reserved PPG 2025.</small>
      </ion-text>
    </div>

    <ion-modal :is-open="showAbsenceModal" @did-dismiss="showAbsenceModal=false">
      <ion-header>
        <ion-toolbar>
          <ion-title style="margin-left: 10px;">Absence Details</ion-title>
          <ion-buttons slot="end">
            <ion-button fill="clear" color="light" @click="showAbsenceModal = false" class="close-btn" >
              <ion-icon name="close"></ion-icon>
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content class="ion-padding" style="--padding-top: 0;">
        <div v-if="selectedAbsence">
          <p><strong>Request ID:</strong> {{ selectedAbsence.request_id }}</p>
          <p><strong>Name:</strong> {{ selectedAbsence.first_name }} {{ selectedAbsence.middle_name }} {{ selectedAbsence.studNameName }}</p>
          <p><strong>Program/Yr/Sec:</strong> {{ selectedAbsence.eprogYearSec }}</p>
          <p><strong>Type:</strong> {{ selectedAbsence.reqType }}</p>
          <p><strong>Date Requested:</strong> {{ formatDate(selectedAbsence.reqDate) }}</p>
          <p><strong>Reason:</strong> {{ selectedAbsence.reason }}</p>
          <p><strong>Documentation:</strong> 
            <a :href="`/uploads/${selectedAbsence.documentation}`" target="_blank">{{ selectedAbsence.documentation }}</a>
          </p>
          <p><strong>Submission Date:</strong> {{ formatDate(selectedAbsence.submission_date) }}</p>
          <p><strong>Parent Name:</strong> {{ selectedAbsence.parent_name }}</p>
          <p><strong>Contact Info:</strong> {{ selectedAbsence.contact_info }}</p>
          <p><strong>Agreement:</strong> {{ selectedAbsence.agreement ? 'Yes' : 'No' }}</p>
          <p><strong>Status:</strong> {{ selectedAbsence.reqstats }}</p>

          <div style="margin-top:20px; display:flex; gap:10px;">
            <ion-button color="success" @click="updateAbsenceStatus(selectedAbsence,'Approved')">Approve</ion-button>
            <ion-button color="danger" @click="updateAbsenceStatus(selectedAbsence,'Rejected')">Reject</ion-button>
          </div>
        </div>
      </ion-content>
    </ion-modal>

    <ion-modal :is-open="showVolunteerModal" @did-dismiss="showVolunteerModal=false">
      <ion-header>
        <ion-toolbar>
          <ion-title style="margin-left: 10px;">Volunteer Details</ion-title>
          <ion-buttons slot="end">
            <ion-button fill="clear" color="light" @click="showVolunteerModal = false" class="close-btn" >
              <ion-icon name="close"></ion-icon>
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content class="ion-padding" style="--padding-top: 0;" >
        <div v-if="selectedVolunteer">
          <p><strong>Request ID:</strong> {{ selectedVolunteer.request_id }}</p>
          <p><strong>Name:</strong> {{ selectedVolunteer.first_name }} {{ selectedVolunteer.middle_name }} {{ selectedVolunteer.studNameName }}</p>
          <p><strong>Program/Yr/Sec:</strong> {{ selectedVolunteer.eprogYearSec }}</p>
          <p><strong>Type:</strong> {{ selectedVolunteer.reqType }}</p>
          <p><strong>Date Requested:</strong> {{ formatDate(selectedVolunteer.reqDate) }}</p>
          <p><strong>Role:</strong> {{ selectedVolunteer.role }}</p>
          <p><strong>Motivation:</strong> {{ selectedVolunteer.motivation }} {{ selectedVolunteer.motivation_other }}</p>
          <p><strong>Volunteered Before:</strong> {{ selectedVolunteer.volunteered_before }}</p>
          <p><strong>Past Role:</strong> {{ selectedVolunteer.past_role }}</p>
          <p><strong>Skills:</strong> {{ selectedVolunteer.skills }} {{ selectedVolunteer.skills_other }}</p>
          <p><strong>Available:</strong> {{ selectedVolunteer.available }}</p>
          <p><strong>Team Preference:</strong> {{ selectedVolunteer.team_preference }} {{ selectedVolunteer.team_other }}</p>
          <p><strong>Agreement:</strong> {{ selectedVolunteer.agreement ? 'Yes':'No' }}</p>
          <p><strong>Status:</strong> {{ selectedVolunteer.reqstats }}</p>

          <div style="margin-top:20px; display:flex; gap:10px;">
            <ion-button color="success" @click="updateVolunteerStatus(selectedVolunteer,1)">Approve</ion-button>
            <ion-button color="danger" @click="updateVolunteerStatus(selectedVolunteer,2)">Reject</ion-button>
          </div>
        </div>
      </ion-content>
    </ion-modal>
  </ion-page>
</template>

<script setup lang="ts">
import {
  IonButton,
  IonContent,
  IonHeader,
  IonIcon,
  IonPage,
  IonText,
  IonToolbar,
  IonSearchbar
} from '@ionic/vue';
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { addIcons } from 'ionicons';
import { close, closeOutline } from 'ionicons/icons';

addIcons({
  'close': close,
  'close-outline': closeOutline
});


// ------------------------
// Router & logout
// ------------------------
const router = useRouter();
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

// ------------------------
// Sidebar toggles
// ------------------------
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => (showStudentMenu.value = !showStudentMenu.value);
const toggleAcadMenu = () => (showAcadMenu.value = !showAcadMenu.value);
const toggleEventMenu = () => (showEventMenu.value = !showEventMenu.value);

// ------------------------
// Requests data
// ------------------------
const requests = ref<any[]>([]);
const totalReqs = ref(0);
const approvedReqs = ref(0);
const rejectedReqs = ref(0);
const pendingReqs = ref(0);

// ------------------------
// Sorting, filtering, pagination
// ------------------------
const sortColumn = ref({ absence: '', volunteer: '' });
const sortOrder = ref({ absence: 'asc', volunteer: 'asc' });
const absenceSearch = ref('');
const volunteerSearch = ref('');
const absenceSortFilter = ref('');
const volunteerSortFilter = ref('');
const currentPage = ref({ absence: 1, volunteer: 1 });
const itemsPerPage = 10;

// ------------------------
// Status mapping
// ------------------------
const statusOrder = ['Pending', 'Approved', 'Rejected'];

// ------------------------
// Modals
// ------------------------
const showAbsenceModal = ref(false);
const showVolunteerModal = ref(false);
const selectedAbsence = ref<any>(null);
const selectedVolunteer = ref<any>(null);

const openAbsenceModal = (req: any) => {
  selectedAbsence.value = req;
  showAbsenceModal.value = true;
};
const openVolunteerModal = (req: any) => {
  selectedVolunteer.value = req;
  showVolunteerModal.value = true;
};
function closeModal() {
  showAbsenceModal.value = false;
}
// ------------------------
// Date formatting
// ------------------------
const formatDate = (dateString: string) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('en-US', { month: 'long', day: 'numeric', year: 'numeric' }).format(date);
};

// ------------------------
// Fetch data
// ------------------------
onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/admin/requests');
    requests.value = res.data.map((r) => ({
      ...r,
      reqstats: r.reqstats === 0 ? 'Pending' : r.reqstats === 1 ? 'Approved' : 'Rejected'
    }));
    updateCounts();
  } catch (e) {
    console.error(e);
  }
});

// ------------------------
// Update counts
// ------------------------
const updateCounts = () => {
  totalReqs.value = requests.value.length;
  approvedReqs.value = requests.value.filter((r) => r.reqstats === 'Approved').length;
  rejectedReqs.value = requests.value.filter((r) => r.reqstats === 'Rejected').length;
  pendingReqs.value = requests.value.filter((r) => r.reqstats === 'Pending').length;
};

// ------------------------
// Sorting
// ------------------------
function sortTable(column: string, table: 'absence' | 'volunteer') {
  if (sortColumn.value[table] === column) sortOrder.value[table] = sortOrder.value[table] === 'asc' ? 'desc' : 'asc';
  else {
    sortColumn.value[table] = column;
    sortOrder.value[table] = 'asc';
  }
}

function getSortIcon(column: string, table: 'absence' | 'volunteer') {
  return sortColumn.value[table] === column ? (sortOrder.value[table] === 'asc' ? '▲' : '▼') : '';
}

// ------------------------
// Computed filters
// ------------------------
const filteredAbsenceRequests = computed(() => {
  let data = requests.value.filter((r) =>
    r.reqType.toLowerCase().includes("absence")
  );

  if (absenceSearch.value.trim()) {
    const keyword = absenceSearch.value.toLowerCase();
    data = data.filter((r) =>
      [
        r.first_name,
        r.middle_name,
        r.studNameName,
        r.eprogYearSec,
        r.reqType,
        r.reqstats,
      ]
        .filter(Boolean)
        .some((val) => val.toLowerCase().includes(keyword))
    );
  }

  if (absenceSortFilter.value)
    data = data.filter((r) => r.reqstats === absenceSortFilter.value);

  if (sortColumn.value.absence)
    data.sort((a, b) => {
      let aVal = a[sortColumn.value.absence];
      let bVal = b[sortColumn.value.absence];
      if (sortColumn.value.absence === "reqstats") {
        aVal = statusOrder.indexOf(aVal);
        bVal = statusOrder.indexOf(bVal);
      } else {
        aVal = String(aVal || "").toLowerCase();
        bVal = String(bVal || "").toLowerCase();
      }
      return sortOrder.value.absence === "asc"
        ? aVal.localeCompare(bVal)
        : bVal.localeCompare(aVal);
    });

  return data;
});

const filteredVolunteerRequests = computed(() => {
  let data = requests.value.filter((r) =>
    r.reqType.toLowerCase().includes("volunteer")
  );

  if (volunteerSearch.value.trim()) {
    const keyword = volunteerSearch.value.toLowerCase();
    data = data.filter((r) =>
      [
        r.first_name,
        r.middle_name,
        r.studNameName,
        r.eprogYearSec,
        r.reqType,
        r.reqstats,
      ]
        .filter(Boolean)
        .some((val) => val.toLowerCase().includes(keyword))
    );
  }

  if (volunteerSortFilter.value)
    data = data.filter((r) => r.reqstats === volunteerSortFilter.value);

  if (sortColumn.value.volunteer)
    data.sort((a, b) => {
      let aVal = a[sortColumn.value.volunteer];
      let bVal = b[sortColumn.value.volunteer];
      if (sortColumn.value.volunteer === "reqstats") {
        aVal = statusOrder.indexOf(aVal);
        bVal = statusOrder.indexOf(bVal);
      } else {
        aVal = String(aVal || "").toLowerCase();
        bVal = String(bVal || "").toLowerCase();
      }
      return sortOrder.value.volunteer === "asc"
        ? aVal.localeCompare(bVal)
        : bVal.localeCompare(aVal);
    });

  return data;
});

const onAbsenceSearch = (value?: string): void => {
  absenceSearch.value = value ?? '';
  currentPage.value.absence = 1; // reset to first page on new search
};

const onVolunteerSearch = (value?: string): void => {
  volunteerSearch.value = value ?? '';
  currentPage.value.volunteer = 1; // reset to first page on new search
};

// ------------------------
// Pagination
// ------------------------
const paginatedAbsenceRequests = computed(() => {
  const start = (currentPage.value.absence - 1) * itemsPerPage;
  return filteredAbsenceRequests.value.slice(start, start + itemsPerPage);
});

const paginatedVolunteerRequests = computed(() => {
  const start = (currentPage.value.volunteer - 1) * itemsPerPage;
  return filteredVolunteerRequests.value.slice(start, start + itemsPerPage);
});

const totalPagesAbsence = computed(() => Math.ceil(filteredAbsenceRequests.value.length / itemsPerPage));
const totalPagesVolunteer = computed(() => Math.ceil(filteredVolunteerRequests.value.length / itemsPerPage));
const statusMapToBackend = { 'Pending': 0, 'Approved': 1, 'Rejected': 2 };

// ------------------------
// Update Status - Optimized
// ------------------------
const updateAbsenceStatus = async (req: any, status: 'Approved' | 'Rejected') => {
  if (!req) return;
  try {
    const backendStatus = statusMapToBackend[status];
    await axios.put(`http://localhost:5000/api/admin/requests/${req.request_id}`, { reqstats: backendStatus });
    req.reqstats = status; // keep frontend string
    requests.value = requests.value.map(r => r.request_id === req.request_id ? req : r);
    approvedReqs.value = requests.value.filter(r => r.reqstats === 'Approved').length;
    rejectedReqs.value = requests.value.filter(r => r.reqstats === 'Rejected').length;
    pendingReqs.value = requests.value.filter(r => r.reqstats === 'Pending').length;

    Swal.fire({
      title: 'Success',
      text: `Request ${status.toLowerCase()}`,
      icon: 'success',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
    showAbsenceModal.value = false;
  } catch (e) {
    console.error(e);
    Swal.fire({
      title: 'Error',
      text: 'Failed to update request',
      icon: 'error',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};

const updateVolunteerStatus = async (req: any, status: number) => {
  if (!req) return;
  try {
    await axios.put(`http://localhost:5000/api/admin/requests/${req.request_id}`, { reqstats: status });
    const index = requests.value.findIndex((r) => r.request_id === req.request_id);
    if (index !== -1) requests.value[index].reqstats = status === 1 ? 'Approved' : 'Rejected';

    updateCounts();
    Swal.fire({
      title: 'Success',
      text: `Request ${requests.value[index].reqstats.toLowerCase()}`,
      icon: 'success',
      timer: 1200,
      showConfirmButton: false,
      didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
    });
    showVolunteerModal.value = false;
  } catch (e) {
    console.error(e);
    Swal.fire({ title: 'Error', text: 'Failed to update request', icon: 'error' });
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
  padding-bottom: 200px;
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
  position: fixed;
  bottom: 0;
  width: 100%;
}
.request-overviews h3{
    font-size: 24px;
    margin-top: 0px !important;
    font-weight: 700;
    text-align: center;
    margin-bottom: 15px;
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
    margin-top: 25px;
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
.close-btn {
  --color: white;              /* make the icon white */
}

.close-btn ion-icon {
  font-size: 15px;  
  margin-left: 75px !important;  
  margin-right: 0 !important;
}

</style>
