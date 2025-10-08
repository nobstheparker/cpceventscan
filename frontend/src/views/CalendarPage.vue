<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-title>
          <div class="logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
        </ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <div id="container">
        <h1>CORDOVA PUBLIC COLLEGE SCHOOL ACTIVITIES</h1>
        <div class="form-container row">
          <ion-grid>
            <ion-row class="top-title">
              <ion-col size="4" class="col-4 ">
                <h4>Date</h4>
              </ion-col>
              <ion-col size="8">
                <h4>Activity</h4>
              </ion-col>
            </ion-row>

            <ion-row class="content" v-for="(event, index) in events" :key="index">
              <ion-col size="4" class="col-4 ">
                <div class="date">
                  <h5>DATE</h5>
                </div>
                <div class="day">
                  <h2>{{ event.dateRange }}</h2>
                </div>
              </ion-col>
              <ion-col size="8">
                <p>{{ event.description }}</p>
              </ion-col>
            </ion-row>
          </ion-grid>
          <div class="footer-bottom"></div>
        </div>
      </div>

      <div class="footer">
        <div class="footer-icons">
          <router-link to="/"><ion-icon name="home"></ion-icon></router-link>
          <router-link to="/calendar-page"><ion-icon name="calendar" class="active"></ion-icon></router-link>
          <router-link to="/scanner"><ion-icon name="scan"></ion-icon></router-link>
          <router-link to="/notifications"><ion-icon name="notifications"></ion-icon></router-link>
          <router-link to="/profile"><ion-icon name="person"></ion-icon></router-link>
        </div>
        <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
      </div>
    </ion-content>
  </ion-page>
</template>
<script setup lang="ts">
import {
  IonPage,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonText,
  IonCol,
  IonRow,
  IonGrid,
} from '@ionic/vue';
import axios from 'axios';
import { ref, onMounted } from 'vue';

const events = ref<any[]>([]);

const formatEventDateRange = (startDate: string, endDate: string) => {
  const start = new Date(startDate);
  const end = new Date(endDate);

  const monthFormatter = new Intl.DateTimeFormat('en-US', { month: 'long' });
  const month = monthFormatter.format(start);
  const startDay = start.getDate();
  const endDay = end.getDate();

  return `${month} ${startDay}-${endDay}`;
};

const fetchEvents = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/events/list');
    events.value = response.data.map((event: any) => ({
      dateRange: formatEventDateRange(event.start_date_time, event.end_date_time),
      description: event.event_description || event.eventName,
    }));
  } catch (error) {
    console.error('Failed to fetch events:', error);
  }
};

onMounted(() => {
  fetchEvents();
});
</script>

<style scoped>
.ion-page {
  max-width: 768px;
  margin: 0 auto;
  color: #000;
}

ion-content {
  --background: #f6f6f6;
  padding: 20px;
}

#container {
  margin-top: 0;
  text-align: left;
  padding-bottom: 200px;
  padding-top: 0px !important;
  padding-left: 0 !important;
  padding-right: 0 !important;
  display: block;
  height: max-content;
}

.form-container {
  background: #08055e;
  border-radius: 5px;
  width: 100%;
}
ion-grid {
  padding: 0 !important;
}
ion-grid ion-row.top-title {
  background: #08055e;
  border-top: 5px solid #fff;
  border-bottom: 5px solid #fff;
  margin: 10px 0;
  padding: 0 !important;
}
ion-grid h4 {
  color: #fff;
  margin: 0 !important;
  text-align: center;
  text-transform: uppercase;
  font-weight: 700;
}
.form-container ion-input {
    color: #fff;
    min-height: auto;
    border-radius: 0;
}
ion-grid ion-col.col-4 {
  border-right: 5px solid #fff;
}
ion-grid ion-row.content ion-col.col-4 {
  border-right: 5px solid #07055D;
}
ion-grid ion-row.content {
  background-color: #fff;
  align-items: center;
  margin-bottom: 5px;
}
ion-grid ion-row.content .date {
  text-align: center;
  background: #08055e;
  padding: 1px;
  color: #fff;
}
ion-grid ion-row .date h5{
  font-weight: 600;
  margin: 10px 0;
}
ion-grid ion-row.content .day {
  background: #B4ACAC;
  text-align: center;
  color: #07055D;
}
ion-grid ion-row.content .day h2 {
  margin: 0 !important;
  font-size: 14px;
  padding: 10px 0;
}
ion-grid ion-row.content p{
  margin: 0;
  padding: 0;
  padding-left: 10px;
  font-size: 15px;
  font-weight: 699;
  color: #08055e;
  line-height: 1.5rem;
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

ion-icon.active {
    width: 24px;
    height: 24px;
    color: yellow;
}
h1 {
    font-weight: 700;
    text-align: center;
    color: yellow;
    padding: 30px 0 !important;
    margin: 0;
}
ion-text {
  margin: 10px 0;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px;
  font-size: 14px;
}
</style>