const { readDirAsync } = require('../common.js');

module.exports = () => list();

function list() {
  console.log('Current posts:');

  return readDirAsync('./Posts')
    .then(dir =>
      dir.map((file, i) =>
        console.log(`${i + 1} - %s`, file.split('.')[0])));
}

