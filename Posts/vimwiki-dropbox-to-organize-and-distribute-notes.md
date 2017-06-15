# vimwiki & dropbox to organize and distribute notes with vim

Vimwiki is a personal wiki for Vim -- a number of linked text files that have
their own syntax highlighting.

install with your favorite plugin manager, by following instructions on [github](https://github.com/vimwiki/vimwiki)

```vim
" this
NeoBundle 'vimwiki/vimwiki'

" or most probably this
Plugin 'vimwiki/vimwiki'
```

set some paths

```vim
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/' }]
```

here i set `~/Dropbox/vimwiki` to keep notes on le cloud. note that it's a list, you can have multiple *wiki*s, say one personal, one work, one very secret encrypted where you save your poetry


## All you need

for brevity below i use `,` as a `<leader>`.

* `,ww` access vimwiki index, a home page. first time it
  will ask if you want to create one
* `,w,w` open diary page with todays date
* `,wi` open diary index, a list of all diary entries

you have to regenerate diary index manually with
`:VimwikiDiaryGenerateLinks`. possible to automate with `autocmd`,
though i never needed that

## Navigate

* `enter` key creates a link out of a word under cursor or selection.
  looks like `[[this]]`
* `enter` again will follow that link
* `backspace` will go back
* `tab` jumps cursor to next link, `shift + tab`  jumps to previous

## Fancy Format

* `=` in **n**ormal mode increases heading size

  `-` decreases it

  it goes from `= this =` up to `====== this ======`
* lines starting with `1.`, `*` or `-` will start a list

  `ctrl + space`, will attach check mark to `* [ ] list item`

  `ctrl + space` again will toggle that `* [X] check mark`

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

## Tips

save something that you can find later? it's `,ww`

empty notepad? it's `,w,w`

same actions for other wikis (if you set more than one in `g:vimwiki_list`):
`2,ww`, `2,w,w`, `3,ww`, `3,w,w` etc.

dropbox automatically syncs different machines and im not littering
system with tiny notes everywhere.

see `:h vimwiki` for more.
