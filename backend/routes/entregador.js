const express = require('express');
const router = express.Router();
const entregador = require('../controller/Entregador');

router.post('/', entregador.create);
router.get('/', entregador.findAll);
router.get('/:id', entregador.findOne);
router.put('/:id', entregador.update);
router.delete('/:id', entregador.delete);

module.exports = router;
