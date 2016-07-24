/* globals Promise:true*/

const fs = require('fs');

function readDirAsync(path) {
  return new Promise((resolve, reject) => {
    fs.readdir(
      path,
      (err, data) =>
      resolveOrReject(err, data).then(resolve).catch(reject)
    );
  });
}

function resolveOrReject(err, data) {
  return err !== null ? Promise.reject(err) : Promise.resolve(data);
}

module.exports = { readDirAsync, resolveOrReject };

