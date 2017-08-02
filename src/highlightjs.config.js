import hljs from 'hljs/lib/highlight.js';
import 'hljs/styles/zenburn.css';

export default class {
  constructor(selector) {
    this.selector = selector;

    this.registerLanguages();
  }

  registerLanguages() {
    // if i were to call require inside a loop (e.g. ['lang1',
    // 'lang2'].forEach(() => require(...)) ) then webpack for some
    // reason includes all the languages

    hljs.registerLanguage(
      'elm',
      require('../node_modules/highlight.js/lib/languages/elm.js')
    );

    hljs.registerLanguage(
      'javascript',
      require('../node_modules/highlight.js/lib/languages/javascript.js')
    );

    hljs.registerLanguage(
      'html',
      require('../node_modules/highlight.js/lib/languages/xml.js')
    );

    hljs.registerLanguage(
      'vim',
      require('../node_modules/highlight.js/lib/languages/vim.js')
    );
  }

  render() {
    return Array
      .from(global.document.querySelectorAll(this.selector))
      .map(hljs.highlightBlock);
  }
}
