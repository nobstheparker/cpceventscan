<template>
  <ion-page>
    <!-- Header -->
    <ion-header>
      <ion-toolbar>
        <div class="logo">
          <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
        </div>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <div id="container">
        <div v-if="eventData">
          <!-- Welcome Section -->
          <h2 class="welcome-text">
            Welcome to <span class="event-name"><b>{{ eventData.event_name }}!</b></span>
          </h2>
          <p class="desc">Please click the buttons below to record your attendance and participate in the event.</p>
          <p class="display-none"><strong>Location:</strong> {{ studentLocationText }}</p>

          <!-- Attendance Buttons Section -->
          <div class="attendance-section">
            <!-- Morning -->
            <h3>Morning</h3>
            <div class="buttons-row">
              <ion-button
                class="attendance-btn"
                :disabled="
                  loadingAttendance ||
                  studentAttendance?.morning_time_in ||
                  attendanceControls?.settings?.morning_time_in === 0
                "
                :color="studentAttendance?.morning_time_in ? 'success' : 'primary'"
                @click="handleAction('morning_timein')"
              >
                {{
                  studentAttendance?.morning_time_in
                    ? `Time In: ${new Date(studentAttendance.morning_time_in).toLocaleTimeString('en-US', {
                        hour: 'numeric',
                        minute: '2-digit',
                      })}`
                    : 'Time In'
                }}
              </ion-button>
             <ion-button
                class="attendance-btn"
                :disabled="
                  loadingAttendance ||
                  studentAttendance?.morning_trivia_time_in === '1899-12-31T16:00:00.000Z' || 
                  (studentAttendance?.morning_trivia_time_in && studentAttendance.morning_trivia_time_in !== '1899-12-31T16:00:00.000Z') ||
                  attendanceControls?.settings?.morning_mid_event === 0
                "
                :color="studentAttendance?.morning_trivia_time_in && studentAttendance.morning_trivia_time_in !== '1899-12-31T16:00:00.000Z' ? 'success' : 'secondary'"
                @click="handleTrivia('morning')"
              >
                {{
                  studentAttendance?.morning_trivia_time_in === '1899-12-31T16:00:00.000Z'
                    ? 'Missed'
                    : studentAttendance?.morning_trivia_time_in
                    ? `Trivia: ${new Date(studentAttendance.morning_trivia_time_in).toLocaleTimeString('en-US', {
                        hour: 'numeric',
                        minute: '2-digit',
                      })}`
                    : 'Trivia'
                }}
              </ion-button>

              <ion-button
                class="attendance-btn"
                :disabled="
                  loadingAttendance ||
                  !studentAttendance?.morning_time_in ||
                  studentAttendance?.morning_time_out ||
                  attendanceControls?.settings?.morning_time_out === 0
                "
                :color="studentAttendance?.morning_time_out ? 'success' : 'danger'"
                @click="handleAction('morning_timeout')"
              >
                {{
                  studentAttendance?.morning_time_out
                    ? `Time Out: ${new Date(studentAttendance.morning_time_out).toLocaleTimeString('en-US', {
                        hour: 'numeric',
                        minute: '2-digit',
                      })}`
                    : 'Time Out'
                }}
              </ion-button>
            </div>

            <!-- Afternoon -->
            <h3>Afternoon</h3>
            <div class="buttons-row">
              <ion-button
                class="attendance-btn"
                :disabled="
                  loadingAttendance ||
                  studentAttendance?.afternoon_time_in ||
                  attendanceControls?.settings?.afternoon_time_in === 0
                "
                :color="studentAttendance?.afternoon_time_in ? 'success' : 'primary'"
                @click="handleAction('afternoon_timein')"
              >
                {{
                  studentAttendance?.afternoon_time_in
                    ? `Time In: ${new Date(studentAttendance.afternoon_time_in).toLocaleTimeString('en-US', {
                        hour: 'numeric',
                        minute: '2-digit',
                      })}`
                    : 'Time In'
                }}
              </ion-button>

              <ion-button
              class="attendance-btn"
              :disabled="
                loadingAttendance ||
                studentAttendance?.afternoon_trivia_time_in === '1899-12-31T16:00:00.000Z' || 
                (studentAttendance?.afternoon_trivia_time_in && studentAttendance.afternoon_trivia_time_in !== '1899-12-31T16:00:00.000Z') ||
                attendanceControls?.settings?.afternoon_mid_event === 0
              "
              :color="studentAttendance?.afternoon_trivia_time_in && studentAttendance.afternoon_trivia_time_in !== '1899-12-31T16:00:00.000Z' ? 'success' : 'secondary'"
              @click="handleTrivia('afternoon')"
            >
              {{
                studentAttendance?.afternoon_trivia_time_in === '1899-12-31T16:00:00.000Z'
                  ? 'Missed'
                  : studentAttendance?.afternoon_trivia_time_in
                  ? `Trivia: ${new Date(studentAttendance.afternoon_trivia_time_in).toLocaleTimeString('en-US', {
                      hour: 'numeric',
                      minute: '2-digit',
                    })}`
                  : 'Trivia'
              }}
            </ion-button>

              <ion-button
                class="attendance-btn"
                :disabled="
                  loadingAttendance ||
                  !studentAttendance?.afternoon_time_in ||
                  studentAttendance?.afternoon_time_out ||
                  attendanceControls?.settings?.afternoon_time_out === 0
                "
                :color="studentAttendance?.afternoon_time_out ? 'success' : 'danger'"
                @click="handleAction('afternoon_timeout')"
              >
                {{
                  studentAttendance?.afternoon_time_out
                    ? `Time Out: ${new Date(studentAttendance.afternoon_time_out).toLocaleTimeString('en-US', {
                        hour: 'numeric',
                        minute: '2-digit',
                      })}`
                    : 'Time Out'
                }}
              </ion-button>
            </div>

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
            <ion-card-content v-if="eventData">
              <ul>
                <li>{{ eventData.event_reminder }}</li>
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
              <ion-button
                  @click="submitFeedback"
                  :disabled="
                    hasSubmitted ||
                    loadingAttendance ||
                    studentAttendance?.feedback_form ||
                    attendanceControls?.settings?.feedback_form === 0
                  "
                  expand="block"
                  color="warning"
                >
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
        <ion-icon name="home" @click="goToPage('/')"></ion-icon>
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
import axios from "axios";
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import Swal from "sweetalert2";
import {
  IonButton,
  IonCard, IonCardContent, IonCardHeader, IonCardTitle,
  IonContent,
  IonHeader,
  IonIcon,
  IonPage,
  IonText,
  IonTextarea,
  IonToolbar
} from '@ionic/vue';

const route = useRoute();
const eventId = parseInt(route.query.event);
const eventData = ref(null);
const feedback = ref(''); 
const studentAttendance = ref(null);
const loadingAttendance = ref(true);
const studentLocationText = ref("Fetching location...");
const attendanceControls = ref(null); // ✅ store control data here

const student = JSON.parse(localStorage.getItem("student"));
const studentId = student?.student_id;

const goToPage = (path) => {
  window.location.href = path;
};

// Distance helper
function getDistanceFromLatLon(lat1, lon1, lat2, lon2) {
  const R = 6371000; // meters
  const φ1 = lat1 * Math.PI / 180;
  const φ2 = lat2 * Math.PI / 180;
  const Δφ = (lat2 - lat1) * Math.PI / 180;
  const Δλ = (lon2 - lon1) * Math.PI / 180;

  const a =
    Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) *
    Math.sin(Δλ / 2) * Math.sin(Δλ / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return Math.round(R * c);
}

// ✅ Fetch Attendance Controls
const fetchAttendanceControls = async () => {
  try {
    const res = await fetch(`http://localhost:5000/api/attendance/controls/${eventId}`, {
      credentials: "include",
    });

    if (!res.ok) throw new Error("Failed to fetch attendance controls");

    const data = await res.json();
    attendanceControls.value = data.attendanceControls[0]; // usually one per event
  } catch (err) {
    console.error("Error fetching attendance controls:", err.message);
  }
};


// Fetch latest attendance
const fetchAttendance = async () => {
  loadingAttendance.value = true;

  try {
    const res = await fetch(
      `http://localhost:5000/api/attendance/${eventId}/check/`,
      { credentials: "include" }
    );
    const data = await res.json();
    const att = data.attendance || {};

    studentAttendance.value = {
      morning_time_in: att.time_in,
      morning_trivia_time_in: att.trivia_time_in,
      morning_time_out: att.time_out,
      afternoon_time_in: att.afternoon_time_in,
      afternoon_trivia_time_in: att.afternoon_trivia_time_in,
      afternoon_time_out: att.afternoon_time_out,
    };

    // 🔹 Check DB values only (no localStorage)
    if (
      att.trivia_time_in === "1899-12-31T16:00:00.000Z" ||
      att.afternoon_trivia_time_in === "1899-12-31T16:00:00.000Z"
    ) {
      hasSubmitted.value = true;
    }
  } catch (err) {
    console.error("❌ Error fetching attendance:", err);
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
        },
      });
    },
    { enableHighAccuracy: true }
  );
};

// On mount
onMounted(async () => {
  try {
    const resEvents = await fetch("http://localhost:5000/api/events/list", {
      credentials: "include",
    });
    const events = await resEvents.json();
    eventData.value = events.find((e) => e.id === eventId);
    if (!eventData.value) throw new Error("Event not found");

    await fetchAttendanceControls(); // ✅ fetch control data
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
      },
    });
  }
});

// Handle TimeIn / TimeOut click with live location
const handleAction = async (action) => {
  if (!navigator.geolocation) {
    Swal.fire({ icon: "error", title: "Location not supported" });
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (pos) => {
      const { latitude, longitude } = pos.coords;

      const eventLat = parseFloat(eventData.value.latitude);
      const eventLon = parseFloat(eventData.value.longitude);
      const distance = getDistanceFromLatLon(latitude, longitude, eventLat, eventLon);

      console.log("📍 Event Location:", eventLat, eventLon);
      console.log("📱 Student Location:", latitude, longitude);
      console.log("📏 Calculated Distance (meters):", distance);

      // ⚙️ Set allowed radius
      const allowedRadius = 700;

      if (distance > allowedRadius) {
        const diff = Math.round(distance - allowedRadius); // how far beyond the limit

        Swal.fire({
          icon: "error",
          title: "Too Far from Event",
          text: `You are ${diff} meters away from the allowed area.`,
          didOpen: () => {
            document.body.classList.remove("swal2-height-auto");
            document.documentElement.classList.remove("swal2-height-auto");
          },
        });
        return;
      }

      // ✅ Proceed if within allowed distance
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
        },
      });
    },
    { enableHighAccuracy: true }
  );
};

// Trivia popup
const handleTrivia = async (period) => {
  try {
    const res = await axios.get(`http://localhost:5000/api/trivia/${eventId}/${period}`);
    const triviaList = res.data.trivia;

    if (!triviaList || triviaList.length === 0) {
      Swal.fire({
        icon: "info",
        title: "No Trivia Available",
        text: `No trivia found for ${period} period.`,
        heightAuto: false,
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        },
      });
      return;
    }

    // 🎯 Pick a random trivia
    const randomTrivia = triviaList[Math.floor(Math.random() * triviaList.length)];

    const { value: userAnswer } = await Swal.fire({
      title: "Trivia Question",
      text: randomTrivia.question,
      input: "radio",
      inputOptions: {
        [randomTrivia.option1]: randomTrivia.option1,
        [randomTrivia.option2]: randomTrivia.option2,
      },
      confirmButtonText: "Submit",
      inputValidator: (value) => {
        if (!value) return "You must choose an answer.";
      },
      allowOutsideClick: false,
      heightAuto: false,
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });

    // ✅ Correct answer
    if (userAnswer === randomTrivia.correct_answer) {
      Swal.fire({
        icon: "success",
        title: "Correct!",
        text: "Proceeding to face verification...",
        timer: 1200,
        showConfirmButton: false,
        heightAuto: false,
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        },
      });

      // Remove missed status if previously failed
      localStorage.removeItem(`trivia_missed_${studentId}_${eventId}_${period}`);

      handleAction(`${period}_trivia`);
    } 
    else {
      await axios.put(`http://localhost:5000/api/attendance/mark-trivia-missed/${eventId}`, {
        studentId,
        period,
      });

      Swal.fire({
        icon: "error",
        title: "Incorrect!",
        text: "You have missed the trivia for this period.",
        allowOutsideClick: false,
        heightAuto: false,
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        },
         }).then(() => {
        window.location.reload();
      });
    }
  } catch (err) {
    console.error("❌ Trivia fetch error:", err);
    Swal.fire({
      icon: "error",
      title: "Error Fetching Trivia",
      text: "Unable to load trivia questions for this period.",
      heightAuto: false,
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });
  }
};

const hasSubmitted = ref(false);

const submitFeedback = async () => {
  if (!feedback.value.trim()) {
    Swal.fire({
      icon: "warning",
      title: "Please enter feedback",
      confirmButtonText: "OK",
      heightAuto: false,
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });
    return;
  }

  try {
    const response = await axios.post("http://localhost:5000/api/feedback/add", {
      student_id: studentId,
      event_id: eventId,
      notes: feedback.value,
    });

    console.log("🧾 Feedback response:", response.data);

    if (response.data.success) {
      Swal.fire({
        icon: "success",
        title: "Thank you!",
        text: "Your feedback has been submitted successfully.",
        heightAuto: false,
        confirmButtonText: "OK",
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        },
      });
      feedback.value = "";
      hasSubmitted.value = true;
    } else {
      Swal.fire({
        icon: "info",
        title: "Already Submitted",
        text: response.data.error || "You have already submitted feedback for this event.",
        heightAuto: false,
        confirmButtonText: "OK",
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        },
      });
      hasSubmitted.value = true;
    }
  } catch (error) {
    console.error("🚨 Axios error:", error);

    // Handle 400 from backend (duplicate feedback)
    if (error.response && error.response.status === 400) {
      Swal.fire({
        icon: "info",
        title: "Already Submitted",
        text: error.response.data.error || "You have already submitted feedback for this event.",
        heightAuto: false,
        confirmButtonText: "OK",
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        },
      });
      hasSubmitted.value = true;
      return;
    }

    Swal.fire({
      icon: "error",
      title: "Network Error",
      text: "Unable to connect to the server.",
      heightAuto: false,
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });
  }
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
  --ion-color-base: #325255 !important; 
}
.attendance-section h3 {
  background: #08055d;
  padding: 5px;
  font-size: 18px;
  text-align: center;
  text-transform: uppercase;
  border-top: 2px solid;
  border-bottom: solid;
}
.buttons-row ion-button { --ion-color-contrast: #fff !important; }
.footer { position: fixed; bottom: 0; width: 100%; z-index: 100; }
.footer-icons { display: flex; justify-content: space-around; align-items: center; padding: 10px 0; top: -28px; width: 100%; position: absolute; }
.footer-icons ion-icon { color: #fff; cursor: pointer; padding: 5px; background: #08055e; border: 2px solid #fff; border-radius: 100%; width: 17px; height: 17px; }
</style>
