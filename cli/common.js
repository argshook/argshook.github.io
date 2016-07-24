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

function writeFileAsync(path, data) {
  return new Promise((resolve, reject) => {
    fs.writeFile(
      path,
      data,
      'utf8',
      err => resolveOrReject(err, data).then(resolve).catch(reject)
    );
  });
}

function resolveOrReject(err, data) {
  return err !== null ? Promise.reject(err) : Promise.resolve(data);
}

function createGuid() {
  function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1);
  }

  return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}

function slugify(string) {
  return string
    .toString()
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^\w\-]+/g, '')
    .replace(/\-\-+/g, '-')
    .replace(/^-+/, '')
    .replace(/-+$/, '');
}


module.exports = {
  readDirAsync,
  writeFileAsync,
  resolveOrReject,
  createGuid,
  slugify
};

