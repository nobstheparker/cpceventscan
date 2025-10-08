import { createRouter, createWebHistory } from '@ionic/vue-router';
import { RouteRecordRaw } from 'vue-router';
import AdminLogIn from '../views/AdminLogIn.vue';
import Dashboard from '../views/Dashboard.vue';
import LoginPage from '../views/LoginPage.vue';
import RegisterPage from '../views/Register.vue';
import Homepage from '../views/HomePage.vue';
import ApplicationPage from '../views/ApplicationPage.vue';
import AbsenceRequestPage from '../views/AbsenceRequest.vue';
import CalendarPage from '../views/CalendarPage.vue';
import ScannerPage from '../views/ScanPage.vue';
import StudentNotificationPage from '../views/NotificationPage.vue';
import AttendanceControl from '../views/AttendanceControl.vue';
import AttendanceRecords from '../views/AttendanceRecords.vue';
import CreateEvent from '../views/CreateEvent.vue';
import EventList from '../views/EventList.vue';
import FaceReset from '../views/Facereset.vue';
import Feedback from '../views/Feedback.vue';
import Notification from '../views/Notification.vue';
import Recovery from '../views/Recovery.vue';
import RegisterCourse from '../views/RegisterCourse.vue';
import Requests from '../views/Requests.vue';
import Updates from '../views/Updates.vue';
import View from '../views/View.vue';
import ViewCourse from '../views/ViewCourse.vue';
import ViewSection from '../views/ViewSection.vue';
import ViewYear from '../views/ViewYearlvl.vue';
import AccountCenter from '../views/AccountCenter.vue';
import AddSection from '../views/AddSection.vue';
import AddYear from '../views/AddYearlvl.vue';
import Profile from '../views/ProfilePage.vue';
import PersonalInfo from '../views/Personalinfo.vue';
import AccountSecurityPage from '../views/AcountSecurity.vue';
import StudentAbsentPage from '../views/student-AbsenceRequests.vue';
import StudentApplicationPage from '../views/student-applicationRequest.vue';
import FaceRecognitionPage from '../views/FaceRecognition.vue';
import FaceTimeinPage from '../views/FaceTimeIn.vue';
import TimeinPage from '../views/TimeInPage.vue';
import Studentattendance from '../views/students-attendance-record.vue'; 
import HelpCenterPage from '../views/helpcenter.vue'; 
import TwofaPage from '../views/Twofa.vue'; 
const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'Home',
    component: Homepage
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginPage
  },
  {
    path: '/adminLogIn',
    name: 'AdminLogInPage',
    component: AdminLogIn
  },
  {
    path: '/dashboard',
    name: 'DashboardPage',
    component: Dashboard
  },
  {
    path: '/register',
    name: 'RegisterPage',
    component: RegisterPage
  },
  {
    path: '/application-form',
    name: 'ApplicationPage',
    component: ApplicationPage
  },
  {
    path: '/absence-request-form',
    name: 'AbsenceRequestPage',
    component: AbsenceRequestPage
  },
  {
    path: '/calendar-page',
    name: 'CalendarPage',
    component: CalendarPage
  },
  {
    path: '/scanner',
    name: 'ScannerPage',
    component: ScannerPage
  },
  {
    path: '/notifications',
    name: 'StudentNotification',
    component: StudentNotificationPage
  },{
    path: '/view',
    name: 'ViewPage',
    component: View
  },
  {
    path: '/facereset',
    name: 'FaceReset',
    component: FaceReset
  },
  {
    path: '/recovery',
    name: 'RecoverytPage',
    component: Recovery
  },
  {
    path: '/register-course',
    name: 'RegisterCoursePage',
    component: RegisterCourse
  },
  {
    path: '/view-course',
    name: 'ViewCoursePage',
    component: ViewCourse
  },
  {
    path: '/add-year',
    name: 'AddYearPage',
    component: AddYear
  },
  {
    path: '/view-year',
    name: 'ViewYearPage',
    component: ViewYear
  },
  {
    path: '/add-sec',
    name: 'AddSecPage',
    component: AddSection
  },
  {
    path: '/view-sec',
    name: 'ViewSectionPage',
    component: ViewSection
  },
  {
    path: '/create',
    name: 'CreateEventPage',
    component: CreateEvent
  },
  {
    path: '/event-lists',
    name: 'EventListPage',
    component: EventList
  },
  {
    path: '/attendance-page',
    name: 'AttendanceControlPage',
    component: AttendanceControl
  },
  {
    path: '/attendance-records',
    name: 'AttendanceRecordPage',
    component: AttendanceRecords
  },
  {
    path: '/attendance-details/:eventID',
    name: 'AttendanceDetailsPage',
    component: () => import('@/views/AttendanceRecordDetails.vue')
  }
  ,
  {
    path: '/Request',
    name: 'RequestsPage',
    component: Requests
  },
  {
  path: '/generate-report/:eventId',
  name: 'GenerateReport',
  component: () => import('@/views/GenerateReport.vue')
  },
  {
    path: '/Notif',
    name: 'NotificationPage',
    component: Notification
  },
  {
    path: '/Feed',
    name: 'FeedbackPage',
    component: Feedback
  },
  {
  path: '/feedback-details/:eventID',
  name: 'FeedbackDetails',
  component: () => import('@/views/FeedbackDetails.vue')
  },
  {
    path: '/Update',
    name:'UpdatesPage',
    component: Updates
  },
  {
    path: '/account-center',
    name:'AccountCenterPage',
    component: AccountCenter
  },
  {
    path: '/profile',
    name:'ProfilePage',
    component: Profile
  }
  ,
  {
    path: '/personal-info',
    name:'Personalinfopage',
    component: PersonalInfo
  }
  ,
  {
    path: '/account-security',
    name:'AccountSecurity',
    component: AccountSecurityPage
  },
  {
    path: '/student-absent-request',
    name:'StudentAbsent',
    component: StudentAbsentPage
  },
  {
    path: '/student-volunteer-applications',
    name:'StudentApplication',
    component: StudentApplicationPage
  },
  {
    path: '/facial-recognition',
    name:'FaceRecognition',
    component: FaceRecognitionPage
  },
  {
    path: '/face-verification',
    name:'FaceTimein',
    component: FaceTimeinPage
  },
  {
    path: '/event-attendance',
    name:'Timein',
    component: TimeinPage
  },
  {
    path: '/student-attendance-record',
    name:'StudentattendanceRecord',
    component: Studentattendance
  },
  {
    path: '/help-center',
    name:'HelpCenter',
    component: HelpCenterPage
  }
  ,
  {
    path: '/twofa',
    name:'Twofa',
    component: TwofaPage
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router
