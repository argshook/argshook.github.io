/*global DISQUS*/

export default class Disqus {
  constructor() {
    this.isScriptLoading = false;
    this.currentIdentifier = "";
  }

  setup(identifier) {
    this.currentIdentifier = identifier;

    window.disqus_shortname = 'argshood';
    window.disqus_identifier = this.currentIdentifier;
    window.disqus_url = window.location.href;
    window.disqus_title = document.title;

    if (!this.ready()) { return; }

    setTimeout(this.resetDisqus.bind(this), 80);
  }

  ready() {
    if(!this.isScriptLoading) {
      this.isScriptLoading = true;
      this.loadDisqus();
      return false;
    }

    return typeof window.DISQUS !== 'undefined';
  }

  loadDisqus() {
    var d = document,
        s = d.createElement('script');

    s.src = '//argshood.disqus.com/embed.js';

    s.onload = () => {
      this.setup(this.currentIdentifier);
    }

    s.setAttribute('data-timestamp', +new Date());
    (d.head || d.body).appendChild(s);
  }

  resetDisqus() {
    let identifier = this.currentIdentifier;

    window.disqus_config = function() {
      this.page.identifier = identifier;
    };

    console.log(this.currentIdentifier);
    DISQUS.reset({
      reload: true,
      config: function () {
        this.page.identifier = identifier;
      }
    });
  }
}

