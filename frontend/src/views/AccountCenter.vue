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
            <template v-if="loggedInAdmin && loggedInAdmin.role !== 0">
              <li><router-link to="/Request" class="sidebar-link">Request Management</router-link></li>
              <li><router-link to="/Notif" class="sidebar-link">Notification Management</router-link></li>
              <li><router-link to="/Feed" class="sidebar-link">Feedback Management</router-link></li>
              <li><router-link to="/Update" class="sidebar-link">Featured Updates</router-link></li>
            </template>
            <template v-if="loggedInAdmin && loggedInAdmin.status !== 2">
              <li><router-link to="/Account-center" class="sidebar-link">Account Center</router-link></li>
            </template>
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

          <!-- Profile Info -->
          <ion-card style="margin-bottom: 20px;">
            <div style="background: #07055d; padding: 12px; text-align: center;">
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

          <!-- Admin Table -->
          <ion-card style="margin-bottom: 20px;">
            <div style="background: #07055d; padding: 12px; text-align: center;">
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
                      v-for="admin in admins"
                      :key="admin.id"
                      style="border-bottom: 1px solid #07055d; background-color: #c9c8c8;"
                    >
                      <td style="padding: 10px;">{{ admin.name }}</td>
                      <td style="padding: 10px;">{{ admin.email }}</td>
                      <td style="padding: 10px;">
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
                          style="--background: #f1c204; --color: black; margin-right: 5px;"
                          @click="openAccountModal(admin)"
                        >
                          Edit
                        </ion-button>
                        <ion-button
                          size="small"
                          style="--background: #ff0707; --color: white;"
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

              <ion-button expand="block" style="--background: green; --color: white; margin-top: 10px;" @click="openAddAdminAccountModal">
                Add New Admin
              </ion-button>
            </ion-card-content>
          </ion-card>
        </div>
      </div>
    </ion-content>

    <div class="footer">
      <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
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
          <input v-model="selectedAdmin.name" placeholder="Enter name" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;" />
          <label><b>Email:</b></label>
          <input v-model="selectedAdmin.email" placeholder="Enter email" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;" />
          <label><b>New Password:</b></label>
          <input type="password" v-model="selectedAdmin.password" placeholder="Enter new password" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;" />
          <ion-button expand="block" style="--background: #07055d; --color: #ffff00; margin-top: 12px;" @click="selectedAdmin.isLoggedIn ? updateLoggedInAdminProfile() : updateOtherAdminProfile()">
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
          <input v-model="newAdminAccount.name" placeholder="Enter name" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;" />
          <label><b>Email:</b></label>
          <input v-model="newAdminAccount.email" placeholder="Enter email" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;" />
          <label><b>Password:</b></label>
          <input type="password" v-model="newAdminAccount.password" placeholder="Enter password" style="width:100%; padding:6px; margin-bottom:8px; border-radius:4px;" />
          <ion-button expand="block" style="--background: #07055d; --color: #ffff00; margin-top: 12px;" @click="addNewAdminAccount">
            Add
          </ion-button>
        </div>
      </div>
    </ion-modal>
  </ion-page>
</template>

<script>
import { IonButton, IonCard, IonCardContent, IonContent, IonHeader, IonInput, IonModal, IonPage, IonText, IonToolbar } from '@ionic/vue';
import Swal from 'sweetalert2';
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

export default {
  components: { IonButton, IonCard, IonCardContent, IonContent, IonHeader, IonInput, IonPage, IonText, IonToolbar, IonModal },
  setup() {
    const router = useRouter();
    const API_URL = 'http://localhost:5000/api/users';
    const showStudentMenu = ref(false);
    const showAcadMenu = ref(false);
    const showEventMenu = ref(false);
    const loggedInAdmin = ref({});
    const admins = ref([]);
    const selectedAdmin = ref({ id: null, name: '', email: '', password: '', status: '', isLoggedIn: false });
    const newAdminAccount = ref({ name: '', email: '', password: '' });
    const isProfileModalOpen = ref(false);
    const isAddAdminAccountModalOpen = ref(false);

    const toggleStudentMenu = () => showStudentMenu.value = !showStudentMenu.value;
    const toggleAcadMenu = () => showAcadMenu.value = !showAcadMenu.value;
    const toggleEventMenu = () => showEventMenu.value = !showEventMenu.value;

    const fetchAdmins = async () => {
      const res = await axios.get(API_URL);
      admins.value = res.data
        .filter(a => a.role === 0 && (a.status === 1 || a.status === 2))
        .map(a => ({
          id: a.user_id,
          name: [a.f_name, a.m_name, a.l_name].filter(Boolean).join(' '),
          email: a.email,
          status: a.status === 2 ? 'Active' : 'Inactive'
        }));
    };

    onMounted(async () => {
      try {
        const res = await axios.get('http://localhost:5000/api/check-admin-session', { withCredentials: true });
        if (res.data.loggedIn) {
          loggedInAdmin.value = res.data.admin;
        } else {
          router.replace('/adminLogIn');
        }
      } catch {
        router.replace('/adminLogIn');
      }
      await fetchAdmins();
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
        await axios.post('http://localhost:5000/api/users/admin-logout', {}, { withCredentials: true });
        router.push('/adminLogIn');
      }
    };

    const openProfileModal = () => {
      selectedAdmin.value = {
        id: loggedInAdmin.value.user_id,
        name: `${loggedInAdmin.value.f_name} ${loggedInAdmin.value.m_name} ${loggedInAdmin.value.l_name}`,
        email: loggedInAdmin.value.email,
        password: '',
        status: loggedInAdmin.value.status,
        isLoggedIn: true
      };
      isProfileModalOpen.value = true;
    };

    const openAccountModal = (admin) => {
      selectedAdmin.value = { ...admin, password: '', isLoggedIn: false };
      isProfileModalOpen.value = true;
    };

    const updateLoggedInAdminProfile = async () => {
      const adminId = selectedAdmin.value.id;
      const nameParts = selectedAdmin.value.name.split(' ');
      const payload = {
        f_name: nameParts[0],
        m_name: nameParts[1] || '',
        l_name: nameParts.slice(2).join(' ') || '',
        email: selectedAdmin.value.email,
        role: 0,
        status: loggedInAdmin.value.status // preserve existing status
      };
      if (selectedAdmin.value.password.trim()) payload.password = selectedAdmin.value.password;

      try {
        const res = await axios.put(`${API_URL}/${adminId}`, payload, { withCredentials: true });
        if (res.data.admin) {
          loggedInAdmin.value = res.data.admin;
          sessionStorage.setItem('loggedInAdmin', JSON.stringify(res.data.admin));
        }
        isProfileModalOpen.value = false;
        Swal.fire({ icon: 'success', title: 'Profile Updated!', timer: 1500, showConfirmButton: false, didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }});
      } catch {
        Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to update profile', didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }});
      }
    };

    const updateOtherAdminProfile = async () => {
      const adminId = selectedAdmin.value.id;
      const nameParts = selectedAdmin.value.name.split(' ');
      const payload = {
        f_name: nameParts[0],
        m_name: nameParts[1] || '',
        l_name: nameParts.slice(2).join(' ') || '',
        email: selectedAdmin.value.email,
        role: 0,
        status: selectedAdmin.value.status === 'Active' ? 2 : 1 // map to numeric
      };
      if (selectedAdmin.value.password.trim()) payload.password = selectedAdmin.value.password;

      try {
        await axios.put(`${API_URL}/${adminId}`, payload, { withCredentials: true });
        isProfileModalOpen.value = false;
        await fetchAdmins();
        Swal.fire({ icon: 'success', title: 'Admin Updated!', timer: 1500, showConfirmButton: false, didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }});
      } catch {
        Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to update admin', didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }});
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
        const nameParts = admin.name.split(' ');
        await axios.put(`${API_URL}/${admin.id}`, {
          f_name: nameParts[0],
          m_name: nameParts[1] || '',
          l_name: nameParts.slice(2).join(' ') || '',
          email: admin.email,
          password: '',
          role: 0,
          status: admin.status === 'Active' ? 1 : 2
        });
        await fetchAdmins();

        Swal.fire({
          icon: 'success',
          title: `Admin ${action}d!`,
          timer: 1200,
          showConfirmButton: false,
          didOpen: () => {
            document.body.classList.remove('swal2-height-auto');
            document.documentElement.classList.remove('swal2-height-auto');
          }
        });
      }
    };

    const openAddAdminAccountModal = () => {
      newAdminAccount.value = { name: '', email: '', password: '' };
      isAddAdminAccountModalOpen.value = true;
    };

    const addNewAdminAccount = async () => {
      const nameParts = newAdminAccount.value.name.split(' ');
      const payload = {
        f_name: nameParts[0],
        m_name: nameParts[1] || '',
        l_name: nameParts.slice(2).join(' ') || '',
        email: newAdminAccount.value.email,
        password: newAdminAccount.value.password,
        role: 0,
        status: 2
      };
      await axios.post(API_URL, payload);
      isAddAdminAccountModalOpen.value = false;
      await fetchAdmins();
      Swal.fire({
        icon: 'success',
        title: 'New Admin Added!',
        timer: 1500,
        showConfirmButton: false,
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    };

    return {
      router,
      showStudentMenu,
      showAcadMenu,
      showEventMenu,
      loggedInAdmin,
      admins,
      selectedAdmin,
      newAdminAccount,
      isProfileModalOpen,
      isAddAdminAccountModalOpen,
      toggleStudentMenu,
      toggleAcadMenu,
      toggleEventMenu,
      openProfileModal,
      openAccountModal,
      updateLoggedInAdminProfile,
      updateOtherAdminProfile,
      toggleAdminStatus,
      confirmLogout,
      openAddAdminAccountModal,
      addNewAdminAccount
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