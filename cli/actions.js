/* globals Promise */
const prompt = require('prompt');

const db = require('./db.js');
const { readDirAsync, resolveOrReject } = require('./common.js');

prompt.message = '';

function add() {
  return createPost().then(savePost);

  function createPost() {
    console.log('create new post');

    prompt.start();

    return new Promise((resolve, reject) => {
      prompt
      .addProperties(
        {},
        ['title', 'author'],
        (err, result) =>
        resolveOrReject(err, result).then(resolve).catch(reject)
      );
    });
  }

  function savePost({ title, author }) {
    console.log('save new post');

    const posts = db
      .get('posts')
      .push({ title, author })
      .value();

    return Promise.resolve(posts);
  }
}

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


module.exports = { add, list };

