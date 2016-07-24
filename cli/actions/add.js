/* globals Promise */
const prompt = require('prompt');
prompt.message = '';

const db = require('../db.js');
const {
  writeFileAsync,
  resolveOrReject,
  createGuid,
  slugify
} = require('../common.js');


module.exports = () =>
  createPost()
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

