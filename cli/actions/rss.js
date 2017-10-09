/* global Promise */
const RSS = require('rss');
const path = require('path');
const { readFileAsync, writeFileAsync } = require('../common.js');

module.exports = () => {
  return createRss()
    .then(writeRss)
    .catch(console.log)
};


const input = 'db.json';
const output = 'rss.xml';
const cwd = '../../';

function createRss() {
  const feed = new RSS({
    title: 'arijus.net',
    description: 'personal blog',
    feed_url: 'https://arijus.net/rss.xml',
    webMaster: '@argshook',
  });

  const itemPromises = require(absPath(input)).posts
    .map(post =>
      readFileAsync(absPath('Posts', post.path))
        .then(content => ({
          title: post.title,
          description: content,
          guid: post.id,
          url: `https://arijus.net/#blog/${post.slug}`,
          author: post.author,
          date: new Date(post.dateCreated)
        }))
        .catch(err => console.log(`Error: unable to read ${absPath('Posts', post.path)}`, err)));

  return Promise.all(itemPromises)
    .then(items => {
      items.map(item => feed.item(item));
      return feed.xml({ indent: true });
    })
    .catch(error => console.log('Error: unable to create post item for rss', error));
}

function absPath(...pathSteps) {
  return path.resolve(__dirname, cwd, ...pathSteps);
}

function writeRss(rss) {
  return writeFileAsync(absPath(output), rss)
    .then(() => console.log(`Success: ${input} converted to ${output}!`))
    .catch(() => console.log(`Error: unable to convert ${input} to ${output}`));
}
