/* globals Promise */
const prompt = require('prompt');

const db = require('./db.js');
const {
  readDirAsync,
  writeFileAsync,
  resolveOrReject,
  createGuid,
  slugify
} = require('./common.js');

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
    console.log('Editing existing post');
    console.log(post.title);

    post.dateModified = new Date().getTime();

    db
      .get('posts')
      .find({ title: post.title })
      .assign(post)
      .value();

    return Promise.reject();
  }

  function newPost(post) {
    console.log('Adding new post');
    console.log(post.title);

    const newPost = {
      id: createGuid(),
      slug: slugify(post.title),
      dateCreated: new Date().getTime(),
    };

    newPost.path = `${newPost.slug}.md`;

    return writeFileAsync(`./Posts/${newPost.path}`, `# ${post.title}`)
      .then(() => {
        db
          .get('posts')
          .push(Object.assign({}, post, newPost))
          .value();
      });
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

