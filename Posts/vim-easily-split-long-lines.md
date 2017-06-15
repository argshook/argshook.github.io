# Vim: easily split long lines

long lines usually is not a good thing, especially in code.

to split long lines into column of some width, use `:set textwidth=72`

this will limit your typing to 72 and add line breaks automatically.

sufficient for new text but what if you want to edit and format existing one?

answer is `gq`:

> `gq{motion}` - Format the lines that `{motion}` moves over.

## Usage

1. `set textwidth=72` define max num of chars to allow in one line
1. type new text, wow vim adds line break past 72nd char.

   or

   `gqap` to wrap **A** **P**aragraph under cursor

   or

   `vap` to **V**isually select **A** **P**aragraph, and then wrap with `gq`.

## Tips

a shorter version of `textwidth=72` is `tw=72`

goes well with `autocmd`, you can prevent yourself from long lines in markdown readmes or git commit messages:

```vim
autocmd Filetype gitcommit,markdown setlocal textwidth=72
```

look at `:help textwidth` and `:help gq` to know more

