#!/usr/bin/env node

const actions = require('./cli/actions.js');

const [action] = process.argv.slice(2);

if (!action) {
  return actions.menu().then(action => {
    return actions[action]();
  });
}

switch (action) {
  default:
  case 'list':
    return actions.list().then(actions.exit);

  case 'add':
    return actions.add().then(actions.exit);
}

