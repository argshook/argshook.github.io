const low = require('lowdb');
const db = low('blogs-db.json');

db.defaults({
  posts: []
}).value();

module.exports = db;

