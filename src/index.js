import Highlighter from './highlightjs.config.js';
import Disqus from './config/disqus.config.js';

import './styles/main.css';
import Elm from './Main.elm';

const app = Elm.Main.embed(document.getElementById('app'));
const disqus = new Disqus();
const highlighter = new Highlighter('pre code');

app
  .ports
  .highlight
  .subscribe(() => setTimeout(() => highlighter.render(), 80));

app
  .ports
  .blogPostCommentsEnabled
  .subscribe(slug => disqus.setup(slug));
