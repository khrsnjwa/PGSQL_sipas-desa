const router = require('express').Router();
const c = require('../controllers/jenisSuratController');
const { validateId, validateJenisSurat } = require('../middlewares/validate');

router.get('/', c.getAll);
router.get('/:id', validateId, c.getById);
router.post('/', validateJenisSurat, c.create);
router.put('/:id', validateId, validateJenisSurat, c.update);
router.delete('/:id', validateId, c.remove);

module.exports = router;
