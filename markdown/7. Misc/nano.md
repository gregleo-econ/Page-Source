+3

# My Nano Edtior Config

I like to use the nano editor on-the-go. After a few years of using emacs, I appreciate the minimalism. The combination of macros and regex find/replace make it a perfectly usable system.

## Screenshot 

![Nano Editor](../files/Images/nano.JPG)

## Config

Note: Some of these features (such as minibar and macros) are only available in the latest versions of nano. 

```{r,nano,eval=FALSE, echo=TRUE}
set autoindent
set constantshow
set minibar
set minicolor bold,white,black
set nohelp 
set softwrap

bind ^a recordmacro main
bind ^c copy main
bind ^d findnext main
bind ^f whereis main
bind ^g cancel all
bind ^i insert main
bind ^o writeout main
bind ^r replace main
bind ^s runmacro main
bind ^t gotoline main
bind ^u redo main
bind ^v paste  main
bind ^x cut main
bind ^z undo main
bind M-f delete main
bind M-g mark main
bind M-h end main main
bind M-i up main
bind M-j left main
bind M-k down main
bind M-l right main
bind M-m nextword main
bind M-n prevword main
bind M-o end main
bind M-q exit main
bind M-u home main
```
