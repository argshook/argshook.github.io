# wimviki & dropbox to organize and distribute notes with vim

Vimwiki is a personal wiki for Vim -- a number of linked text files that have
their own syntax highlighting.

install with your favorite plugin manager, by following instructions on [github](https://github.com/vimwiki/vimwiki)

```vim
" this
NeoBundle 'vimwiki/vimwiki'

" or most probably this
Plugin 'tpope/vim-fugitive'
```

set some paths

```vim
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/', 'path_html': '~/Public/html/vimwiki/'}]
```

here i set `~/Dropbox/vimwiki` to keep notes on le cloud and
`~/Public/html/vimwiki/` for saving them transformed to html. vimwiki
can do that easily so why not.

note that it's a list, meaning you may have multiple *wiki*s


## Quick workfow

> *Note*: for brevity below i use `,` as a `<leader>`.

1. `,ww` - access vimwiki index. sort of like home page. first time it
   will ask you if you want to create one.
2. `,w,w` - open diary page for today. this is great for when you need a
   scratchpad
3. `,wi` - open diary index. you need to regenerate it manually with
   `:VimwikiDiaryGenerateLinks`. automate that if diary index is something
   you need daily

once you're at some vimwiki page:

1. `=` in **n**ormal mode increases heading size
2. `-` decreases it
3. `enter` key will make a link out of a word under cursor or selection.
   It looks like `[[this]]`
4. `enter` again will follow that link
4. `backspace` will go back to previous page
5. line starting with `1.`, `*` or `-` will make consecutive lines
   follow initial pattern, as a list
6. `ctrl + space` while on such list, will attach check mark to list
   item
7. `ctrl + space` again will toggle that checkmark

to write code blocks wrap code with `{{{` and `}}}`:

```html
== thingies ==

1. [ ] do dis
2. [X] do dat

memorize this command:

{{{sh
cd ~
}}}

```

---

Essentially, whenever i need to save text in a little more organized
manner, hit `,ww`, nagivate or create new link for that text,
paste/type.

if i'm in need of a clean notepad, hit `,w,w` and there it is.

dropbox automatically syncs through different machines, cool and fun and
all that

there's plenty more vimwiki can do, consult `:h vimwiki`

