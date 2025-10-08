<template>
  <ion-page>
    <!-- Header -->
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
        <div v-if="eventData">
          <!-- Welcome Section -->
          <h2 class="welcome-text">
            Welcome to <span class="event-name"><bold>{{ eventData.event_name }}!</bold></span>
          </h2>
          <p class="desc"> Please click the buttons below to record your attendance and participate in the event.</p>
          <p class="display-none"><strong>Location:</strong> {{ studentLocationText }}</p>

          <!-- Buttons Row -->
          <div class="buttons-row">
            <!-- Time In -->
            <ion-button
              class="attendance-btn"
              :disabled="loadingAttendance || studentAttendance?.time_in"
              :color="studentAttendance?.time_in ? 'success' : 'primary'"
              @click="handleAction('timein')"
            >
              <template v-if="loadingAttendance">Checking...</template>
              <template v-else>
                {{ studentAttendance?.time_in
                  ? `Time In: ${new Date(studentAttendance.time_in).toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })}`
                  : 'Time In' }}
              </template>
            </ion-button>

            <!-- Trivia -->
            <ion-button
              class="attendance-btn"
              :disabled="loadingAttendance || studentAttendance?.trivia_time_in"
              :color="studentAttendance?.trivia_time_in ? 'success' : 'secondary'"
              @click="handleTrivia"
            >
              {{ studentAttendance?.trivia_time_in
                ? `Trivia In: ${new Date(studentAttendance.trivia_time_in).toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })}`
                : 'Trivia Time In' }}
            </ion-button>

            <!-- Time Out -->
            <ion-button
              class="attendance-btn"
              :disabled="loadingAttendance || !studentAttendance?.time_in || studentAttendance?.time_out"
              :color="studentAttendance?.time_out ? 'success' : 'danger'"
              @click="handleAction('timeout')"
            >
              {{ studentAttendance?.time_out
                ? `Time Out: ${new Date(studentAttendance.time_out).toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })}`
                : 'Time Out' }}
            </ion-button>
          </div>

          <!-- Program Section -->
          <ion-card>
            <ion-card-header>
              <ion-card-title>Program Details & Itinerary</ion-card-title>
            </ion-card-header>
            <ion-card-content>
              <img
                :src="`http://localhost:5000/${eventData.event_program_attachment}`"
                alt="Program Itinerary"
                class="program-img"
              />
            </ion-card-content>
          </ion-card>

          <!-- Reminders -->
          <ion-card>
            <ion-card-header>
              <ion-card-title>Reminders</ion-card-title>
            </ion-card-header>
            <ion-card-content>
              <ul>
                <li>Please arrive on time.</li>
                <li>Bring your ID.</li>
                <li>Respect event rules.</li>
              </ul>
            </ion-card-content>
          </ion-card>

          <!-- Feedback -->
          <ion-card>
            <ion-card-header>
              <ion-card-title class="feedback-heading">Feedback</ion-card-title>
            </ion-card-header>
            <ion-card-content>
              <ion-textarea
                v-model="feedback"
                placeholder="Write your feedback here..."
                auto-grow
              ></ion-textarea>
              <ion-button expand="block" color="warning" @click="submitFeedback">
                Submit Feedback
              </ion-button>
            </ion-card-content>
          </ion-card>
        </div>

        <div v-else>
          <ion-spinner name="dots" />
          <p>Loading event data...</p>
        </div>
      </div>
    </ion-content>

    <!-- Footer -->
    <div class="footer">
        <div class="footer-icons">
            <ion-icon name="home"@click="goToPage('/')"></ion-icon>
            <ion-icon name="calendar" @click="goToPage('/calendar-page')"></ion-icon>
            <ion-icon name="scan" @click="goToPage('/scanner')"></ion-icon>
            <ion-icon name="notifications" @click="goToPage('/notifications')"></ion-icon>
            <ion-icon name="person" @click="goToPage('/profile')"></ion-icon>
        </div>

      <ion-text><small>&copy; All Rights Reserved PPG 2025.</small></ion-text>
    </div>
  </ion-page>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import Swal from "sweetalert2";

const route = useRoute();
const eventId = parseInt(route.query.event);
const eventData = ref(null);
const feedback = ref("");
const studentAttendance = ref(null);
const loadingAttendance = ref(true);
const studentLocationText = ref("Fetching location...");
const goToPage = (path) => {
  window.location.href = path; // reloads page
};

const student = JSON.parse(localStorage.getItem("student"));
const studentId = student?.student_id;

// Distance helper
function getDistanceFromLatLon(lat1, lon1, lat2, lon2) {
  const R = 6371000;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) ** 2;
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Fetch latest attendance from API
const fetchAttendance = async () => {
  loadingAttendance.value = true;
  try {
    const res = await fetch(`http://localhost:5000/api/attendance/${eventId}/check`, { credentials: "include" });
    const data = await res.json();
    studentAttendance.value = data.attendance || null;
  } catch (err) {
    console.error(err);
  } finally {
    loadingAttendance.value = false;
  }
};

// Fetch student location
const fetchLocation = () => {
  if (!navigator.geolocation) {
    studentLocationText.value = "Location not supported";
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (pos) => {
      const { latitude, longitude } = pos.coords;
      studentLocationText.value = `Lat: ${latitude.toFixed(5)}, Lon: ${longitude.toFixed(5)}`;
    },
    (err) => {
      studentLocationText.value = "Unable to get location";
      Swal.fire({
        icon: "error",
        title: "Location Error",
        text: err.message,
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        }
      });
    },
    { enableHighAccuracy: true }
  );
};

// Fetch event data
onMounted(async () => {
  try {
    const resEvents = await fetch("http://localhost:5000/api/events/list", { credentials: "include" });
    const events = await resEvents.json();
    eventData.value = events.find((e) => e.id === eventId);
    if (!eventData.value) throw new Error("Event not found");

    await fetchAttendance();
    fetchLocation();
  } catch (err) {
    Swal.fire({
      icon: "error",
      title: "Error",
      text: err.message,
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
  }
});

// Handle TimeIn / TimeOut click with live location
const handleAction = (action) => {
  if (!navigator.geolocation) {
    Swal.fire({ icon: "error", title: "Location not supported", didOpen: () => {
      document.body.classList.remove("swal2-height-auto");
      document.documentElement.classList.remove("swal2-height-auto");
    }});
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (pos) => {
      const { latitude, longitude } = pos.coords;
      studentLocationText.value = `Lat: ${latitude.toFixed(5)}, Lon: ${longitude.toFixed(5)}`;

      const distance = getDistanceFromLatLon(
        latitude,
        longitude,
        parseFloat(eventData.value.latitude),
        parseFloat(eventData.value.longitude)
      );

      if (distance > 800) {
        Swal.fire({
          icon: "error",
          title: "Too Far from Event",
          text: `You are ${Math.round(distance)} meters away.`,
          didOpen: () => {
            document.body.classList.remove("swal2-height-auto");
            document.documentElement.classList.remove("swal2-height-auto");
          }
        });
        return;
      }

      window.location.href = `http://localhost:8100/face-verification?event=${eventId}&action=${action}`;
    },
    (err) => {
      Swal.fire({
        icon: "error",
        title: "Location Error",
        text: err.message,
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        }
      });
    },
    { enableHighAccuracy: true }
  );
};

// Trivia popup
const handleTrivia = async () => {
  const a = Math.floor(Math.random() * 10) + 1;
  const b = Math.floor(Math.random() * 10) + 1;
  const correctAnswer = a + b;

  const { value: userAnswer } = await Swal.fire({
    title: `Trivia Question`,
    text: `What is ${a} + ${b}?`,
    input: 'number',
    inputPlaceholder: 'Enter your answer',
    showCancelButton: false,
    confirmButtonText: 'Submit',
    allowOutsideClick: false,
    didOpen: () => {
      document.body.classList.remove("swal2-height-auto");
      document.documentElement.classList.remove("swal2-height-auto");
    }
  });

  if (parseInt(userAnswer) === correctAnswer) {
    Swal.fire({
      icon: 'success',
      title: 'Correct!',
      text: 'Proceeding to face verification...',
      timer: 1200,
      showConfirmButton: false,
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
    handleAction("trivia");
  } else {
    Swal.fire({
      icon: 'error',
      title: 'Incorrect!',
      text: 'Please try again.',
      allowOutsideClick: false,
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    }).then(() => handleTrivia());
  }
};

// Submit Feedback
const submitFeedback = () => {
  if (!feedback.value.trim()) {
    Swal.fire({
      icon: "warning",
      title: "Empty Feedback",
      text: "Please enter feedback.",
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      }
    });
    return;
  }
  Swal.fire({
    icon: "success",
    title: "Thank You!",
    text: "Feedback submitted.",
    didOpen: () => {
      document.body.classList.remove("swal2-height-auto");
      document.documentElement.classList.remove("swal2-height-auto");
    }
  });
  feedback.value = "";
};
</script>

<style scoped>
ion-content { --background: #f6f6f6; padding: 20px; }
#container { text-align: left; padding-bottom: 20px; height: max-content; display: block; padding: 10px !important; color: #fff; padding-bottom: 300px !important; }
.welcome-text { padding-top: 15px; margin-top: 0 !important; text-align: center; font-size: 38px; font-weight: 700;}
h2 bold { color: #ffff00; }
.program-img { width: 100%; border-radius: 8px; }
.feedback-heading { color: #fbc02d; }
.buttons-row { display: flex; gap: 10px; margin-bottom: 20px; }
.display-none { display: none; }
.desc { text-align: center; font-size: 12px;}
.attendance-btn { flex: 1; }
.attendance-btn.button-disabled {
  opacity: 1;       
  cursor: not-allowed;
  pointer-events: none; 
  --ion-color-base: #037410 !important; 
}

.buttons-row ion-button { --ion-color-contrast: #fff !important; }
.footer { position: fixed; bottom: 0; width: 100%; z-index: 100; }
.footer-icons { display: flex; justify-content: space-around; align-items: center; padding: 10px 0; top: -28px; width: 100%; position: absolute; }
.footer-icons ion-icon { color: #fff; cursor: pointer; padding: 5px; background: #08055e; border: 2px solid #fff; border-radius: 100%; width: 17px; height: 17px; }
</style>
