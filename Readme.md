# Volume Name Icon Reader #

## What is it? ##

Volume Name Icon Reader is a (very) small tool capable of reading the
image file Mac OS X will use to display the volume name when booting with
the alt key down.
You can see [this article][refit_volume_labels] for more explanations.

[refit_volume_labels]: http://refit.sourceforge.net/info/vollabel.html

## Example of Use ##

Type the following in Terminal (this is innocent: it will just copy a file
on your desktop and make it visible):

```shell
cp /System/Library/CoreServices/.disk_label ~/Desktop/file.vollabel
chflags nohidden ~/Desktop/file.vollabel
```
Then just open the file `file.vollabel` on your desktop (after installing/compiling Volume Name Icon
Reader on your machine, indeed!).

The image will show up at the very bottom left of the window.
