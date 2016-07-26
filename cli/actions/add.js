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


module.exports = () => {
  console.log('Create new post');
  console.log('');

  return createPost()
    .then(lookupPost)
    .catch((post) => {
      console.log(`Post with this title already exists: ${post.title}`);
      console.log('Please try another name');
      console.log('');

      return createPost();
    })
    .then(newPost);
};


function createPost() {
  const promptSchema = {
    properties: {
      title: {
        description: 'Post Title',
        required: true
      },
      author: {
        description: 'Post Author'
      }
    }
  };

  prompt.start();

  return new Promise((resolve, reject) => {
    prompt.get(promptSchema, (err, result) =>
      resolveOrReject(err, result).then(resolve).catch(reject)
    );
  });
}

function lookupPost(post) {
  const dbPost = db.get('posts').find({ title: post.title }).value();
  return !!dbPost ? Promise.reject(post) : Promise.resolve(post);
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

      logNewPost(newPost);
    });
}

function logNewPost(newPost) {
  console.log('This was added to db.json:');
  console.log('');
  console.log(JSON.stringify(newPost, null, 2));
}
