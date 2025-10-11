const db = require('../config/db');

// Create attendance record
function createAttendance(student_id, event_id) {
  return db.execute(
    'INSERT INTO event_attendance (student_id, id) VALUES (?, ?)',
    [student_id, event_id]
  );
}

// Update time in
function updateTimeIn(attendance_id) {
  return db.execute(
    'UPDATE event_attendance SET time_in = NOW() WHERE attendance_id = ?',
    [attendance_id]
  );
}

// Update trivia time in
function updateTriviaTimeIn(attendance_id) {
  return db.execute(
    'UPDATE event_attendance SET trivia_time_in = NOW() WHERE attendance_id = ?',
    [attendance_id]
  );
}

// Update time out
function updateTimeOut(attendance_id) {
  return db.execute(
    'UPDATE event_attendance SET time_out = NOW() WHERE attendance_id = ?',
    [attendance_id]
  );
}

// Update afternoon time in
function updateAfternoonTimeIn(attendance_id) {
  return db.execute(
    'UPDATE event_attendance SET afternoon_time_in = NOW() WHERE attendance_id = ?',
    [attendance_id]
  );
}

// Update afternoon trivia time in
function updateAfternoonTriviaTimeIn(attendance_id) {
  return db.execute(
    'UPDATE event_attendance SET afternoon_trivia_time_in = NOW() WHERE attendance_id = ?',
    [attendance_id]
  );
}

// Update afternoon time out
function updateAfternoonTimeOut(attendance_id) {
  return db.execute(
    'UPDATE event_attendance SET afternoon_time_out = NOW() WHERE attendance_id = ?',
    [attendance_id]
  );
}


// Get attendance by event and optional student
function getByEvent(event_id, student_id = null) {
  let sql = 'SELECT * FROM event_attendance WHERE id = ?';
  const params = [event_id];
  if (student_id) {
    sql += ' AND student_id = ?';
    params.push(student_id);
  }
  return db.execute(sql, params);
}

function getBystudEvent(event_id, student_id) {
  if (!event_id || !student_id) {
    return Promise.reject(new Error('Missing event_id or student_id'));
  }

  const sql = 'SELECT * FROM event_attendance WHERE student_id = ? AND id = ?';
  return db.execute(sql, [student_id, event_id]);
}

function getByStudent(student_id) {
  return db.execute(
    `SELECT ea.attendance_id, e.event_name AS eventName, DATE_FORMAT(e.start_date_time, '%b %d, %Y') AS date,
            ea.time_in AS timeIn, ea.time_out AS timeOut, ea.remarks,
            CASE ea.status
                WHEN 1 THEN 'cleared'
                ELSE 'unsettled'
            END AS status
     FROM event_attendance ea
     JOIN events e ON ea.id = e.id
     WHERE ea.student_id = ?`,
    [student_id]
  );
}

function getEventAttendanceSummary() {
  return db.execute(
    `SELECT 
    e.id AS eventID,
    e.event_name AS eventName,
    DATE_FORMAT(e.start_date_time, '%Y-%m-%d') AS eventDate,
    e.start_date_time,
    e.end_date_time,
    CASE 
        WHEN NOW() > e.end_date_time THEN 'Completed'
        WHEN NOW() BETWEEN e.start_date_time AND e.end_date_time THEN 'Ongoing'
        ELSE 'Upcoming'
    END AS eventStats,
    SUM(CASE WHEN ea.time_in IS NOT NULL THEN 1 ELSE 0 END) AS totalAttendees,
    SUM(CASE 
        WHEN (ea.time_in IS NOT NULL AND ea.time_out IS NOT NULL AND ea.trivia_time_in IS NOT NULL) 
        THEN 1 
        ELSE 0 
    END) AS completeAttendance,
    SUM(CASE 
        WHEN ea.time_in IS NULL 
             OR ea.time_out IS NULL 
             OR ea.trivia_time_in IS NULL 
        THEN 1 
        ELSE 0 
    END) AS incompleteAttendance,
    SUM(CASE WHEN ea.time_in IS NULL THEN 1 ELSE 0 END) AS totalAbsences,
    COUNT(ea.id) AS totalRecords
FROM events e
LEFT JOIN event_attendance ea ON ea.id = e.id  
GROUP BY e.id, e.event_name, e.start_date_time, e.end_date_time
ORDER BY e.start_date_time DESC;`
  );
}

function getEventDetails(event_id) {
  return db.execute(
    `SELECT 
    ea.attendance_id,
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS studName,
    CONCAT(c.course_code, ' ', y.year_level, ' ', sec.section_name) AS progYearSec,

    -- Format times
    DATE_FORMAT(ea.time_in, '%h:%i %p') AS timeIn,
    DATE_FORMAT(ea.trivia_time_in, '%h:%i %p') AS midEventcheck,
    DATE_FORMAT(ea.time_out, '%h:%i %p') AS timeOut,
    DATE_FORMAT(ea.afternoon_time_in, '%h:%i %p') AS afternoontimeIn,
    DATE_FORMAT(ea.afternoon_trivia_time_in, '%h:%i %p') AS afternoonmidEventcheck,
    DATE_FORMAT(ea.afternoon_time_out, '%h:%i %p') AS afternoontimeOut,
    ea.absence_request AS absenceReq,
    
    -- Remarks logic
    CASE 
        WHEN ea.time_in IS NOT NULL 
         AND ea.trivia_time_in IS NOT NULL 
         AND ea.time_out IS NOT NULL 
         AND ea.afternoon_time_in IS NOT NULL 
         AND ea.afternoon_trivia_time_in IS NOT NULL 
         AND ea.afternoon_time_out IS NOT NULL 
        THEN 'Present'
        WHEN ev.end_date_time < NOW() 
         AND ea.time_in IS NULL 
         AND ea.trivia_time_in IS NULL 
         AND ea.time_out IS NULL 
         AND ea.afternoon_time_in IS NULL 
         AND ea.afternoon_trivia_time_in IS NULL 
         AND ea.afternoon_time_out IS NULL 
        THEN 'Missed'
        ELSE ea.remarks
    END AS remarks,

    -- Attendance Status logic
    CASE 
        WHEN ea.status = 1 THEN 'Settled'
        WHEN ea.time_in IS NOT NULL 
         AND ea.trivia_time_in IS NOT NULL 
         AND ea.time_out IS NOT NULL 
         AND ea.afternoon_time_in IS NOT NULL 
         AND ea.afternoon_trivia_time_in IS NOT NULL
         AND ea.afternoon_time_out IS NOT NULL 
        THEN 'Complete'
        WHEN ea.status = 2 THEN 'Excused'
        ELSE 'Unsettled'
    END AS attendanceStats,

    CASE
        WHEN ea.status != 1 THEN 1
        ELSE 0
    END AS canSettle,

    -- Event details with formatted date
    ev.id AS eventId,
    ev.event_name,
    DATE_FORMAT(ev.start_date_time, '%M %d, %Y %h:%i %p') AS startDateTime,
    DATE_FORMAT(ev.end_date_time, '%M %d, %Y %h:%i %p') AS endDateTime,

    -- Program attendance stats
    (SELECT COUNT(*) 
     FROM students st 
     WHERE st.course_id = s.course_id) AS totalStudentsInCourse,

    (SELECT COUNT(*) 
     FROM event_attendance ea2
     JOIN students st2 ON ea2.student_id = st2.student_id
     WHERE ea2.id = ea.id 
       AND st2.course_id = s.course_id
       AND ea2.time_in IS NOT NULL 
    ) AS attendedStudents,

    ROUND(
      (
        (SELECT COUNT(*) 
         FROM event_attendance ea2
         JOIN students st2 ON ea2.student_id = st2.student_id
         WHERE ea2.id = ea.id 
           AND st2.course_id = s.course_id
           AND ea2.time_in IS NOT NULL 
        ) / 
        (SELECT COUNT(*) 
         FROM students st 
         WHERE st.course_id = s.course_id
        )
      ) * 100, 2
    ) AS programAttendanceRate

FROM event_attendance ea
JOIN students s ON ea.student_id = s.student_id
LEFT JOIN courses c ON s.course_id = c.course_id
LEFT JOIN year_levels y ON s.year_id = y.year_id
LEFT JOIN sections sec ON s.section_id = sec.section_id
JOIN events ev ON ea.id = ev.id
WHERE ea.id = ?;
`,
    [event_id]
  );
}
function settleAttendance(attendance_id) {
  return db.execute(
    'UPDATE event_attendance SET status = 1 WHERE attendance_id = ?',
    [attendance_id]
  );
}
function getAllAttendanceControls() {
  return db.execute(
    `SELECT 
        ac.id AS controlID,
        ac.event_id,
        e.event_name AS eventName,
        DATE_FORMAT(e.start_date_time, '%Y-%m-%d') AS eventDate,
        ac.morning_time_in,
        ac.morning_mid_event,
        ac.morning_time_out,
        ac.afternoon_time_in,
        ac.afternoon_mid_event,
        ac.afternoon_time_out,
        ac.feedback_form
     FROM attendance_controls ac
     JOIN events e ON ac.event_id = e.id
     ORDER BY e.start_date_time DESC`
  );
}

function getAttendanceControlsByEvent(event_id) {
  return db.execute(
    `SELECT 
        ac.id AS controlID,
        ac.event_id,
        e.event_name AS eventName,
        DATE_FORMAT(e.start_date_time, '%Y-%m-%d') AS eventDate,
        ac.morning_time_in,
        ac.morning_mid_event,
        ac.morning_time_out,
        ac.afternoon_time_in,
        ac.afternoon_mid_event,
        ac.afternoon_time_out,
        ac.feedback_form
     FROM attendance_controls ac
     JOIN events e ON ac.event_id = e.id
     WHERE e.id = ?
     ORDER BY e.start_date_time DESC`,
    [event_id]
  );
}

function updateAttendanceControls(eventID, settings) {
  // settings already have keys like 'morning_time_in', 'morning_mid_event'
  const mappedSettings = {
    morning_time_in: settings.morning_time_in ? 1 : 0,
    morning_mid_event: settings.morning_mid_event ? 1 : 0,
    morning_time_out: settings.morning_time_out ? 1 : 0,
    afternoon_time_in: settings.afternoon_time_in ? 1 : 0,
    afternoon_mid_event: settings.afternoon_mid_event ? 1 : 0,
    afternoon_time_out: settings.afternoon_time_out ? 1 : 0,
    feedback_form: settings.feedback_form ? 1 : 0,
  };

  return db.execute(
    `UPDATE attendance_controls SET 
       morning_time_in = ?, 
       morning_mid_event = ?, 
       morning_time_out = ?, 
       afternoon_time_in = ?, 
       afternoon_mid_event = ?, 
       afternoon_time_out = ?, 
       feedback_form = ? 
     WHERE event_id = ?`,
    [
      mappedSettings.morning_time_in,
      mappedSettings.morning_mid_event,
      mappedSettings.morning_time_out,
      mappedSettings.afternoon_time_in,
      mappedSettings.afternoon_mid_event,
      mappedSettings.afternoon_time_out,
      mappedSettings.feedback_form,
      eventID
    ]
  );
}

module.exports = {
  createAttendance,
  updateTimeIn,
  updateTriviaTimeIn,
  updateTimeOut,
  getByEvent,
  getByStudent,
  getEventAttendanceSummary,
  getEventDetails,
  settleAttendance,
  getBystudEvent,
  getAllAttendanceControls,
  updateAttendanceControls,
  updateAfternoonTimeIn,
  updateAfternoonTriviaTimeIn,
  updateAfternoonTimeOut,
  getAttendanceControlsByEvent
};