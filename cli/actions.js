const menu = require('./actions/menu.js');
const list = require('./actions/list.js');
const add = require('./actions/add.js');
const rss = require('./actions/rss.js');

function exit() {
  process.exit(0);
}

module.exports = { menu, add, list, rss, exit };

