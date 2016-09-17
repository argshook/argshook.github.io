import './styles/main.css';

import hljs from './highlightjs.config.js';
import Elm from './Main.elm';
import Disqus from './config/disqus.config.js';

const app = Elm.Main.embed(document.getElementById('app'));
const disqus = new Disqus();

app
  .ports
  .highlight
  .subscribe(() => setTimeout(highlight, 80));

app
  .ports
  .blogPostCommentsEnabled
  .subscribe(slug => disqus.setup(slug));

function highlight() {
  const blocks = document.querySelectorAll('pre code');

  for (let i = 0; i < blocks.length; i++) {
    hljs.highlightBlock(blocks[i]);
  }
}

