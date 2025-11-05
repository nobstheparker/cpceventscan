const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');

router.post('/', eventController.createEvent);
router.get('/list', eventController.getAllEvents);
router.get('/list/:id', eventController.getEventById);
router.delete('/delete/:id', eventController.deleteEvent);
router.put('/update/:id', eventController.updateEvent);
router.get('/search', async (req, res) => {
  const query = req.query.query;
  const [rows] = await db.query(
    `SELECT id, student_id, first_name, last_name FROM students 
     WHERE student_id LIKE ? OR first_name LIKE ? OR last_name LIKE ?`,
    [`%${query}%`, `%${query}%`, `%${query}%`]
  );
  res.json(rows);
});

module.exports = router;