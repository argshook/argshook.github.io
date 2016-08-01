#!/usr/bin/env node

const actions = require('./cli/actions.js');

const [action] = process.argv.slice(2);

const availableActions = ['list', 'add'];
const defaultAction = 'list';

if (!action) {
  return actions.menu().then(action => {
    return actions[action]();
  });
}

return actions[availableActions.includes(action) ? action : defaultAction]()
  .then(actions.exit);

