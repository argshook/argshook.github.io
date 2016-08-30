/*global DISQUS*/

export default class Disqus {
  constructor() {
    this.isScriptLoading = false;
    this.currentSlug = "";
  }

  setup(slug) {
    this.currentSlug = slug;

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
      this.setup(this.currentSlug);
    }

    s.setAttribute('data-timestamp', +new Date());
    (d.head || d.body).appendChild(s);
  }

  resetDisqus() {
    let slug = this.currentSlug;
    DISQUS.reset({
      reload: true,
      config: function () {
        this.page.identifier = slug;
        this.page.url = window.location.href;
      }
    });
  }
}

