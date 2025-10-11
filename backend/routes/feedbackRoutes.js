const express = require('express');
const router = express.Router();
const { addFeedback, getFeedback, getAllFeedbackEvent } = require('../controllers/feedbackController');

router.post('/add', addFeedback);
router.get('/:eventId', getFeedback);
router.get('/', getAllFeedbackEvent);
module.exports = router;
