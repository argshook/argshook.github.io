/* globals Promise:true*/

const fs = require('fs');

function readDirAsync(path) {
  return new Promise((resolve, reject) => {
    fs.readdir(
      path,
      (err, data) =>
      rejectOrResolve(err, data).then(resolve).catch(reject)
    );
  });
}

function rejectOrResolve(err, data) {
  return err !== null ? Promise.reject(err) : Promise.resolve(data);
}


function exit() {
  process.exit(0);
}

module.exports = { readDirAsync, rejectOrResolve, exit };

