const low = require('lowdb');
const db = low('db.json');

db.defaults({
  posts: []
}).value();

module.exports = db;

