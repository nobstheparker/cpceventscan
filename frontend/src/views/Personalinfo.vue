<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
          <div class="logo">
            <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
          </div>
      </ion-toolbar>
    </ion-header>

    <ion-content class="fixed-content"
      :scrollAssist="false"
      :keyboard-attach="false"
      keyboard-resize="none">
      <div id="container">
        <!-- Sub-header -->
        <div class="header-bottom">
          <ion-buttons slot="start">
            <ion-back-button defaultHref="/profile" />
          </ion-buttons>
          <h2>
            PERSONAL INFO
            <ion-icon name="create-outline" @click="startEditing" style="cursor: pointer;"></ion-icon>
          </h2>
        </div>

        <!-- Dynamic Info List -->
        <ion-list class="info-list">
          <ion-item>
            <ion-label position="stacked">Student ID:</ion-label>
            <ion-input :value="student.student_id" readonly></ion-input>
          </ion-item>

          <ion-item>
            <ion-label position="stacked">First Name:</ion-label>
            <ion-input v-if="isEditing" v-model="tempStudent.first_name"></ion-input>
            <ion-input v-else :value="student.first_name" readonly></ion-input>
          </ion-item>

          <ion-item>
            <ion-label position="stacked">Last Name:</ion-label>
            <ion-input v-if="isEditing" v-model="tempStudent.last_name"></ion-input>
            <ion-input v-else :value="student.last_name" readonly></ion-input>
          </ion-item>
          <ion-item>
            <ion-label position="stacked">Course:</ion-label>
            <template v-if="isEditing">
                <select v-model="tempStudent.course_id" required style="width: 100%; padding: 4px; border-radius: 5px;">
                    <option disabled value="">Select Course</option>
                    <option v-for="course in courses" :key="course.course_id" :value="course.course_id">
                    {{ course.course_code }}
                    </option>
                </select>
            </template>
            <ion-input v-else :value="`${getCourseName(student.course_id)}`" readonly></ion-input>
            </ion-item>
            <ion-item>
                <ion-label position="stacked">Yr & Section:</ion-label>
                <template v-if="isEditing">
                    <select v-model="tempStudent.year_id" required style="width: 100%; padding: 4px; border-radius: 5px;">
                    <option disabled value="">Select Year Level</option>
                    <option v-for="level in yearLevels" :key="level.YearID" :value="level.YearID">
                        {{ level.YearLvl }}
                    </option>
                    </select>
                    <select v-model="tempStudent.section_id" required style="width: 100%; padding: 4px; border-radius: 5px; margin-top: 10px;">
                    <option disabled value="">Select Section</option>
                    <option v-for="sec in sections" :key="sec.section_id" :value="sec.section_id">
                        {{ sec.section_name }}
                    </option>
                    </select>
                </template>
                <ion-input
                    v-else
                    :value="`${getYearLabel(student.year_id)} - ${getSectionName(student.section_id)}`"
                    readonly
                />
            </ion-item>
          <ion-item>
            <ion-label position="stacked">Sex:</ion-label>
            <template v-if="isEditing">
              <select v-model="tempStudent.sex" interface="popover" placeholder="Select Sex" style="border-radius: 5px; padding: 5px; width: 100%;">
                <option value="Male">Male</option>
                <option value="Female">Female</option>
              </select>
            </template>
            <ion-input v-else :value="student.sex" readonly></ion-input>
          </ion-item>
            <ion-item>
                <ion-label position="stacked">Birth Date:</ion-label>
                <ion-input
                    v-if="isEditing"
                    type="date"
                    :value="tempStudent.birthday?.split('T')[0]"
                    @ionInput="e => tempStudent.birthday = e.target.value"
                    />
               <ion-input
                v-else
                :value="student.birthday?.split('T')[0]"
                readonly
                ></ion-input>
            </ion-item>

            <ion-item>
                <ion-label position="stacked">Age:</ion-label>
                <ion-input :value="calculatedAge" readonly ></ion-input>
            </ion-item>
          <ion-item>
            <ion-label position="stacked">Email Address:</ion-label>
            <ion-input v-if="isEditing" v-model="tempStudent.email"></ion-input>
            <ion-input v-else :value="student.email" readonly></ion-input>
          </ion-item>

          <ion-item>
            <ion-label position="stacked">Contact Number:</ion-label>
            <ion-input v-if="isEditing" v-model="tempStudent.phone"></ion-input>
            <ion-input v-else :value="student.phone" readonly></ion-input>
          </ion-item>

          <ion-item>
            <ion-label position="stacked">Home Address:</ion-label>
            <ion-input v-if="isEditing" v-model="tempStudent.address" />
            <ion-input v-else :value="student.address" readonly></ion-input>
           </ion-item>
        </ion-list>

        <!-- Save / Cancel buttons -->
        <div v-if="isEditing" class="edit-buttons">
          <ion-button expand="block" @click="saveChanges" class="success">Save</ion-button>
          <ion-button expand="block" color="danger" @click="cancelEditing">Cancel</ion-button>
        </div>
      </div>

      <!-- Footer -->
      <div class="footer">
        <div class="footer-icons">
          <ion-icon name="home"></ion-icon>
          <ion-icon name="calendar"></ion-icon>
          <ion-icon name="scan"></ion-icon>
          <ion-icon name="notifications"></ion-icon>
          <ion-icon name="person" class="active"></ion-icon>
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
  IonContent,
  IonItem,
  IonLabel,
  IonInput,
  IonList,
  IonBackButton,
  IonButtons,
  IonIcon,
  IonText,
  IonButton,
  IonSelect,
  IonSelectOption
} from '@ionic/vue';
import { ref, onMounted, computed } from 'vue';
import { addIcons } from 'ionicons';
import { createOutline } from 'ionicons/icons';
import Swal from 'sweetalert2';
import axios from 'axios';

addIcons({
  'create-outline': createOutline
});

const student = ref({
  id: '',
  student_id: '',
  first_name: '',
  middle_name: '',
  last_name: '',
  course_id: '',
  section_id: '',
  year_id: '',
  email: '',
  phone: '',
  birthday: '',
  sex: '',
  address: ''
});

const tempStudent = ref({ ...student.value });
const isEditing = ref(false);
const courses = ref<string[]>([]); 
const sections = ref<any[]>([]);
const yearLevels = ref<any[]>([]);

const formattedBirthday = computed(() => {
  const date = new Date(student.value.birthday);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
});
const formattedEditDate = computed(() => {
  if (!tempStudent.value.birthday) return '';
  return tempStudent.value.birthday.split('T')[0];
});
const calculatedAge = computed(() => {
  const birthDate = new Date(student.value.birthday);
  const today = new Date();
  let age = today.getFullYear() - birthDate.getFullYear();
  const m = today.getMonth() - birthDate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }
  return age;
});
const fetchYearLevels = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/year-level/list');
    yearLevels.value = res.data.yearLevels || [];
  } catch (error) {
    console.error('Failed to fetch year levels:', error);
  }
};

const fetchCourses = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/courses/list');
    courses.value = res.data.courses || [];
  } catch (error) {
    console.error('Failed to fetch courses:', error);
  }
};
const fetchSections = async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/sections/list');
    sections.value = res.data.sections || [];
  } catch (error) {
    console.error('Failed to fetch sections:', error);
  }
};

const startEditing = () => {
  tempStudent.value = {
    ...student.value,
    sex: student.value.sex || 'Male'
  };
  isEditing.value = true;
};

const cancelEditing = () => {
  isEditing.value = false;
};
const getYearLabel = (id: number | string) => {
  const found = yearLevels.value.find((lvl) => lvl.YearID == id);
  return found ? found.YearLvl : '';
};

const getSectionName = (id: number | string) => {
  const found = sections.value.find((sec) => sec.section_id == id);
  return found ? found.section_name : '';
};
const getCourseName = (id: number | string) => {
  const found = courses.value.find((crs) => crs.course_id == id);
  return found ? found.course_code : '';
};
const saveChanges = async () => {
  try {
    const payload = { ...tempStudent.value };

    if (payload.birthday?.includes('T')) {
      payload.birthday = payload.birthday.split('T')[0];
    }

    console.log('Payload being sent to backend:', payload);

    await axios.put(
      `http://localhost:5000/api/students/update-student/${student.value.id}`,
      payload,
      { withCredentials: true }
    );

    student.value = { ...tempStudent.value };
    isEditing.value = false;

    Swal.fire({
      icon: 'success',
      title: 'Success',
      text: 'Student info updated successfully!',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    }).then(() => {
      window.location.reload();
    });

  } catch (error) {
    console.error('Failed to update student:', error);
    Swal.fire({
      icon: 'error',
      title: 'Error',
      text: 'Failed to update student. Please try again.',
      didOpen: () => {
        document.body.classList.remove('swal2-height-auto');
        document.documentElement.classList.remove('swal2-height-auto');
      }
    });
  }
};
onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:5000/api/protected', {
      withCredentials: true
    });
    student.value = res.data.student;
  } catch (error) {
    console.error('Session fetch failed:', error);
  }

  await fetchCourses();
  await fetchSections();
  await fetchYearLevels();
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
  text-align: left;
  padding-top: 20px;
  padding-bottom: 100px;
  display: block;
  min-height: 100%;
}

.header-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px;
  margin-bottom: 20px;
}

.header-bottom ion-icon {
  color: #fff;
  font-weight: 700;
}

.header-bottom h2 {
  color: yellow;
  font-size: 24px;
  margin: 0 auto;
  text-align: center;
  font-weight: 600;
}

.header-bottom ion-buttons {
  position: absolute;
}

.info-list {
  background: #999;
  padding-bottom: 20px;
}

.info-list ion-item {
  --background: transparent;
  margin-bottom: 0;
}

ion-label {
  font-weight: 600;
  color: black;
  margin-bottom: 10px !important;
}

ion-input {
  --color: black;
  background: white;
  border-radius: 4px;
  font-size: 14px;
  padding-left: 10px !important;
  min-height: 30px !important;
  margin-bottom: 5px;
}

ion-item {
  --inner-border-width: 0px;
}

ion-back-button {
  color: #fff !important;
}

ion-select{
    width: 100%;
    background: #fff;
}
ion-select .select-icon{
    position: absolute;
    right: 10px;
}

/* Save / Cancel Button Container */
.edit-buttons {
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.edit-buttons ion-button{
    --color: #fff !important;
}
.edit-buttons .success {
    --background: #029f14 !important
}
/* Footer */
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
  position: absolute;
  width: 100%;
  top: -32px;
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

ion-text {
  margin: 10px 0;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px;
  font-size: 14px;
}
.fixed-content {
  --keyboard-offset: 0px !important;
  --offset-top: 0px !important;
  --offset-bottom: 0px !important;
}
</style>
