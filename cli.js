#!/usr/bin/env node

const actions = require('./cli/actions.js');

const [action] = process.argv.slice(2);

const availableActions = ['list', 'add', 'rss'];
const defaultAction = 'list';

if (!action) {
  return actions.menu().then(action => {
    return actions[action]();
  })
  .catch(() => console.log('action canceled'));
}

return actions[availableActions.includes(action) ? action : defaultAction]()
  .then(actions.exit)
  .catch(console.log);

