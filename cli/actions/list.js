const { readDirAsync } = require('../common.js');

function list() {
  return listPosts();

  function listPosts() {
    console.log('Current posts:');

    return readDirAsync('./Posts')
    .then(dir =>
          dir.map((file, i) =>
                  console.log(`${i + 1} - %s`, file.split('.')[0])));
  }
}

module.exports = list;

