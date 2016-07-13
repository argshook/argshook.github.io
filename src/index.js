import './styles/main.css';

import hljs from './highlightjs.config.js';
import Elm from './Main.elm';

const app = Elm.Main.embed(document.getElementById('app'));

app.ports.highlight.subscribe(() => setTimeout(highlight, 80));

function highlight() {
  const blocks = document.querySelectorAll('pre code');

  for (let i = 0; i < blocks.length; i++) {
    hljs.highlightBlock(blocks[i]);
  }
}

