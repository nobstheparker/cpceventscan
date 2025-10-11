<template>
  <ion-page>
    <IonHeader>
      <IonToolbar>
          <div class="logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
      </IonToolbar>
    </IonHeader>

    <IonContent>
      <div id="container">
        <h1>ATTENDANCE RECORDS</h1>


        <!-- ✅ Attendance Summary -->
        <div class="attendance-summary">
          <div class="summary-item">
            <h2>Total Events Attended</h2>
            <p>{{ totalAttended }}</p>
          </div>
          <div class="summary-item">
            <h2>Total Events Missed</h2>
            <p>{{ totalMissed }}</p>
          </div>
          <div class="summary-item">
            <h2>Missed Time In/Out</h2>
            <p>{{ missedTimeInOut }}</p>
          </div>
        </div>

        <h3>Event Attendance Log</h3>

        <!-- Event Attendance Log -->
        <div class="log-section">
          <div class="log-note">
            <p>
              Note: If your attendance status is marked as Unsettled, please
              proceed to the SAO Office to clarify your attendance issue.
            </p>
          </div>

          <div class="table-wrap">
            <table id="absenceTable" class="styled-table" style="width: 100%">
              <thead>
                <tr>
                  <th>Event Name</th>
                  <th>Date</th>
                  <th>Time In</th>
                  <th>Time Out</th>
                  <th>Remarks</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in eventLogs" :key="row.attendance_id">
                  <td>{{ row.eventName }}</td>
                  <td>{{ row.date }}</td>
                  <td>{{ formatTime(row.timeIn) }}</td>
                  <td>{{ formatTime(row.timeOut) }}</td>
                  <td>{{ row.remarks }}</td>
                  <td>
                    <span
                      class="status-chip"
                      :class="{
                        cleared: row.status === 'Cleared',
                        unsettled: row.status === 'Unsettled',
                      }"
                    >
                      {{ row.status }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </IonContent>

    <!-- Footer -->
    <div class="footer">
      <div class="footer-icons">
        <ion-icon name="home" @click="goToPage('/')"></ion-icon>
        <ion-icon name="calendar" @click="goToPage('/calendar-page')"></ion-icon>
        <ion-icon name="scan" @click="goToPage('/scanner')"></ion-icon>
        <ion-icon name="notifications" @click="goToPage('/notifications')"></ion-icon>
        <ion-icon name="person" @click="goToPage('/profile')" class="active"></ion-icon>
      </div>
      <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
    </div>
  </ion-page>
</template>

<script setup>
import {
  IonPage,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonText,
  IonIcon,
} from "@ionic/vue";
import axios from "axios";
import $ from "jquery";
import "datatables.net";
import { ref, onMounted, watch } from "vue";

const eventLogs = ref([]);
const totalAttended = ref(0);
const totalMissed = ref(0);
const missedTimeInOut = ref(0);

// ✅ Format time helper
function formatTime(datetime) {
  if (!datetime) return "-";
  const d = new Date(datetime);
  if (isNaN(d.getTime())) return "-";
  return d.toLocaleTimeString("en-US", {
    hour: "numeric",
    minute: "2-digit",
    hour12: true,
  });
}

// ✅ Init DataTable
const initDataTable = () => {
  if ($.fn.DataTable.isDataTable("#absenceTable")) {
    $("#absenceTable").DataTable().clear().destroy();
  }
  $("#absenceTable").DataTable({
    responsive: true,
    pageLength: 10,
    lengthChange: false,
    searching: true,
    destroy: true,
    dom: '<"table-header"f>tip',
  });
};

// ✅ Fetch attendance
onMounted(async () => {
  try {
    const response = await axios.get(
      "http://localhost:5000/api/attendance/me",
      { withCredentials: true }
    );

    let attended = 0;
    let missed = 0;
    let missedInOut = 0;

    eventLogs.value = response.data.map((r) => {
      let remarks = r.remarks || "";
      let status = r.status === 1 ? "Cleared" : "Unsettled";

      const now = new Date();

      // Parse event date (like "Sep 29, 2025")
      const eventDate = r.date ? new Date(r.date) : null;

      // Consider event ended if today is after the event date
      const eventEnded = eventDate ? now > eventDate : false;

      if (r.timeIn && r.timeOut) {
        // ✅ Fully attended
        remarks = "Present";
        status = "Cleared";
        attended++;
      } 
      else if (r.timeIn || r.timeOut) {
        // ✅ Partial attendance
        remarks = "Incomplete";
        status = "Unsettled";
        attended++;

        if (eventEnded) {
          missedInOut++;
        }
      } 
      else if (!r.timeIn && !r.timeOut) {
        // ❌ Absent
        remarks = "Absent";
        status = "Unsettled";

        if (eventEnded) {
          missed++;
        }
      }

      return { ...r, remarks, status };
    });

    totalAttended.value = attended;
    totalMissed.value = missed;
    missedTimeInOut.value = missedInOut;
  } catch (err) {
    console.error("Error fetching attendance:", err);
  }
});

watch(eventLogs, (newVal) => {
  if (newVal.length > 0) {
    setTimeout(() => initDataTable(), 0);
  }
});

function goToPage(path) {
  window.location.href = path; // force reload
}
</script>

<style scoped>
#container { 
  text-align: left; 
  height: max-content; 
  display: block; 
  padding: 10px 0 !important; 
  color: #fff; 
  padding-bottom: 300px !important; 
}

h1 {
  color: yellow;
  text-align: center;
  font-weight: 700;
}

h3 {
  text-align: center;
  background-color: #08055e;
  border-top: 2px solid #fff;
  border-bottom: 2px solid #fff;
  padding: 10px;
  font-size: 20px;
}

.attendance-summary {
  display: flex;
  justify-content: space-around;
  margin: 20px 0;
  padding: 0 10px;
}

.summary-item {
  text-align: center;
}

.summary-item h2 {
  font-size: 13px;
  color: #fff;
}

.summary-item p {
  background-color: #D9D9D9;
  font-size: 40px;
  font-weight: bold;
  color: #08055e;
  margin: 0 5px;
  padding: 15px !important;
}

.styled-table {
  width: 100%;
  margin-top: 20px;
  border-collapse: collapse;
}

.styled-table th, .styled-table td {
  padding: 10px;
  border: 1px solid #ddd;
  text-align: center;
}

.styled-table th {
  background-color: #0f0e6a;
  color: #fff;
}

.styled-table td {
  background-color: #f4f4f4;
}

.styled-table td span.status-chip {
  padding: 6px 10px;
  border-radius: 5px;
  font-weight: 700;
}

.styled-table .cleared {
  color: #0e7a3b;
  background: #e8f7ef;
  border: 1px solid #b9e6cd;
}

.styled-table .unsettled {
  color: #b3261e;
  background: #fdeaea;
  border: 1px solid #f7c4c2;
}

.log-note {
  font-size: 14px;
  color: #fff;
  margin-bottom: 10px;
  padding: 0 10px;
}

.footer { 
  position: fixed; 
  bottom: 0; 
  width: 100%; 
  z-index: 100; 
}

.footer-icons { 
  display: flex; 
  justify-content: space-around; 
  align-items: center; 
  padding: 10px 0; 
  top: -28px; 
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
#absenceTable_wrapper .table-header {
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
.dt-empty {
    color: #000 !important;
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
    color: black;
}
.styled-table th{
    padding: 12px 0;
    text-align: center;
    font-size: 12px;
}
#absenceTable_info {
    color: #fff;
}
::v-deep(#absenceTable_wrapper .table-header .dt-search) {
  text-align: right; 
  margin-bottom: 10px;
  ;
}
::v-deep(#absenceTable_wrapper .table-header .dt-search label){
    color: #fff;
    margin-right: 5px;
}
::v-deep(#absenceTable_wrapper .table-header .dt-search input) {
  border-radius: 5px;
  padding: 5px 10px;
  border: 1px solid #ccc;
  width: 220px;
  box-sizing: border-box;
  color: #000;
}
::v-deep(#absenceTable_wrapper .dt-info) {
    color: #fff;
    position: absolute;
    font-size: 12px;
    margin-top: 7px;
}
::v-deep(#absenceTable_wrapper .dt-paging) {
    text-align: right;
    font-size: 20px;
    margin-top: 0px;

}
::v-deep(#absenceTable_wrapper .dt-paging button) { 
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
