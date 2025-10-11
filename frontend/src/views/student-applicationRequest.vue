<template>
  <IonPage>
    <!-- Header -->
    <IonHeader>
      <IonToolbar>
          <div class="logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
      </IonToolbar>
    </IonHeader>

    <IonContent>
      <div id="container">
        <div class="form-container">
          <!-- Top bar -->
          <div class="header-bottom">
            <IonButtons slot="start">
              <IonBackButton defaultHref="/profile" />
            </IonButtons>
            <IonTitle class="event-title">VOLUNTEER APPLICATION</IonTitle>
          </div>

          <!-- Cards -->
          <div class="section-title">Volunteer Application Overview</div>
          <section class="overview">
            <div class="card" v-for="card in cards" :key="card.key">
              <IonIcon :icon="card.icon" :class="['card-icon', card.key]" />
              <div class="card-label">{{ card.label }}</div>
              <div class="card-num">{{ card.count }}</div>
            </div>
          </section>

          <!-- Table -->
          <div class="section-title">Volunteer Application History</div>
          <div class="table-wrap">
            <table id="volunteerTable" class="display styled-table" style="width:100%">
              <thead>
                <tr>
                  <th>Event Name</th>
                  <th>Date</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in rows" :key="row.id">
                  <td>{{ row.event_name }}</td>
                  <td>{{ formatDate(row.start_date_time) }}</td>
                  <td>
                    <span
                      class="status-chip"
                      :class="{
                        approved: row.status === 'Approved',
                        rejected: row.status === 'Rejected',
                        pending: row.status === 'Pending'
                      }"
                    >
                      {{ row.status }}
                    </span>
                  </td>
                  <td style="display: flex;">
                    <IonButton
                      v-if="row.status === 'Pending'"
                      size="small"
                      color="danger"
                      @click="onCancel(row)"
                    >
                      Cancel
                    </IonButton>
                    <IonButton size="small" color="dark" @click="onView(row)">
                      View
                    </IonButton>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="footer">
        <div class="footer-icons">
          <router-link to="/"><ion-icon name="home"></ion-icon></router-link>
          <router-link to="/calendar"><ion-icon name="calendar"></ion-icon></router-link>
          <router-link to="/scanner"><ion-icon name="scan"></ion-icon></router-link>
          <router-link to="/notifications"><ion-icon name="notifications"></ion-icon></router-link>
          <router-link to="/profile"><ion-icon name="person" class="active"></ion-icon></router-link>
        </div>
        <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
      </div>

      <!-- Modal for viewing volunteer application -->
      <ion-modal :is-open="isModalOpen" @didDismiss="closeModal" class="bootstrap-modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Volunteer Application Details</h5>
              <button type="button" class="btn-close" @click="closeModal" aria-label="Close"></button>
            </div>
            <div class="modal-body" v-if="selectedRequest">
              <p><strong>Student ID:</strong> {{ selectedRequest.student_id }}</p>
              <p><strong>Event Name:</strong> {{ selectedRequest.event_name }}</p>
              <p><strong>Role:</strong> {{ selectedRequest.role }}</p>
              <p><strong>Motivation:</strong> 
                {{ selectedRequest.motivation }}
                <span v-if="selectedRequest.motivation_other"> ({{ selectedRequest.motivation_other }})</span>
              </p>
              <p><strong>Volunteered Before:</strong> {{ selectedRequest.volunteered_before }}</p>
              <p v-if="selectedRequest.past_role"><strong>Past Role:</strong> {{ selectedRequest.past_role }}</p>
              <p><strong>Skills:</strong> 
                {{ selectedRequest.skills }}
                <span v-if="selectedRequest.skills_other"> ({{ selectedRequest.skills_other }})</span>
              </p>
              <p><strong>Available:</strong> {{ selectedRequest.available }}</p>
              <p><strong>Team Preference:</strong> 
                {{ selectedRequest.team_preference }}
                <span v-if="selectedRequest.team_other"> ({{ selectedRequest.team_other }})</span>
              </p>
              <p><strong>Agreement:</strong> 
                <span v-if="selectedRequest.agreement === 1">✔ Agreed</span>
                <span v-else>❌ Not Agreed</span>
              </p>
              <p><strong>Submitted On:</strong> {{ formatDateTime(selectedRequest.created_at) }}</p>
              <p><strong>Event Start:</strong> {{ formatDateTime(selectedRequest.start_date_time) }}</p>
              <p><strong>Event End:</strong> {{ formatDateTime(selectedRequest.end_date_time) }}</p>
              <p><strong>Status:</strong> 
                <span class="status-chip"
                  :class="{
                    approved: selectedRequest.status === 'Approved',
                    rejected: selectedRequest.status === 'Rejected',
                    pending: selectedRequest.status === 'Pending'
                  }">
                  {{ selectedRequest.status }}
                </span>
              </p>
            </div>
          </div>
        </div>
      </ion-modal>
    </IonContent>
  </IonPage>
</template>

<script setup lang="ts">
import {
  IonPage,
  IonHeader,
  IonToolbar,
  IonContent,
  IonButton,
  IonIcon,
  IonText,
  IonBackButton,
  IonButtons,
  IonTitle,
  IonModal
} from "@ionic/vue";
import $ from "jquery";
import "datatables.net";
import { thumbsUp, thumbsDown, ellipsisHorizontal, list } from "ionicons/icons";
import { ref, computed, onMounted, nextTick } from "vue";
import axios from "axios";
import Swal from "sweetalert2";

interface VolunteerApplication {
  id: number;
  volunteered_id: number;
  student_id: string;
  role: string;
  motivation: string;
  motivation_other?: string;
  volunteered_before?: string;
  past_role?: string;
  skills: string;
  skills_other?: string;
  available: string;
  team_preference?: string;
  team_other?: string;
  agreement?: number;
  created_at: string;
  event_name: string;
  start_date_time: string;
  end_date_time: string;
  status?: string;
}

const rows = ref<VolunteerApplication[]>([]);
const isModalOpen = ref(false);
const selectedRequest = ref<VolunteerApplication | null>(null);
let dataTable: any = null;
const fetchVolunteerApplications = async () => {
  try {
    const res = await axios.get("http://localhost:5000/api/myvolunteers", { withCredentials: true });

    const statusMap: Record<number, string> = {
      0: "Pending",
      1: "Approved",
      2: "Rejected",
    };

    rows.value = res.data.map((r: any) => ({
      ...r,
      status: statusMap[r.status] || "Pending", // fallback to Pending
    }));

    console.log(rows.value);

    // ✅ Wait for Vue to render, then initialize DataTable
    await nextTick();
    if (dataTable) {
      dataTable.destroy();
    }
    dataTable = $('#volunteerTable').DataTable({
      responsive: true,
      pageLength: 10,
      lengthChange: false,
      searching: true,
      dom: '<"table-header"f>tip',
    });
  } catch (error) {
    console.error("Error fetching volunteer applications:", error);
  }
};

const cards = computed(() => {
  const approved = rows.value.filter(r => r.status === "Approved").length;
  const rejected = rows.value.filter(r => r.status === "Rejected").length;
  const pending = rows.value.filter(r => r.status === "Pending").length;
  const total = rows.value.length;
  return [
    { key: "approved", label: "APPROVED", count: approved, icon: thumbsUp },
    { key: "rejected", label: "REJECTED", count: rejected, icon: thumbsDown },
    { key: "pending", label: "PENDING", count: pending, icon: ellipsisHorizontal },
    { key: "total", label: "TOTAL", count: total, icon: list },
  ];
});

function formatDate(iso: string) {
  const d = new Date(iso);
  return d.toLocaleDateString(undefined, { month: "short", day: "2-digit", year: "numeric" });
}

function formatDateTime(iso: string) {
  const d = new Date(iso);
  return d.toLocaleString(undefined, {
    month: "short",
    day: "2-digit",
    year: "numeric",
    hour: '2-digit',
    minute: '2-digit'
  });
}

async function onCancel(row: VolunteerApplication) {
  if (!row.volunteered_id) return;

  const result = await Swal.fire({
    title: 'Are you sure?',
    text: `Cancel volunteer application for "${row.event_name}"?`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, cancel it!',
    cancelButtonText: 'No',
    didOpen: () => {
      document.body.classList.remove('swal2-height-auto');
      document.documentElement.classList.remove('swal2-height-auto');
    }
  });

  if (result.isConfirmed) {
    try {

      await axios.delete(`http://localhost:5000/api/volunteers/${row.volunteered_id}`, { withCredentials: true });

      Swal.fire({ 
        title: 'Cancelled!', 
        text: 'Application cancelled.', 
        icon: 'success',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      }).then(() => {
        window.location.reload();
      });

    } catch (error) {
      console.error('❌ Delete request failed:', error);
      Swal.fire({ 
        title: 'Error!', 
        text: 'Failed to cancel.', 
        icon: 'error',
        didOpen: () => {
          document.body.classList.remove('swal2-height-auto');
          document.documentElement.classList.remove('swal2-height-auto');
        }
      });
    }
  }
}

function onView(row: VolunteerApplication) {
  selectedRequest.value = row;
  isModalOpen.value = true;
}
function closeModal() {
  isModalOpen.value = false;
}

onMounted(() => {
  fetchVolunteerApplications();
});
</script>



<style scoped>
.ion-page {
  max-width: 768px;
  margin: 0 auto;
  color: #000;
}
.form-container {
    margin-bottom: 150px !important;
}
ion-content {
  --background: #f6f6f6;
  padding: 20px;
}

#container {
  margin-top: 0;
  text-align: left;
  padding-bottom: 50px;
  padding-top: 30px !important;
  padding-left: 0;
  padding-right: 0;
}
.ion-page {
  max-width: 768px;
  margin: 0 auto;
  color: #000;
}

ion-content {
  --background: #f6f6f6;
  padding: 20px;
}

.header-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px;
  margin-bottom: 20px;
  position: relative;
}
.header-bottom ion-icon {
  color: #fff;
  font-weight: 700;
  position: relative;
}
.header-bottom ion-buttons {
    position: absolute;
    color: #fff;
}
.form-container {
  margin: 10px;
  border-radius: 5px;
  width: 100%;
}
.form-container ion-input {
    color: #fff;
    min-height: auto;
    border-radius: 0;
}
.form-container ion-label {
    margin-bottom: 10px;
}
.form-container ::v-deep(.native-wrapper) {
    height: 100%;
    padding: 8px 5px;
    background-color: #B4ACAC;
    margin-top: 5px;
}
.form-container ion-item {
    --inner-padding-end: 0px;
    border-radius: 0 !important;
}
.event-title {
  font-size: 23px;
  color: #ffff00;
  text-align: center;
  font-weight: 700;
}

.overview {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  margin-bottom: 14px;
  padding: 10px;
}
.card {
  background: #fff;
  border-radius: 12px;
  padding: 14px;
  box-shadow: 0 6px 18px rgba(0,0,0,0.08);
  text-align: center;
}
.card-icon { font-size: 26px; margin-bottom: 8px; display: inline-block; }
.card-icon.approved { color: #d4a017; }
.card-icon.rejected { color: #d4a017; }
.card-icon.pending  { color: #d4a017; }
.card-icon.total    { color: #d4a017; }
.card-label { font-weight: 700; font-size: 12px; letter-spacing: .6px; }
.card-num { font-weight: 800; margin-top: 6px; font-size: 20px; }

.section-title {
    background: #0f0e6a;
    color: #fff;
    font-weight: 600;
    text-align: center;
    padding: 8px 12px;
    border-radius: 0;
    margin: 8px 0 12px;
    border-top: 2px solid;
    border-bottom: 2px solid;
}
.search-wrap { display:flex; justify-content:flex-end; margin-bottom: 12px; }
.searchbar { width: 200px; --background: #fff; }
.searchbar input {
    padding-top: 0;
    padding-bottom: 0;
}
.table-wrap {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 6px 18px rgba(0,0,0,0.06);
}
.history-table {
  width: 100%;
  border-collapse: collapse;
}
.history-table thead { background: #0f0e6a; color: #fff; }
.history-table th, .history-table td {
  padding: 12px 10px; text-align: center; border-bottom: 1px solid #f2f2f6;
}
.left-col { text-align: left; padding-left: 14px; }
.actions-col { text-align: right; padding-right: 14px; }
.status-chip {
  padding: 6px 10px;
  border-radius: 999px;
  font-weight: 800;
  font-size: 12px;
}
.status-chip.approved { color: #0e7a3b; background: #e8f7ef; border: 1px solid #b9e6cd; }
.status-chip.rejected { color: #b3261e; background: #fdeaea; border: 1px solid #f7c4c2; }
.status-chip.pending  { color: #9c6b00; background: #fff6e0; border: 1px solid #ffe1a6; }
.no-results { text-align: center; padding: 20px; color: #999; }
.bottom-footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 6px;
  display: flex;
  flex-direction: column;
  align-items: center;
  pointer-events: none; /* allow inner links to be clickable */
}
.footer {
  position: sticky;
  bottom: 0;
  width: 100%;
  z-index: 100;
}

.footer-icons {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 10px 0;
  top: -32px;
  width: 100%;
  position: absolute;
}

.footer-icons ion-icon {
    color: #fff;
    cursor: pointer;
    padding: 5px;
    background: #08055e;
    border: 2px solid #fff;
    border-radius: 100%;
    width: 17px;
    height: 17px;
}
.table-wrap {
    background-color: transparent;
    padding: 10px;
}
#volunteerTable_wrapper .table-header {
  float: right;
  margin-bottom: 10px;
}
table {
    background-color: #fff;
}
.styled-table {
  border-collapse: separate;
  font-family: "Arial", sans-serif;
  font-size: 14px;
  margin-top: 10px;
  padding: 5px;
}

.styled-table thead tr {
  background-color: #07055d;
  text-align: left;
  font-weight: 600;
  color: #fff;
}

.styled-table tbody tr {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.08);
  transition: transform 0.2s ease;
}

.styled-table tbody tr:hover {
  transform: translateY(-2px);
}

.styled-table td {
  padding: 2px 4px;
  font-size: 13px;
  border: 1px solid #07055d;
  border-collapse: collapse;
}
.styled-table th{
    padding: 12px 0;
    text-align: center;
}
#absenceTable_info {
    color: #fff;
}
::v-deep(#volunteerTable_wrapper .table-header .dt-search) {
  text-align: right; 
  margin-bottom: 10px;
  ;
}
::v-deep(#volunteerTable_wrapper .table-header .dt-search label){
    color: #fff;
    margin-right: 5px;
}
::v-deep(#volunteerTable_wrapper .table-header .dt-search input) {
  border-radius: 5px;
  padding: 5px 10px;
  border: 1px solid #ccc;
  width: 220px;
  box-sizing: border-box;
}
::v-deep(#volunteerTable_wrapper .dt-info) {
    color: #fff;
    position: absolute;
    font-size: 12px;
    margin-top: 7px;
}
::v-deep(#volunteerTable_wrapper .dt-paging) {
    text-align: right;
    font-size: 20px;
    margin-top: 0px;

}
::v-deep(#volunteerTable_wrapper .dt-paging button) { 
    padding: 5px !important;
    font-size: 16px;
}
.bootstrap-modal .modal-dialog {
  width: 100%;
  height: 100%;
}

.bootstrap-modal .modal-content {
  border-radius: 0.5rem;
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
  background-color: #d9d9d9;
  height: 100%;
}

.bootstrap-modal .modal-header,
.bootstrap-modal .modal-footer {
  padding: 1rem;
  border-bottom: 1px solid #dee2e6;
}
.bootstrap-modal .modal-footer {
  position: absolute;
  bottom: 0;
  width: 100%;
}
.bootstrap-modal .modal-header {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  background: #07055d;
  color: #fff;
}

.bootstrap-modal .modal-title {
  margin: 0;
  font-size: 1.25rem;
}

.bootstrap-modal .btn-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
}

.bootstrap-modal .modal-body {
  padding: 1rem;
}

.bootstrap-modal .modal-footer {
  border-top: 1px solid #dee2e6;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
.bootstrap-modal ion-label{
  display: block;
  margin-bottom: 25px;
}
.bootstrap-modal ion-input {
  line-height: 0;
  background: #cdcaca;
  padding: 0 10px !important;
}
.bootstrap-modal ion-item{
    --inner-padding-end: 0px;
    --padding-start:0px
}
.bootstrap-modal {
  --height: 450px !important;
  padding: 10px;
}
.bootstrap-modal select {
  width: 100%;
  padding: 10px 5px;
  border: 0;
  background: #cdcaca;
}
@media (max-width: 520px) {
  .overview { grid-template-columns: repeat(4, 1fr); gap: 8px; }
  .card { padding: 10px; }
  .card-num { font-size: 16px; }
}
</style>
