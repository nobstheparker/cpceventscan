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

    <ion-content
      class="fixed-content"
      :scrollY="false"
      :scrollAssist="false"
      :keyboard-attach="false"
      keyboard-resize="none"
    >
      <div id="container">
        <h2>Check Your Email</h2>
        <p class="notes">
          Please enter the 6-digit code we sent to
          <strong>{{ maskedEmail || "your email" }}</strong>.
        </p>

        <div class="input-wrapper">
          <ion-input
            v-model="code"
            placeholder="Enter your code"
            maxlength="6"
            inputmode="numeric"
            type="text"
            class="input"
          ></ion-input>
        </div>

        <ion-button
          @click="verifyCode"
          :disabled="loading || !code"
        >
          <ion-spinner v-if="loading" name="crescent"></ion-spinner>
          <span v-else>Continue</span>
        </ion-button>

        <p class="resend-text">
          Didn’t get a code?
          <ion-button
            fill="clear"
            size="small"
            @click="resendCode"
            :disabled="resending || countdown > 0"
          >
            <ion-spinner
              v-if="resending"
              name="dots"
              style="width: 16px; height: 16px"
            ></ion-spinner>
            <span v-else>
              Resend Code
              <span v-if="countdown > 0">({{ countdown }}s)</span>
            </span>
          </ion-button>
        </p>
      </div>
    </ion-content>

    <div class="footer">
      <ion-text>
        <small>&copy; All Rights Reserved PPG 2025.</small>
      </ion-text>
    </div>
  </ion-page>
</template>

<script setup>
import Swal from "sweetalert2";
import {
  IonPage,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonButton,
  IonInput,
  IonText,
  IonSpinner,
} from "@ionic/vue";
import { ref, onMounted } from "vue";
import axios from "axios";
import { useRouter } from "vue-router";

const router = useRouter();
const code = ref("");
const maskedEmail = ref("");
const studentId = ref("");
const loading = ref(false);
const resending = ref(false);
const countdown = ref(0);
let timer = null;

/**
 * Mask email like "o****pad@gmail.com"
 */
function maskEmail(email) {
  if (!email || !email.includes("@")) return "";
  const [local, domain] = email.split("@");
  if (local.length <= 2) return `${local[0]}****@${domain}`;
  return `${local[0]}****${local.slice(-2)}@${domain}`;
}

/**
 * Load pending 2FA info from localStorage
 */
onMounted(() => {
  const pendingTwoFA = JSON.parse(localStorage.getItem("pendingTwoFA") || "{}");

  if (!pendingTwoFA.student_id || !pendingTwoFA.email) {
    console.warn("Cannot proceed, missing pending 2FA info:", pendingTwoFA);
    router.push("/login");
    return;
  }

  studentId.value = pendingTwoFA.student_id;
  maskedEmail.value = maskEmail(pendingTwoFA.email);
});

/**
 * Verify 2FA code
 */
const verifyCode = async () => {
  if (!code.value) {
    return Swal.fire({
      icon: "warning",
      title: "Missing Code",
      text: "Please enter the verification code.",
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });
  }

  loading.value = true;

  try {
    const response = await axios.post(
      "http://localhost:5000/api/students/verify-twofa",
      { code: code.value },
      { withCredentials: true }
    );

    if (response.data.success) {
      localStorage.setItem("student", JSON.stringify(response.data.student));
      localStorage.removeItem("pendingTwoFA");

      Swal.fire({
        icon: "success",
        title: "Verification Successful",
        text: "You have been successfully logged in.",
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        },
      }).then(() => router.push("/"));
    } else {
      Swal.fire({
        icon: "error",
        title: "Invalid Code",
        text: response.data.message || "The verification code is invalid.",
        didOpen: () => {
          document.body.classList.remove("swal2-height-auto");
          document.documentElement.classList.remove("swal2-height-auto");
        },
      });
    }
  } catch (err) {
    console.error("Verify code error:", err);
    Swal.fire({
      icon: "error",
      title: "Error",
      text: "Error verifying code. Please try again.",
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });
  } finally {
    loading.value = false;
  }
};

/**
 * Resend 2FA code
 */
const resendCode = async () => {
  const pendingTwoFA = JSON.parse(localStorage.getItem("pendingTwoFA") || "{}");
  if (!pendingTwoFA.email || !pendingTwoFA.student_id) {
    return Swal.fire({
      icon: "error",
      title: "Cannot Resend",
      text: "Missing pending 2FA info. Please login again.",
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });
  }

  resending.value = true;

  try {
    const response = await axios.post(
      "http://localhost:5000/api/students/resend-twofa",
      {
        student_id: pendingTwoFA.student_id,
        email: pendingTwoFA.email,
      },
      { withCredentials: true }
    );

    Swal.fire({
      icon: "success",
      title: "Code Resent",
      text: response.data.message || "Verification code has been resent.",
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });

    startCountdown();
  } catch (err) {
    console.error("Resend 2FA code error:", err);
    Swal.fire({
      icon: "error",
      title: "Error",
      text: "Error resending code. Please try again.",
      didOpen: () => {
        document.body.classList.remove("swal2-height-auto");
        document.documentElement.classList.remove("swal2-height-auto");
      },
    });
  } finally {
    resending.value = false;
  }
};

/**
 * Countdown timer for resend button
 */
const startCountdown = () => {
  countdown.value = 30;
  clearInterval(timer);
  timer = setInterval(() => {
    countdown.value--;
    if (countdown.value <= 0) clearInterval(timer);
  }, 1000);
};
</script>

<style scoped>
.fixed-content {
  --keyboard-offset: 0px !important;
  --offset-top: 0px !important;
  --offset-bottom: 0px !important;
}

#container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 10px;
  height: 100%;
  color: #fff;
  margin-top: -40px;
}

h2 {
  color: yellow;
  font-weight: 600;
  font-size: 30px !important;
}

.notes {
  width: 100%;
  text-align: left;
  font-size: 13px;
}

.input-wrapper {
  width: 100%;
  position: relative;
  margin-top: 20px;
}

ion-input {
  width: 100%;
  background: #fff;
  padding-left: 4px !important;
  color: #000 !important;
  text-align: left;
  margin-bottom: 5px;
}

ion-button {
  width: 100%;
  --background: #07055D !important;
  color: yellow !important;
  margin-top: 15px;
}

.resend-text {
  margin-top: 15px;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.resend-text ion-button {
  width: auto !important;
  --background: transparent !important;
  margin-top: 0 ;
}
#container ion-text.msg {
  margin-top: 15px;
  font-weight: 500;
}

.footer {
  position: fixed;
  bottom: 0;
  width: 100%;
  z-index: 100;
}
</style>
