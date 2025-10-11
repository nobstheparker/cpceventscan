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
                <a href="javascript:void(0);" class="sidebar-link" @click="confirmLogout">
                    Log Out
                </a>
            </li>
          </ul>
        </div>

        <div class="main-content">
          <h4>Reminders & Announcement List</h4>
          <div style="display: flex; justify-content: flex-end; gap: 15px; margin-top: 5px; margin-bottom: 5px;">
            <ion-button
              style="--background: green; --color: white; font-weight: 700; --border-radius: 5px; width: 330px;"
              @click="openAddModal">
              Add New
            </ion-button>
          </div>

          <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Description</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <tr v-for="(update, index) in paginatedEvents" :key="update.update_id">
                <td>{{ update.name }}</td>
                <td>{{ update.description }}</td>
                <td>{{ update.status || 'Inactive' }}</td>
                <td>
                  <ion-button
                    size="small"
                    fill="solid"
                    style="--background: #F1C204; --color: black; --border-radius: 3px; font-weight: 600;"
                    expand="block"
                    @click="openEditModal(update, index)">
                    Edit
                  </ion-button>

                  <ion-button
                    size="small"
                    fill="solid"
                    style="--background: #970303; --color: white; --border-radius: 3px; font-weight: 600;"
                    expand="block"
                    @click="deleteUpdate(update.update_id)">
                    Delete
                  </ion-button>

                  <ion-button
                    size="small"
                    fill="solid"
                    :style="update.status === 'Active'
                      ? '--background:#07055dcf; --color:white; --border-radius:3px; font-weight:600;'
                      : '--background:#008000; --color:white; --border-radius:3px; font-weight:600;'"
                    expand="block"
                    @click="deployUpdate(update)">
                    {{ update.status === 'Active' ? 'Withdraw' : 'Deploy' }}
                  </ion-button>
                </td>
              </tr>
            </tbody>
            </table>
          </div>

          <!-- Modal -->
          <ion-modal :is-open="isModalOpen" @didDismiss="isModalOpen = false">
            <div style="background:white; border-radius:8px; overflow:hidden; margin-top: 10px; max-width: 500px; margin-left:auto; margin-right:auto;">
              <!-- Header -->
              <div style="background:#07055D; color:white; padding:10px; display:flex; justify-content:space-between; align-items:center;">
                <b>{{ isEdit ? 'Edit Update' : 'Add New Update' }}</b>
                <button @click="isModalOpen = false" style="background:none; border:none; color:white; font-size:18px;">✖</button>
              </div>

              <!-- Body -->
              <div style="padding:15px; background:#D9D9D9;">
                <label><b>Update Name:</b></label>
                <input v-model="currentUpdate.name" placeholder="Enter name"
                  style="width:100%; padding:6px; margin-bottom:8px; border:1px solid #b1b1b2; border-radius:4px; background-color:white; font-size:14px; color:black; margin-top: 5px;" />

                <label><b>Short Description:</b></label>
                <textarea v-model="currentUpdate.description" placeholder="Enter short description"
                  style="width:100%; padding:6px; border:1px solid #b1b1b2; border-radius:4px; background-color:white; font-size:14px; color:black; min-height:40px; max-height:180px; overflow-y:auto; resize:vertical;margin-top: 5px;"></textarea>

                <ion-button fill="solid"
                  style="--background: #07055d; --color: #ffff00; font-weight: 700; width: 120px; display: flex; margin: 15px auto; margin-top:12px;"
                  @click="saveUpdate">
                  {{ isEdit ? 'Update' : 'Save' }}
                </ion-button>
              </div>

              <!-- Footer -->
              <div style="background:#07055D; padding:10px; text-align:right; height:50px;"></div>
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
import { IonButton, IonContent, IonHeader, IonPage, IonText, IonToolbar } from '@ionic/vue';
import Swal from 'sweetalert2';
import { computed, ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();
const API_BASE = 'http://localhost:5000/api/updates'; // backend API

const removeSwalHeight = () => {
  document.body.classList.remove("swal2-height-auto");
  document.documentElement.classList.remove("swal2-height-auto");
};

// Confirm logout
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
// Sidebar menus
const showStudentMenu = ref(false);
const showAcadMenu = ref(false);
const showEventMenu = ref(false);
const toggleStudentMenu = () => showStudentMenu.value = !showStudentMenu.value;
const toggleAcadMenu = () => showAcadMenu.value = !showAcadMenu.value;
const toggleEventMenu = () => showEventMenu.value = !showEventMenu.value;

// Pagination & search
const searchQuery = ref('');
const currentPage = ref(1);
const itemsPerPage = 10;

interface UpdateItem {
  update_id: number; // backend id
  name: string;
  description: string;
  status: 'Active' | 'Inactive';
}

const updatesList = ref<UpdateItem[]>([]);

// Fetch updates
const fetchUpdates = async () => {
  try {
    const response = await axios.get(API_BASE);
    updatesList.value = response.data; // keep update_id
  } catch (error) {
    console.error('Failed to fetch updates:', error);
  }
};

// Filtered & paginated updates
const filteredUpdates = computed(() => {
  let result = [...updatesList.value];
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase();
    result = result.filter(u =>
      u.name.toLowerCase().includes(q) || u.description.toLowerCase().includes(q)
    );
  }
  return result;
});

const totalPages = computed(() => Math.ceil(filteredUpdates.value.length / itemsPerPage));
const paginatedEvents = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredUpdates.value.slice(start, start + itemsPerPage);
});

// Modal for add/edit
const isModalOpen = ref(false);
const isEdit = ref(false);
const currentUpdate = ref<Partial<UpdateItem>>({ name: '', description: '', status: 'Inactive' });

const openAddModal = () => {
  isEdit.value = false;
  currentUpdate.value = { name: '', description: '', status: 'Inactive' };
  isModalOpen.value = true;
};

const openEditModal = (update: UpdateItem) => {
  isEdit.value = true;
  currentUpdate.value = { ...update };
  isModalOpen.value = true;
};

// Save update
const saveUpdate = async () => {
  if (!currentUpdate.value.name || !currentUpdate.value.description) {
    alert('Please fill in both fields');
    return;
  }

  const result = await Swal.fire({
    title: isEdit.value ? 'Update this item?' : 'Add new item?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: isEdit.value ? 'Yes, update it!' : 'Yes, add it!',
    cancelButtonText: 'Cancel',
    didOpen: removeSwalHeight
  });

  if (!result.isConfirmed) return;

  try {
    if (isEdit.value && currentUpdate.value.update_id) {
      await axios.put(`${API_BASE}/${currentUpdate.value.update_id}`, currentUpdate.value);
      await Swal.fire({
        title: 'Updated!',
        text: 'The update has been successfully updated.',
        icon: 'success',
        didOpen: removeSwalHeight
      });
    } else {
      await axios.post(API_BASE, currentUpdate.value);
      await Swal.fire({
        title: 'Added!',
        text: 'The update has been successfully added.',
        icon: 'success',
        didOpen: removeSwalHeight
      });
    }
    isModalOpen.value = false;
    await fetchUpdates();
  } catch (error) {
    console.error(error);
    await Swal.fire({
      title: 'Error',
      text: 'Something went wrong!',
      icon: 'error',
      didOpen: removeSwalHeight
    });
  }
};

// Delete update
const deleteUpdate = async (update_id: number) => {
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: 'This update will be permanently deleted.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'Cancel',
    didOpen: removeSwalHeight
  });

  if (!result.isConfirmed) return;

  try {
    await axios.delete(`${API_BASE}/${update_id}`);
    await Swal.fire({
      title: 'Deleted!',
      text: 'The update has been successfully deleted.',
      icon: 'success',
      didOpen: removeSwalHeight
    });
    await fetchUpdates();
  } catch (error) {
    console.error(error);
    await Swal.fire({
      title: 'Error',
      text: 'Could not delete update.',
      icon: 'error',
      didOpen: removeSwalHeight
    });
  }
};

// Deploy / toggle status
const deployUpdate = async (update: UpdateItem) => {
  const action = update.status === 'Active' ? 'Inactive' : 'Active';
  const result = await Swal.fire({
    title: `Are you sure you want to ${action === 'Active' ? 'deploy' : 'withdraw'} this update?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes',
    cancelButtonText: 'Cancel',
    didOpen: removeSwalHeight
  });

  if (!result.isConfirmed) return;

  try {
    await axios.put(`${API_BASE}/${update.update_id}`, { ...update, status: action });
    await Swal.fire({
      title: 'Success!',
      text: `Update is now ${action}.`,
      icon: 'success',
      didOpen: removeSwalHeight
    });
    await fetchUpdates();
  } catch (error) {
    console.error(error);
    await Swal.fire({
      title: 'Error',
      text: 'Could not update status.',
      icon: 'error',
      didOpen: removeSwalHeight
    });
  }
};

// Fetch updates on mount
onMounted(() => {
  fetchUpdates();
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
.event-overviews h3{
    font-size: 24px;
    margin-top: 0px !important;
    font-weight: 700;
    text-align: center;
    margin-bottom: 8px;
}
h4{
    font-size: 24px;
    margin-top: 15px;
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
}

.event-table th {
  background-color: #07055D;
  color: white;
  font-weight: bold;
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