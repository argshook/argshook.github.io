import hljs from '../node_modules/highlight.js/lib/highlight.js';
import '../node_modules/highlight.js/styles/solarized-light.css';

// if i were to call require inside a loop (e.g. ['lang1', 'lang2'].forEach(() => require(...)) )
// then webpack for some reason includes all the languages
hljs.registerLanguage('elm',
  require('../node_modules/highlight.js/lib/languages/elm.js'));

hljs.registerLanguage('javascript',
  require('../node_modules/highlight.js/lib/languages/javascript.js'));

module.exports = hljs;

