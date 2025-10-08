const express = require('express');
const router = express.Router();
const attendanceController = require('../controllers/attendanceController');

router.post('/', attendanceController.create);
router.put('/:event_id/timein', attendanceController.timeIn);
router.put('/:event_id/trivia-timein', attendanceController.triviaTimeIn);
router.put('/:event_id/timeout', attendanceController.timeOut);
router.get('/:event_id/check/', attendanceController.checkAttendance);   
router.get('/event/:id', attendanceController.getByEvent);
router.get('/me', attendanceController.getMyAttendance);
router.get('/summary', attendanceController.getEventAttendanceSummary);
router.get('/details/:event_id', attendanceController.getEventDetails);
router.put('/settle/:attendance_id', attendanceController.settleAttendance);
router.get('/controls', attendanceController.getAttendanceControls);
router.put('/controls/:eventID', attendanceController.updateControls);

module.exports = router;
