<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
          <div class="admin-logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
          <div class="toolbar-icons">
            <ion-button fill="clear" size="small">
              <ion-icon :icon="notifications" slot="icon-only"></ion-icon>
            </ion-button>
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
              <router-link to="/FAQ" class="sidebar-link">FAQ Management</router-link>
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
          <div class="FAQ-overview">
            </div>
          <h4>FAQs</h4>
          <div style="display: flex; justify-content: flex-end; gap: 15px;">
          <ion-button
            style="--background: green; --color: white; font-weight: 700; --border-radius: 5px; width: 330px;"
            @click="openCreateFaqModal"
          >
            Add New
          </ion-button>
          </div>
          <div style="--background: transparent;">
            <ion-row class="ion-align-items-center ion-justify-content-between" style="margin-bottom: 10px;">
              <ion-col size="4">
                <select v-model="sortColumn" style="padding: 6px 10px; border: 1px solid #ccc; border-radius: 4px;margin-left: -3px;">
                <option disabled value="">Sort By </option>
                <option value="StatusFAQ">Status</option>
                <option value="FAQdate">Date Created</option>
                <option value="FAQmodified">Last Modified</option>
                </select>
              </ion-col>
              <ion-col size="8">
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
                    <th style="cursor:pointer;" @click="sortData('FAQs')">
                      FAQ
                      <span v-if="sortColumn === 'FAQs'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('FAQdate')">
                      Date Created
                      <span v-if="sortColumn === 'FAQdate'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('FAQmodified')">
                      Last Modified
                      <span v-if="sortColumn === 'FAQmodified'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th style="cursor:pointer;" @click="sortData('StatusFAQ')">
                        Status
                      <span v-if="sortColumn === 'StatusFAQ'">{{ sortOrder === 'asc' ? '▲' : '▼' }}</span>
                    </th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(FAQ, index) in paginatedFAQs" :key="FAQ.faqID">
                    <td>{{ FAQ.FAQs }}</td>
                    <td>{{ FAQ.FAQdate }}</td>
                    <td>{{ FAQ.FAQmodified }}</td>
                    <td>{{ FAQ.StatusFAQ }}</td>
                    <td>
                      <ion-button 
                        size="small" 
                        fill="solid" 
                        style="--background: #F1C204;--color: black; --border-radius: 3px; font-weight: 600;" 
                        expand="block"
                        @click="openEditFaqModal(FAQ, index)"
                      >
                        Edit
                      </ion-button>
                      <ion-button
                        size="small" 
                        fill="solid" 
                        style="--background:#07055dcf;--color: white; --border-radius: 3px; font-weight: 600;" 
                        expand="block"
                        v-if="FAQ.StatusFAQ === 'Active'"
                        @click="deactivateFaq(index)"
                      >
                        Deactivate
                      </ion-button>

                      <ion-button
                        size="small" 
                        fill="solid" 
                        style="--background: #008000;--color: white; --border-radius: 3px; font-weight: 600;" 
                        expand="block"
                        v-else
                        @click="activateFaq(index)"
                      >
                        Activate
                      </ion-button>

                      <ion-button 
                        size="small" 
                        fill="solid" 
                        style="--background: #970303;--color: white; --border-radius: 3px; font-weight: 600;" 
                        expand="block"
                        @click="deleteFaq(index)"
                      >
                        Delete
                      </ion-button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <ion-modal :is-open="isFaqModalOpen" @didDismiss="isFaqModalOpen = false">
              <div style="background:white; border-radius:8px; overflow:hidden; margin-top: 70px;">
                <!-- Header -->
                <div style="background:#07055D; color:white; padding:10px; display:flex; justify-content:space-between; align-items:center;">
                  <b>{{ isEditFaq ? 'Edit FAQ' : 'New FAQ' }}</b>
                  <button @click="isFaqModalOpen = false" style="background:none; border:none; color:white; font-size:18px;">✖</button>
                </div>

                <!-- Body -->
                <div style="padding:15px 15px; background:#D9D9D9;">
                  <label><b>Question:</b></label>
                  <input v-model="faqData.question" placeholder="Enter question"
                    style="width:100%; padding:6px; margin-bottom:8px; border:1px solid #b1b1b2; border-radius:4px; background-color:white; font-size:14px; color:black; margin-bottom: 5px;" />

                  <label><b>Answer:</b></label>
                  <textarea v-model="faqData.answer" placeholder="Enter answer"
                    style="   width: 100%;
                              padding: 6px;
                              border: 1px solid #b1b1b2;
                              border-radius: 4px;
                              background-color: white;
                              font-size: 14px;
                              color: black;
                              min-height: 40px;   /* minimum height */
                              max-height: 180px;  /* maximum height before scroll */
                              overflow-y: auto;
                              resize: vertical;   /* allow vertical resize only */
                            "></textarea>

                  <ion-button fill="solid"
                    style="--background: #07055d; --color: #ffff00; font-weight: 700; width: 120px; display: flex; margin: 15px auto; margin-top: 12px;"
                    @click="saveFaq">
                    {{ isEditFaq ? 'Update' : 'Save' }}
                  </ion-button>
                </div>

                <!-- Footer -->
                <div style="background:#07055D; padding:10px; text-align:right; height: 50px;"></div>
              </div>
            </ion-modal>

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
  IonToolbar
} from '@ionic/vue';
import { notificationsOutline } from 'ionicons/icons';
import Swal from 'sweetalert2';
import { computed, reactive, ref } from 'vue';
import { useRouter } from 'vue-router';

// use the outline icon (keeps the template :icon="notifications" working)
const notifications = notificationsOutline;

const router = useRouter();

const confirmLogout = async () => {
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: 'You will be logged out and redirected to the login page.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, log me out!',
          didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        }
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

const sortColumn = ref('');
const sortOrder = ref<'asc' | 'desc'>('asc');
const searchQuery = ref('');
const currentPage = ref(1);
const itemsPerPage = 10;

const totalFAQS = ref(10);
const activeFAQS = ref(6);
totalFAQS.value = 10;
activeFAQS.value = 6;
const inactiveFAQS = computed(() => totalFAQS.value - activeFAQS.value);

interface FAQData {
  faqID: number;
  FAQs: string;
  FAQdate: string;
  FAQmodified: string;
  StatusFAQ: string;
}

const events = ref<FAQData[]>([
  {
    faqID: 1,
    FAQs: 'How to reset password?',
    FAQdate: '2025-06-01',
    FAQmodified: '2025-06-02',
    StatusFAQ: 'Active'
  },
  {
    faqID: 2,
    FAQs: 'Where to submit assignments?',
    FAQdate: '2025-06-10',
    FAQmodified: '2025-06-12',
    StatusFAQ: 'Inactive'
  }
]);

const sortData = (column: string) => {
  if (sortColumn.value === column) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortColumn.value = column;
    sortOrder.value = 'asc';
  }
  currentPage.value = 1;
};

const filteredData = computed<FAQData[]>(() => {
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
    const key = sortColumn.value as keyof FAQData;

    result.sort((a, b) => {
      let aValue = a[key];
      let bValue = b[key];

      aValue = typeof aValue === 'string' ? aValue.toLowerCase() : (aValue as any);
      bValue = typeof bValue === 'string' ? bValue.toLowerCase() : (bValue as any);

      if (aValue < bValue) return sortOrder.value === 'asc' ? -1 : 1;
      if (aValue > bValue) return sortOrder.value === 'asc' ? 1 : -1;
      return 0;
    });
  }

  return result;
});

const totalPages = computed(() => {
  return Math.ceil(filteredData.value.length / itemsPerPage);
});

const paginatedFAQs = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredData.value.slice(start, start + itemsPerPage);
});

interface FAQ {
  question: string;
  answer: string;
}

const isFaqModalOpen = ref(false);
const isEditFaq = ref(false);
const editFaqIndex = ref<number | null>(null);

// use `faqData` to match your template's v-models
const faqData = reactive<FAQ>({
  question: '',
  answer: ''
});

// keep faqList (unused) - preserved per your request not to omit code
const faqList = ref<FAQ[]>([]);

// Open create modal (clears form)
function openCreateFaqModal() {
  isEditFaq.value = false;
  editFaqIndex.value = null;
  faqData.question = '';
  faqData.answer = '';
  isFaqModalOpen.value = true;
}

// Open edit modal. The table uses paginatedFAQs; the passed FAQ item may be a slice entry.
// Find the actual index in the full `events` array by faqID to update correctly.
function openEditFaqModal(faq: FAQData, pageIndex: number) {
  isEditFaq.value = true;
  // find global index in events by faqID
  const globalIndex = events.value.findIndex(e => e.faqID === faq.faqID);
  editFaqIndex.value = globalIndex !== -1 ? globalIndex : pageIndex;
  faqData.question = faq.FAQs;
  faqData.answer = ''; // events do not store answer, kept blank for now
  isFaqModalOpen.value = true;
}

// Save FAQ: update existing events item or create a new event entry
function saveFaq() {
  const today = new Date().toISOString().split('T')[0];

  if (isEditFaq.value && editFaqIndex.value !== null && editFaqIndex.value >= 0 && editFaqIndex.value < events.value.length) {
    // update the events entry
    events.value[editFaqIndex.value] = {
      ...events.value[editFaqIndex.value],
      FAQs: faqData.question,
      FAQmodified: today
    };
  } else {
    // create new events entry
    const nextId = (events.value.reduce((max, e) => Math.max(max, e.faqID), 0) || 0) + 1;
    events.value.push({
      faqID: nextId,
      FAQs: faqData.question,
      FAQdate: today,
      FAQmodified: today,
      StatusFAQ: 'Active'
    });
    // update totals
    totalFAQS.value = totalFAQS.value + 1;
    activeFAQS.value = activeFAQS.value + 1;
  }

  // also keep faqList in sync (preserved)
  faqList.value.push({ question: faqData.question, answer: faqData.answer });

  Swal.fire({
    title: 'Saved!',
    text: 'FAQ has been successfully saved.',
    icon: 'success',
    confirmButtonColor: '#3085d6'
  });

  isFaqModalOpen.value = false;
  // reset
  faqData.question = '';
  faqData.answer = '';
  isEditFaq.value = false;
  editFaqIndex.value = null;
}
function activateFaq(index: number) {
  Swal.fire({
    title: 'Activate this FAQ?',
    text: 'This FAQ will be visible to students.',
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#28a745',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, activate it!',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  }).then((result) => {
    if (result.isConfirmed) {
      events.value[index].StatusFAQ = 'Active';
      Swal.fire({
        title: 'Activated!',
        text: 'The FAQ is now active and visible to students.',
        icon: 'success',
        confirmButtonColor: '#3085d6',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    }
  });
}

function deactivateFaq(index: number) {
  Swal.fire({
    title: 'Deactivate this FAQ?',
    text: 'This FAQ will no longer be visible to students.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#007bff', // blue button
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, deactivate it!',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  }).then((result) => {
    if (result.isConfirmed) {
      events.value[index].StatusFAQ = 'Inactive';
      Swal.fire({
        title: 'Deactivated!',
        text: 'The FAQ is now hidden from students.',
        icon: 'success',
        confirmButtonColor: '#3085d6',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    }
  });
}

function deleteFaq(index: number) {
  Swal.fire({
    title: 'Are you sure?',
    text: 'This FAQ will be permanently deleted.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
    confirmButtonText: 'Yes, delete it!',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  }).then((result) => {
    if (result.isConfirmed) {
      events.value.splice(index, 1);

      Swal.fire({
        title: 'Deleted!',
        text: 'The FAQ has been removed.',
        icon: 'success',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    }
  });
}

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
.FAQ-overview h3{
    font-size: 24px;
    margin-top: 0px !important;
    font-weight: 700;
    text-align: center;
    margin-bottom: 8px;
}
h4{
    font-size: 24px;
    margin-top: 10px;
    margin-bottom: 0px !important;
    font-weight: 700;
    text-align: center;
}

.faqTable {
  width: 100%;
  border-collapse: collapse;
  font-size: 18px;
}

.faqTable th,
.faqTable td {
  text-align: center;
  padding: 12px;
  border: 1px solid #ccc;
}

.faqTable th {
  background-color: #07055D;
  color: white;
  font-weight: bold;
}
.faqTable tbody{
    color: #19191a;
    background: #d4dce9;
}
.faqTable td{
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