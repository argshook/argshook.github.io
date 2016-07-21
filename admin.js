#!/usr/bin/env node
/* globals Promise:true*/

const fs = require('fs');
const prompt = require('prompt');

const args = process.argv.slice(2);

prompt.message = '';

switch (args[0]) {
  default:
  case 'list':
    return listPosts().then(exit);

  case 'add':
    return configPost()
      .then(addPost)
      .then(exit);
}

function listPosts() {
  console.log('Current posts:');

  return readDirAsync('./Posts')
    .then(dir =>
          dir.map((file, i) =>
                  console.log(`${i + 1} - %s`, file.split('.')[0])));
}

function configPost() {
  console.log('Add new post');

  prompt.start();

  return new Promise((resolve, reject) => {
    prompt
      .addProperties(
        {},
        ['title', 'author'],
        (err, result) => rejectOrResolve(err, result, resolve, reject)
      );
  });
}

function addPost({ title, author }) {
  console.log(title);
  console.log(author);
  // add to csv from here or something
}

function readDirAsync(path) {
  return new Promise((resolve, reject) => {
    fs.readdir(path, (err, data) => rejectOrResolve(err, data, resolve, reject));
  });
}

function rejectOrResolve(err, data, resolve, reject) {
  return err !== null ? reject(err) : resolve(data);
}

function exit() {
  process.exit(0);
}

