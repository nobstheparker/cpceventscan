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
                <li><router-link to="/Event/create" class="sub">Create Event</router-link></li>
                <li><router-link to="/Event/event-lists" class="sub">Event List</router-link></li>
                <li><router-link to="/Event/attendance-page" class="sub">Attendance Page Control</router-link></li>
                <li><router-link to="/Event/attendance-records" class="sub">View Attendance Records</router-link></li>
              </ul>
            </li>
            <li><router-link to="/Request" class="sidebar-link">Request Management</router-link></li>
            <li><router-link to="/Notif" class="sidebar-link">Notification Management</router-link></li>
            <li><router-link to="/Feed" class="sidebar-link">Feedback Management</router-link></li>
            <li><router-link to="/Update" class="sidebar-link">Featured Updates</router-link></li>
            <li>
              <a href="javascript:void(0);" class="sidebar-link" @click="confirmLogout">
                Log Out
              </a>
            </li>

          </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
          <h3 style="margin-bottom: 20px; color:#fff;">Account Center Overview</h3>

          <!-- Profile Info Card -->
          <ion-card style="margin-bottom: 20px;">
            <div style="background: #07055d; padding: 12px; text-align: center; border-bottom: none;">
              <h4 style="margin: 0 auto; font-size: 18px; font-weight: bold; color: white;">Profile Info</h4>
            </div>
            <ion-card-content style="background-color: #e9e6e6;">
              <div style="margin-bottom: 15px;">
                <label>Name</label>
                <ion-input
                  type="text"
                  :value="`${loggedInAdmin.f_name} ${loggedInAdmin.m_name} ${loggedInAdmin.l_name}`"
                  readonly
                  style="padding: 8px; border-radius: 3px; margin-top: 5px;"
                ></ion-input>
              </div>

              <div style="margin-bottom: 15px;">
                <label>Email</label>
                <ion-input
                  type="email"
                  :value="loggedInAdmin.email"
                  readonly
                  style="padding: 8px; border-radius: 3px; margin-top: 5px;"
                ></ion-input>
              </div>

              <div style="margin-bottom: 15px;">
                <label>Password</label>
                <ion-input
                  type="password"
                  placeholder="Enter new password to change"
                  v-model="selectedAdmin.password"
                  style="padding: 8px; border-radius: 3px; margin-top: 5px;"
                ></ion-input>
              </div>

              <ion-button expand="block" style="--background: #f1c204; --color: black;" @click="openProfileModal">
                Edit Profile
              </ion-button>
            </ion-card-content>
          </ion-card>

          <!-- Admin Account Table -->
          <ion-card style="margin-bottom: 20px;">
            <div style="background: #07055d; padding: 12px; text-align: center; border-bottom: none; border: 1px solid #07055d;">
              <h4 style="margin: 0 auto; font-size: 18px; font-weight: bold; color: white;">Admin Account Management</h4>
            </div>

            <ion-card-content style="background-color: #f4f4f4;">
              <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; font-size: 14px; min-width: 700px;">
                  <thead>
                    <tr style="background-color: #07055d; color: white;">
                      <th style="padding: 10px;">Name</th>
                      <th style="padding: 10px;">Email</th>
                      <th style="padding: 10px;">Status</th>
                      <th style="padding: 10px; text-align: center;">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr 
                      v-for="admin in admins.filter(a => a.status === 'Active' || a.status === 'Inactive')" 
                      :key="admin.id"
                      style="border-bottom: 1px solid #07055d; background-color: #c9c8c8;"
                    >
                      <td style="padding: 10px; border-right: 1px solid #07055D;">{{ admin.name }}</td>
                      <td style="padding: 10px; border-right: 1px solid #07055D;">{{ admin.email }}</td>
                      <td style="padding: 10px; border-right: 1px solid #07055D;">
                        <span :style="{
                          padding: '4px 10px',
                          borderRadius: '12px',
                          backgroundColor: admin.status === 'Active' ? '#28a745' : '#aaa',
                          color: 'white',
                          fontWeight: 'bold',
                          fontSize: '12px'
                        }">
                          {{ admin.status }}
                        </span>
                      </td>
                      <td style="padding: 10px; text-align: center;">
                        <ion-button 
                          size="small" 
                          fill="solid" 
                          style="--background: #f1c204; --color: black; margin-right: 5px; font-weight: 600; --border-radius: 6px;" 
                          @click="openAccountModal(admin)"
                        >
                          Edit
                        </ion-button>
                        <ion-button 
                          size="small" 
                          style="--background: #ff0707; --color: white; margin-right: 5px; font-weight: 600; --border-radius: 6px;" 
                          fill="solid" 
                          @click="toggleAdminStatus(admin)"
                        >
                          {{ admin.status === 'Active' ? 'Deactivate' : 'Activate' }}
                        </ion-button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <ion-button expand="block" style="--background: green; --color: white; margin-right: 5px; font-weight: 600; --border-radius: 6px; margin-top: 10px;" @click="openAddAdminAccountModal">
                Add New Admin
              </ion-button>
            </ion-card-content>
          </ion-card>
        </div>
      </div>
    </ion-content>

    <!-- Footer -->
    <div class="footer">
      <ion-text>
        <small>&copy; All Rights Reserved PPG 2025.</small>
      </ion-text>
    </div>

    <!-- Profile Modal -->
    <ion-modal :is-open="isProfileModalOpen" @didDismiss="isProfileModalOpen = false">
      <div style="background:white; border-radius:8px; overflow:hidden; margin-top: 10px;">
        <div style="background:#07055D; color:white; padding:10px; display:flex; justify-content:space-between; align-items:center;">
          <b>Edit Profile</b>
          <button @click="isProfileModalOpen = false" style="background:none; border:none; color:white; font-size:18px;">✖</button>
        </div>
        <div style="padding:15px 15px; background:#D9D9D9;">
          <label><b>Name:</b></label>
          <input v-model="selectedAdmin.name" placeholder="Enter name" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;"/>
          <label><b>Email:</b></label>
          <input v-model="selectedAdmin.email" placeholder="Enter email" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;"/>
          <label><b>New Password:</b></label>
          <input type="password" v-model="selectedAdmin.password" placeholder="Enter new password to change" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;"/>
          <ion-button expand="block" style="--background: #07055d; --color: #ffff00; margin-top: 12px;" @click="updateAdminProfile">
            Update
          </ion-button>
        </div>
      </div>
    </ion-modal>

    <!-- Add Admin Modal -->
    <ion-modal :is-open="isAddAdminAccountModalOpen" @didDismiss="isAddAdminAccountModalOpen = false">
      <div style="background:white; border-radius:8px; overflow:hidden; margin-top: 10px;">
        <div style="background:#07055D; color:white; padding:10px; display:flex; justify-content:space-between; align-items:center;">
          <b>Add New Admin</b>
          <button @click="isAddAdminAccountModalOpen = false" style="background:none; border:none; color:white; font-size:18px;">✖</button>
        </div>
        <div style="padding:15px 15px; background:#D9D9D9;">
          <label><b>Name:</b></label>
          <input v-model="newAdminAccount.name" placeholder="Enter name" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;"/>
          <label><b>Email:</b></label>
          <input v-model="newAdminAccount.email" placeholder="Enter email" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;"/>
          <label><b>Password:</b></label>
          <input type="password" v-model="newAdminAccount.password" placeholder="Enter password" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;"/>
          <ion-button expand="block" style="--background: #07055d; --color: #ffff00; margin-top: 12px;" @click="addNewAdminAccount">
            Add
          </ion-button>
        </div>
      </div>
    </ion-modal>
  </ion-page>
</template>

<script>
import {
  IonButton, IonCard, IonCardContent, IonContent, IonHeader, IonIcon, IonInput, IonModal, IonPage, IonText, IonToolbar
} from '@ionic/vue';
import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

export default {
  components: { IonButton, IonCard, IonCardContent, IonContent, IonHeader, IonIcon, IonInput, IonPage, IonText, IonToolbar, IonModal },
  setup() {
    const router = useRouter();
    const API_URL = 'http://localhost:5000/api/users';

    const showStudentMenu = ref(false);
    const showAcadMenu = ref(false);
    const showEventMenu = ref(false);
    const toggleStudentMenu = () => showStudentMenu.value = !showStudentMenu.value;
    const toggleAcadMenu = () => showAcadMenu.value = !showAcadMenu.value;
    const toggleEventMenu = () => showEventMenu.value = !showEventMenu.value;

    const loggedInAdmin = ref({ user_id: null, f_name: '', l_name: '', email: '', password: '', role: null, status: null });
    const admins = ref([]);
    const selectedAdmin = ref({ id: null, name: '', email: '', password: '', status: 'Active' });
    const newAdminAccount = ref({ name: '', email: '', password: '' });
    const isProfileModalOpen = ref(false);
    const isAddAdminAccountModalOpen = ref(false);

    const fetchAdmins = async () => {
      try {
        const res = await axios.get(API_URL);
        admins.value = res.data
          .filter(a => a.role === 0)
          .map(a => ({
            id: a.user_id,
            name: [a.f_name, a.m_name, a.l_name].filter(Boolean).join(' '),
            email: a.email,
            status: a.status === 0 ? 'Active' : 'Inactive'
          }));
      } catch (err) {
        console.error(err);
      }
    };

    onMounted(async () => {
      try {
        const res = await axios.get(`http://localhost:5000/api/check-admin-session`, { withCredentials: true });
        if (res.data.loggedIn) loggedInAdmin.value = res.data.admin;
        else router.replace('/adminLogIn');
      } catch (err) {
        console.error(err);
        router.replace('/account-center');
      }
      fetchAdmins();
    });

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

    const openProfileModal = () => {
      selectedAdmin.value = {
        id: loggedInAdmin.value.user_id,
        name: `${loggedInAdmin.value.f_name} ${loggedInAdmin.value.l_name}`,
        email: loggedInAdmin.value.email,
        password: ''
      };
      isProfileModalOpen.value = true;
    };

    const openAccountModal = (admin) => {
      selectedAdmin.value = { id: admin.id, name: admin.name, email: admin.email, password: '', status: admin.status };
      isProfileModalOpen.value = true;
    };

   const updateAdminProfile = async () => {
      const adminId = selectedAdmin.value.id;
      const nameParts = selectedAdmin.value.name.split(' ');
      const f_name = nameParts[0];
      const m_name = nameParts[1] || '';
      const l_name = nameParts.slice(2).join(' ') || '';

      const payload = {
        f_name,
        m_name,
        l_name,
        email: selectedAdmin.value.email,
        role: 0,
      };
      if (selectedAdmin.value.password.trim() !== '') payload.password = selectedAdmin.value.password;

      try {
        const res = await axios.put(`${API_URL}/${adminId}`, payload, { withCredentials: true });

        // Replace loggedInAdmin with the returned admin from the backend
        if (res.data.admin) loggedInAdmin.value = res.data.admin;

        isProfileModalOpen.value = false;
        await fetchAdmins();

        Swal.fire({
          icon: 'success',
          title: 'Updated!',
          timer: 1500,
          showConfirmButton: false,
          didOpen: () => {
            document.body.classList.remove('swal2-height-auto');
            document.documentElement.classList.remove('swal2-height-auto');
          }
        });
      } catch (err) {
        console.error(err);
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: 'Failed to update profile',
          didOpen: () => {
            document.body.classList.remove('swal2-height-auto');
            document.documentElement.classList.remove('swal2-height-auto');
          }
        });
      }
    };


    const toggleAdminStatus = async (admin) => {
  const action = admin.status === 'Active' ? 'deactivate' : 'activate';
  const result = await Swal.fire({
    title: `Are you sure to ${action}?`,
    icon: 'warning',
    showCancelButton: true,
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });

  if (result.isConfirmed) {
    try {
      const nameParts = admin.name.split(' ');
      await axios.put(`${API_URL}/${admin.id}`, {
        f_name: nameParts[0],
        m_name: nameParts[1] || '',
        l_name: nameParts.slice(2).join(' ') || '',
        email: admin.email,
        password: '',
        role: 0,
        status: admin.status === 'Active' ? 1 : 0
      });
      await fetchAdmins();
      Swal.fire({
        icon: 'success',
        title: `Admin ${action}d!`,
        timer: 1500,
        showConfirmButton: false,
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    } catch (err) {
      console.error(err);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Failed to update status',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    }
  }
};


    const openAddAdminAccountModal = () => {
      newAdminAccount.value = { name: '', email: '', password: '' };
      isAddAdminAccountModalOpen.value = true;
    };

   const addNewAdminAccount = async () => {
  if (!newAdminAccount.value.name || !newAdminAccount.value.email || !newAdminAccount.value.password) {
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'All fields are required',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
    return;
  }

  const nameParts = newAdminAccount.value.name.split(' ');
  try {
    await axios.post(API_URL, {
      f_name: nameParts[0],
      m_name: nameParts[1] || '',
      l_name: nameParts.slice(2).join(' ') || '',
      email: newAdminAccount.value.email,
      password: newAdminAccount.value.password,
      role: 0,
      status: 0
    });

    isAddAdminAccountModalOpen.value = false;
    await fetchAdmins();

    Swal.fire({
      icon: 'success',
      title: 'Added!',
      text: 'New admin added',
      timer: 1500,
      showConfirmButton: false,
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  } catch (err) {
    console.error(err);
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to add admin',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};
    return {
      notifications,
      showStudentMenu, showAcadMenu, showEventMenu,
      toggleStudentMenu, toggleAcadMenu, toggleEventMenu,
      loggedInAdmin, admins, confirmLogout,
      selectedAdmin, newAdminAccount,
      isProfileModalOpen, isAddAdminAccountModalOpen,
      openProfileModal, openAccountModal,
      updateAdminProfile, toggleAdminStatus,
      openAddAdminAccountModal, addNewAdminAccount
    };
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

h3{
  font-size: 30px;
  margin-top: 0px !important;
  margin-bottom: 0px !important;
  font-weight: 700;
  text-align: center;
}

ion-card-content label{
  font-size: 16px !important;
  font-weight: 600;
  color: #343333;
}

ion-input{
  background: #ccc;
  border: 1px solid gray;
  color: #343333;
  font-weight: 500;
  padding-left: 10px !important;
}

tbody td{
  color: #343333;
  font-weight: 500;
}
.modal-content ion-label {
  margin-bottom: 10px;
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