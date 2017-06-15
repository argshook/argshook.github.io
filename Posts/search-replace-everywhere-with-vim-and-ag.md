# Search & Replace everywhere with Vim and `ag`

say you need to change `http://` to `https://` in a lot of files. you can use `ag` within vim to achieve that.

1. if you don't yet have, setup `ag` by following their readme.md on [github](https://github.com/ggreer/the_silver_searcher)
1. `NeoBundle 'rking/ag.vim'` or other kind of vundle to install [Ag](https://github.com/rking/ag.vim) plugin in vim

now in vim you can do this:

```
:Ag http://
:cdo s/http:/https:/g
:bufdo w
```

same, with explanation:

1. `:Ag http://` will search for all `http://` occurrences in the project recursively and opens a location window with results
1. `:cdo s/http:/https:/g` substitutes `http:` with `https:` in all locations
1. `:bufdo w` will save all changes to files
