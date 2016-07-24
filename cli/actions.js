/* globals Promise */
const prompt = require('prompt');

const db = require('./db.js');
const { readDirAsync, resolveOrReject } = require('./common.js');

prompt.message = '';

function add() {
  return createPost()
    .then(lookupPost)
    .catch(editPost)
    .then(newPost);

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

  function lookupPost(post) {
    const dbPost = db.get('posts').find({ title: post.title }).value();
    return !!dbPost ? Promise.reject(post) : Promise.resolve(post);
  }

  function editPost(post) {
    db
      .get('posts')
      .find({ title: post.title })
      .assign(post)
      .value();

    return Promise.reject();
  }

  function newPost(post) {
    console.log('saving %s', post.title);

    const posts = db
      .get('posts')
      .push(post)
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

function exit() {
  process.exit(0);
}

module.exports = { add, list, exit };

