# Search & Replace everywhere with Vim and Ag

i somehow decided recently to move my domain associated with github to
https. [CloudFlare](https://www.cloudflare.com/ssl/) gives such thing away for free so why not make the web
safer on my part as well.

good candidate for such task was my subreddit tv toy app notoriously
known as [orodarius](https://arijus.net/orodarius). Here's it's
[source](github.com/argshook/orodarius) (**trigger warning:** it's angular 1.5!).

since i configured domain to be served through https, i had to make
sure all requests from my toy app are also on https.

in essence this meant a big search throughout project files and a
replace each `http` occurrence with `https`.

some might say i could've removed `http:` part and leave urls schemaless
but according to [Paul Irish](http://www.paulirish.com/2010/the-protocol-relative-url/)
it's an anti-pattern and who am i not to trust him.

having vim with [Ag](https://github.com/ggreer/the_silver_searcher)
certainly helped though you could go away without it i guess.

here's the whole process:

* `:Ag http://` search for all `http://` occurrences in the project
* `:cdo s/http:/https:/g` - substitute `http:` with `https:` in all
locations found by Ag
* `:bufdo w` - write all buffers (probably pretty much same as `:wa`)

---

i know what you're thinking: "but my sublime has a nice button to do
this".


well, yes, it does. but does your sublime have occasional ascii
artifacts and scrolls really slow?

didn't think so.

