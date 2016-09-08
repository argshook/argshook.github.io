# Vim: easily split long lines

i like to see many vim and terminal splits at once. this way i avoid
switching contexts (read: alt-tabbing) and have all i need right in
front of me.

however, this means that text i'm reading must be either wrapped to fit
screen or be written in rather short columns.

this is where `textwidth` comes in. If you do `:set textwidth=72` then
type a long line of text, vim will automatically add line breaks where
needed and wont let you type lines longer than 72 characters.

well that's nice but what if you already have written text which is
longer than 72 (or whatever) characters long?

i'm glad you asked.

an easy way to split already written lines is to use `gq` command:

* `set textwidth=72` - define desired length of lines
* `ggvG` - do a visual selection on all file (or only on lines you want to split)
* `gq` - magic

if you're like me, `textwidth` is of course too long to type. Use
`tw=72` instead.

as always, `:help textwidth` or `:help gq` will shed more light on this.

