#!/usr/bin/env node

const actions = require('./cli/actions.js');
const { exit } = require('./cli/common.js');

const args = process.argv.slice(2);


switch (args[0]) {
  default:
  case 'list':
    return actions.list().then(exit);

  case 'add':
    return actions.add().then(exit);
}

