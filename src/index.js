import Highlighter from './js/highlightjs.js';
import Disqus from './js/disqus.js';

import './styles/main.css';
import Elm from './Main.elm';
import { posts } from '!json-loader!../db.json';

const flags = posts;

const app = Elm.Main.embed(document.getElementById('app'), flags);
const disqus = new Disqus();
const highlighter = new Highlighter('pre code');

app
  .ports
  .highlight
  .subscribe(() => {
    setTimeout(() => highlighter.render(), 80);
    window.scrollTo(0, 0);
  });

app
  .ports
  .blogPostCommentsEnabled
  .subscribe(slug => disqus.setup(slug));
