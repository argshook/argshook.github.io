const db = require('../db');
const { readDirAsync } = require('../common.js');
const Table = require('cli-table');

module.exports = () => list();

const table = new Table({
  head: ['#', 'Author', 'Title', 'Has .md', 'Created', 'Modified'],
  colWidth: [10, 100, 300, 10, 50, 50]
});

function list() {
  return readDirAsync('./Posts')
    .then(postsFiles => {
      const posts = db
        .get('posts')
        .map((post, i) => {
          const { author, title, path, dateCreated, dateModified } = post;
          const hasMd = postsFiles.indexOf(path) !== -1;

          table.push([
            i,
            author,
            title,
            hasMd,
            new Date(dateCreated).toGMTString(),
            !!dateModified ? new Date(dateModified).toLocaleString() : '',
          ]);

          return post;
        })
        .value();

      console.log(table.toString());

      return posts;
    });
}

