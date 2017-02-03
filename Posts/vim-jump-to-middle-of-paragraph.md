# vim - jump to middle of paragraph

has this ever happened to you? there's this big paragraph and you need
to get somewhere near the middle of it?

wouldn't it be great to have something similar to `M` which allows to
jump to middle of screen but instead work on paragraph?

with this simple weird trick in your `.vimrc` now you can do it!

```vim
function! JumpToMiddleOfParagraph()
  let line = float2nr(round((line("'}") + line("'{")) / 2))
  execute "normal! " . line . "G"
endfunction
```

i chose `T` to run such function when in normal mode:

```vim
nnoremap T :call JumpToMiddleOfParagraph()<CR>
```

