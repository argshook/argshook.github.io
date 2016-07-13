import './styles/main.scss';
import '../node_modules/basscss/css/basscss.css';
import '../node_modules/basscss-forms/index.css';

import '../node_modules/highlight.js/styles/solarized-light.css';
import hljs from 'highlight.js';

const Elm = require('./Main.elm');

const app = Elm.Main.embed(document.getElementById('app'));

window.hljs = hljs;
app.ports.highlight.subscribe(() => {
  setTimeout(highlight, 100);
});

function highlight() {
  const blocks = document.querySelectorAll('pre code');

  for(let i = 0; i < blocks.length; i++) {
    hljs.highlightBlock(blocks[i]);
  }
}

