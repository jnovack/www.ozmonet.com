---
layout: note
title: Vim
last_modified: 2010-12-28 12:34:00 -0500
---
#### Colors while in 'sudo'

One of the biggest annoyances I have had with vi/vim is getting my colors and prefs all setup to be taken away when I am editing a file in sudo, where it is probably most important to see highlighting.

The problem is that aliases do not translate into sudo:

    [root@yourmom ~]# which vi
    alias vi='vim'
    /usr/bin/vim

    [root@yourmom ~]# sudo which vi
    /bin/vi

Editing the root `.bashrc` file or `/etc/bashrc` will not work with setting aliases.

The best fix that I have found is putting the following in `/etc/bashrc`

    alias sudo='A=`alias` sudo '

The "A" is there as a environment variable just as a trick to run alias before running sudo.

#### Tips and Tricks

Delete lines that contain string:

    :g/string/d

Turn on|off line numbering:

    :set [nu|nonu]

Number lines (filter the file through a unix command and replace with output):

    :%!cat -n

Sort lines:

    :%!sort

Sort and uniq:

    :%!sort -u

Set textwidth for automatic line-wrapping as you type:

    :set textwidth=80

Turn on|off syntax highlighting

    :syn [on|off]

Redo your last undo

    [Ctrl-r]

Force the filetype for syntax highlighting:

    :set filetype=php

Use lighter coloring scheme for a dark background:

    :set background=dark

Write part of a file to another file

    :1,10:w newfile

Append more data to the same file

    :21,30:w >>newfile

Buffers

Yank 4 lines into buffer f

    "f4yy

Yank 6 more lines into buffer f (note use of uppercase)

    "F6yy

Paste it all from buffer f

    "fp

Get back the second to last delete you made

    "2p

##### Moving Blocks of Text

You can move blocks of text delimited by patterns. For example, assume you have a 150-page reference manual. All references pages are organized into three paragraphs with the same three headings: SYNTAX, DESCRIPTION, and PARAMETERS. A sample of one reference page follows:

    .Rh 0 "Get status of named file" "STAT"
    .Rh "SYNTAX"
    .nf
    integer*4 stat, retval
    integer*4 status(11)
    character*123 filename
    retval = stat (filename, status)
    .fi
    .Rh "DESCRIPTION"
    Writes the fields of a system data structure into the
    status array.  
    These fields contain (among other
    things) information about the location of the file,
    access privileges, owner, and time of last modification.
    .Rh "PARAMETERS"
    .IP "\fBfilename\fR" 15n
    A character string variable or constant containing
    the UNIX pathname for the file whose status you want
    to retrieve.  

Suppose that it is decided to move the SYNTAX paragraph below the DESCRIPTION paragraph. Using pattern matching, you can move blocks of text on all 150 pages with one command!

    :g/SYNTAX/,/DESCRIPTION/-1 mo /PARAMETERS/-1

This command operates on the block of text between the line containing the word SYNTAX and the line just before the word DESCRIPTION (/DESCRIPTION/-1). The block is moved (mo) to the line just before PARAMETERS (/PARAMETERS/-1). Note that vi can place text only below the line specified. To tell vi to place text above a line, you first have to move up a line with -1, and then place your text below. In a case like this, one command saves literally hours of work. (This is a real-life example - we once used a pattern match like this to rearrange a reference manual containing hundreds of pages.)

Block definition by patterns can be used equally well with other vi commands. For example, if you wanted to delete all DESCRIPTION paragraphs in the reference chapter, you could enter:

    :g/DESCRIPTION/,/PARAMETERS/-1d

This very powerful kind of change is implicit in the line addressing syntax, but it is not readily apparent even to experienced users. For this reason, whenever you are faced with a complex, repetitive editing task, take the time to analyze the problem and find out if you can apply pattern-matching tools to do the job.

#### Searching

Find the first instance of `in` after `the`

    /the/;/in/

#### Abbreviations

You can define abbreviations that vi will automatically expand into the full text whenever you type the abbreviation during text-input mode. To define an abbreviation, use the ex command:

    :ab abbr phrase

abbr is an abbreviation for the specified phrase. The sequence of characters that make up the abbreviation will be expanded during text-input mode only if you type it as a full word; abbr will not be expanded within a word. [I abbreviate Covnex to Convex, a company name, because I have dyslexic fingers. -TC ]

Suppose you want to enter text that contains a phrase that occurs frequently, such as a difficult product or company name. The command:

    :ab ns the Nutshell Handbook

abbreviates the Nutshell Handbook to the initials ns. Now whenever you type ns as a separate word during text-input mode, ns expands to the full text.

Abbreviations expand as soon as you press a non-alphanumeric character (e.g., punctuation), a carriage return, or ESC (returning to command mode). An abbreviation will not expand when you type an underscore ( _ ); it is treated as part of the abbreviation. When you are choosing abbreviations, choose combinations of characters that do not ordinarily occur while you are typing text. If you create an abbreviation that ends up expanding in places where you do not want it to, you can disable the abbreviation by typing:

    :unab abbr

To list your currently defined abbreviations, type:

    :ab

#### .vimrc

##### Indent Toggle

Use these to change indents. Change indent to your preference for indenting. I use \t for a complete tab. Combined with [Shift-V], you can move whole blocks left and right easily.

    map <F7> :s/^indent// <CR> :noh <CR> gv
    map <F8> :s/^/indent/ <CR> :noh <CR> gv

#### References

 1. [http://ask.slashdot.org/article.pl?sid=08/11/06/206213&from=rss](http://ask.slashdot.org/article.pl?sid=08/11/06/206213&from=rss)
 2. [http://vim.wikia.com/wiki/Best_Vim_Tips](http://vim.wikia.com/wiki/Best_Vim_Tips)
 3. [http://tjl2.com/sysadmin/vim-cheat-sheet.html](http://tjl2.com/sysadmin/vim-cheat-sheet.html)
