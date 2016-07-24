const list = require('./actions/list.js');
const add = require('./actions/add.js');

function exit() {
  process.exit(0);
}

module.exports = { add, list, exit };

