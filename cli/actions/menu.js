/* globals Promise */

const prompt = require('prompt');
const { resolveOrReject } = require('../common');

module.exports = () => menu();

const ACTIONS = {
  1: 'list',
  2: 'add'
};

function menu() {
  const message = `
  Welcome to this amazing CLI!

  USAGE:

    npm run cli [action]


  ACTIONS:

    list - display a table of blog posts
    add - enter prompt to add new post to db.json


  you can choose now:

    1 - list
    2 - add
    q - quit
  `;

  console.log(message);

  return getAction()
    .then(({ choice }) => {
      if (choice === 'q') {
        return Promise.reject();
      }

      return !!ACTIONS[choice] ? Promise.resolve(ACTIONS[choice]) : Promise.reject();
    });
}

function getAction() {
  const promptSchema = {
    properties: {
      choice: {
        pattern: /^[12q]$/,
        description: 'which should i do?',
        message: 'type 1, 2 or q',
        required: true
      }
    }
  };

  return new Promise((resolve, reject) => {
    prompt.start();

    prompt
      .get(promptSchema, (err, result) => resolveOrReject(err, result).then(resolve).catch(reject));
  });
}

