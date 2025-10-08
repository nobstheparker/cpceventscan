const { saveFaceImage, getFaceImageByStudentId, getAllFaces, deleteFaceByStudentId  } = require('../models/faceModel');

const registerFace = async (req, res) => {
  try {

    const studentId = req.query.student_id || req.session?.student?.student_id;
    const descriptor = req.body.descriptor;

    if (!studentId || !descriptor) {
      console.warn('⚠️ Missing studentId or descriptor');
      return res.status(400).json({ error: 'Missing studentId or descriptor' });
    }
    await saveFaceImage(studentId, JSON.stringify(descriptor));
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: 'Failed to save face' });
  }
};
const verifyFace = async (req, res) => {
  try {
    // Get student ID either from session, query, or body
    const studentId = req.body.studentId || req.query.student_id || req.session?.student?.student_id;
    const descriptor = req.body.descriptor;

    if (!studentId || !descriptor) {
      return res.status(400).json({ error: 'Missing studentId or descriptor' });
    }

    // Get stored face data
    const stored = await getFaceImageByStudentId(studentId);
    if (!stored) return res.status(404).json({ error: 'Face not registered' });

    const storedDescriptor = JSON.parse(stored);

    if (!Array.isArray(storedDescriptor) || !Array.isArray(descriptor)) {
      return res.status(400).json({ error: 'Descriptor format invalid' });
    }

    if (descriptor.length !== storedDescriptor.length) {
      return res.status(400).json({ error: 'Invalid descriptor length' });
    }

    // Calculate Euclidean distance
    const distance = Math.sqrt(
      storedDescriptor.reduce((sum, val, i) => sum + Math.pow(val - descriptor[i], 2), 0)
    );

    const threshold = 0.45; 
    const verified = distance < threshold;

    res.json({ verified, distance });
  } catch (err) {
    console.error('Error verifying face:', err);
    res.status(500).json({ error: 'Verification failed' });
  }
};

// const verifyFace = async (req, res) => {
//   try {
//     const studentId = req.query.student_id || req.session?.student?.student_id;
//     const { studentId, descriptor } = req.body;
//     if (!studentId || !descriptor) return res.status(400).json({ error: 'Missing studentId or descriptor' });

//     const stored = await getFaceImageByStudentId(studentId);
//     if (!stored) return res.status(404).json({ error: 'Face not registered' });

//     const storedDescriptor = JSON.parse(stored);

//     if (descriptor.length !== storedDescriptor.length) {
//       return res.status(400).json({ error: 'Invalid descriptor length' });
//     }

//     // Euclidean distance
//     const distance = Math.sqrt(
//       storedDescriptor.reduce((sum, val, i) => sum + Math.pow(val - descriptor[i], 2), 0)
//     );

//     const verified = distance < 0.45; // threshold
//     res.json({ verified, distance });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: 'Verification failed' });
//   }
// };

const checkFace = async (req, res) => {
  try {
    const studentId = req.query.student_id || req.session?.student?.student_id;
    if (!studentId) return res.status(400).json({ error: 'Missing studentId' });

    const stored = await getFaceImageByStudentId(studentId);
    res.json({ registered: !!stored });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to check face' });
  }
};

const listFaces = async (req, res) => {
  try {
    const faces = await getAllFaces();
    res.json({ faces });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch faces' });
  }
};

const deleteFace = async (req, res) => {
  try {
    const { studentId } = req.body;
    if (!studentId) return res.status(400).json({ error: 'Missing studentId' });

    const deleted = await deleteFaceByStudentId(studentId);
    if (deleted) {
      res.json({ success: true, message: 'Face ID deleted successfully' });
    } else {
      res.status(404).json({ error: 'Face ID not found' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to delete Face ID' });
  }
};

module.exports = { registerFace, verifyFace, checkFace, listFaces,deleteFace };
