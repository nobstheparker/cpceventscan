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
                <li><router-link to="/Event/create" class="sub">Create Event</router-link></li>
                <li><router-link to="/Event/event-lists" class="sub">Event List</router-link></li>
                <li><router-link to="/Event/attendance-page" class="sub">Attendance Page Control</router-link></li>
                <li><router-link to="/Event/attendance-records" class="sub">View Attendance Records</router-link></li>
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
              <router-link to="/adminLogIn" class="sidebar-link" @click="confirmLogout">
                Log Out
              </router-link>
            </li>
          </ul>
        </div>

        <div class="main-content">
          <h3 style="margin-bottom: 20px; color:#fff;">Account Center Overview</h3>

          <ion-card style="margin-bottom: 20px;">
            <div style="background: #07055d; padding: 12px; text-align: center; border-bottom: none;">
              <h4 style="margin: 0 auto; font-size: 18px; font-weight: bold; color: white;">Profile Info</h4>
            </div>
            <ion-card-content style="background-color: #e9e6e6;">
              <div style="margin-bottom: 15px;">
                <label>Name</label>
                <ion-input
                  type="text"
                  :value="superadmin.name"
                  readonly
                  style=" padding: 8px; border-radius: 3px; margin-top: 5px;"
                ></ion-input>
              </div>

              <div style="margin-bottom: 15px;">
                <label>Email</label>
                <ion-input
                  type="email"
                  :value="superadmin.email"
                  readonly
                  style="padding: 8px; border-radius: 3px; margin-top: 5px;"
                ></ion-input>
              </div>

              <div style="margin-bottom: 15px;">
                <label>Password</label>
                <ion-input
                  type="password"
                  :value="superadmin.password"
                  readonly
                  style="padding: 8px; border-radius: 3px; margin-top: 5px;"
                ></ion-input>
              </div>

              <ion-button expand="block" style="margin-top: 10px; font-weight: 600;">
                Edit Profile
              </ion-button>
            </ion-card-content>
          </ion-card>

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
                      <th style="padding: 10px;">Password</th>
                      <th style="padding: 10px;">Status</th>
                      <th style="padding: 10px; text-align: center;">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="admin in admins" :key="admin.id" style="border-bottom: 1px solid #ccc; background-color: #c9c8c8; border-bottom: 1px solid #07055d;">
                      <td style="padding: 10px; border-right: 1px solid #07055D;">{{ admin.name }}</td>
                      <td style="padding: 10px; border-right: 1px solid #07055D;">{{ admin.email }}</td>
                      <td style="padding: 10px; border-right: 1px solid #07055D;">{{ admin.password }}</td>
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
                        <ion-button size="small" fill="solid" style="--background: #f1c204; --color: black; margin-right: 5px; font-weight: 600; --border-radius: 6px;">Edit</ion-button>
                        <ion-button
                          size="small"
                          style="--background: #ff0707; --color: white; margin-right: 5px; font-weight: 600; --border-radius: 6px;"
                          fill="solid"
                        >
                          {{ admin.status === 'Active' ? 'Deactivate' : 'Activate' }}
                        </ion-button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <ion-button expand="block" style="--background: green; --color: white; margin-right: 5px; font-weight: 600; --border-radius: 6px; margin-top: 10px;" @click="openAddAdminModal">
                Add New Admin
              </ion-button>
            </ion-card-content>
          </ion-card>
        </div>
      </div>
    </ion-content>

    <ion-modal :is-open="isAddAdminModalOpen" @didDismiss="closeAddAdminModal">
      <ion-header>
        <ion-toolbar>
          <ion-title>Add New Admin</ion-title>
          <ion-buttons slot="end">
            <ion-button @click="closeAddAdminModal">Close</ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content class="modal-content">
        <ion-list>
          <ion-item>
            <ion-label position="stacked">First Name</ion-label>
            <ion-input v-model="newAdmin.f_name" required></ion-input>
          </ion-item>
          
          <ion-item>
            <ion-label position="stacked">Middle Name</ion-label>
            <ion-input v-model="newAdmin.m_name"></ion-input>
          </ion-item>
          
          <ion-item>
            <ion-label position="stacked">Last Name</ion-label>
            <ion-input v-model="newAdmin.l_name" required></ion-input>
          </ion-item>
          
          <ion-item>
            <ion-label position="stacked">Email</ion-label>
            <ion-input type="email" v-model="newAdmin.email" required></ion-input>
          </ion-item>
          
          <ion-item>
            <ion-label position="stacked">Password</ion-label>
            <ion-input type="password" v-model="newAdmin.password" required></ion-input>
          </ion-item>
          
          <ion-item>
            <ion-label position="stacked">Role</ion-label>
            <ion-input v-model="newAdmin.role" required></ion-input>
          </ion-item>
        </ion-list>

        <ion-button expand="block" @click="addAdmin" style="margin: 20px;">Add Admin</ion-button>
      </ion-content>
    </ion-modal>

    <div class="footer">
      <ion-text>
        <small>&copy; All Rights Reserved PPG 2025.</small>
      </ion-text>
    </div>
  </ion-page>
</template>

<script>
import {
  IonButton,
  IonCard,
  IonCardContent,
  IonContent,
  IonHeader,
  IonIcon,
  IonInput,
  IonPage,
  IonText,
  IonToolbar,
  IonModal,
  IonTitle,
  IonList,
  IonItem,
  IonLabel,
  IonButtons
} from '@ionic/vue';

import { notifications } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { ref } from 'vue';
import { useRouter } from 'vue-router';

export default {
  components: {
    IonButton,
    IonCard,
    IonCardContent,
    IonContent,
    IonHeader,
    IonIcon,
    IonInput,
    IonPage,
    IonText,
    IonToolbar,
    IonModal,
    IonTitle,
    IonList,
    IonItem,
    IonLabel,
    IonButtons
  },
  setup() {
    const router = useRouter();
    const showStudentMenu = ref(false);
    const showAcadMenu = ref(false);
    const showEventMenu = ref(false);
    const isAddAdminModalOpen = ref(false);

    const newAdmin = ref({
      f_name: '',
      m_name: '',
      l_name: '',
      email: '',
      password: '',
      role: ''
    });

    const admins = ref([
      {
        id: 1,
        name: 'Admin One',
        email: 'admin1@example.com',
        password: '••••••••',
        status: 'Active'
      },
      {
        id: 2,
        name: 'Admin Two',
        email: 'admin2@example.com',
        password: '••••••••',
        status: 'Inactive'
      }
    ]);

    const superadmin = ref({
      name: 'Superadmin User',
      email: 'superadmin@example.com',
      password: '********'
    });

    const toggleStudentMenu = () => showStudentMenu.value = !showStudentMenu.value;
    const toggleAcadMenu = () => showAcadMenu.value = !showAcadMenu.value;
    const toggleEventMenu = () => showEventMenu.value = !showEventMenu.value;

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

    const openAddAdminModal = () => {
      isAddAdminModalOpen.value = true;
    };

    const closeAddAdminModal = () => {
      isAddAdminModalOpen.value = false;
      newAdmin.value = {
        f_name: '',
        m_name: '',
        l_name: '',
        email: '',
        password: '',
        role: ''
      };
    };

    const addAdmin = () => {
      const fullName = `${newAdmin.value.f_name} ${newAdmin.value.m_name ? newAdmin.value.m_name + ' ' : ''}${newAdmin.value.l_name}`;
      const newAdminEntry = {
        id: admins.value.length + 1,
        name: fullName,
        email: newAdmin.value.email,
        password: newAdmin.value.password,
        status: 'Active',
        role: newAdmin.value.role
      };
      admins.value.push(newAdminEntry);
      closeAddAdminModal();
    };

    return {
      notifications,
      showStudentMenu,
      showAcadMenu,
      showEventMenu,
      toggleStudentMenu,
      toggleAcadMenu,
      toggleEventMenu,
      superadmin,
      admins,
      confirmLogout,
      isAddAdminModalOpen,
      newAdmin,
      openAddAdminModal,
      closeAddAdminModal,
      addAdmin
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
</style>
