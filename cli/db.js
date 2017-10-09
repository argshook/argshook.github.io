const low = require('lowdb');
const db = low('db.json');

db
  .defaults({
    posts: []
  })
  .write();

module.exports = db;
