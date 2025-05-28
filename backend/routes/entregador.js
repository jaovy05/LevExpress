const express = require('express');
const router = express.Router();
const Entregador = require('../controllers/Entregador');

router.post('/',      Entregador.create);
router.get('/',       Entregador.findAll);
router.get('/:id',    Entregador.findOne);
router.put('/:id',    Entregador.update);
router.delete('/:id', Entregador.delete);

module.exports = router;
