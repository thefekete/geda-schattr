schattr version 0.1
===================

A bash shell script to update sheet attributes in one or more gEDA gschem schematics

`schattr` can be used to update specific "sheet attributes" in a schematic, or more practically in a schematic's title block. See below for a list of the special attributes that can be used.

usage:
------

Download the `schattr` script file and put it somewhere in your path.

Then, add any of the following attributes to your schematic:

  * sheet-author
  * sheet-date
  * sheet-filename
  * sheet-pagenumber
  * sheet-pagetotal
  * sheet-project
  * sheet-revision
  * sheet-title

The examples folder contains example title block symbols with the attributes, but be careful to always select "Include component as individual objects" in the symbol selection dialog. By doing this, you add "unattached attributes" at the top level of the schematic, which makes more sense anyways.

If you don't, this script will still work, but the next time you run `gattrib` the attributes columns of every othercomponent will be littered with the sheet attributes. Adding "graphical=1" won't help either. I usually then select the entire title block and lock it with E L.

After that, you can update the attributes from the command line:

    schattr [options] schematic [schematic2 ...]
    schattr --pages *.sch  # update page attrs for all sch files in dir
    schattr --title 'My design' my.sch  # set title of schematic

be aware of...
--------------

`schattr` will automatically update the sheet-date attribute with the file's last modified date, unless you specify another one with the '--date' option.

It also bases the sheet-pagetotal attribute on how many files it's given when run with the '--pages' option. The schematic's sheet-pagenumber attribute is then determined by the order it appears on the command line, starting with one.

The sheet-title attribute is meant to be the title of that specific schematic page. It should therefore only be updated one file at a time, or just edit it in gschem.

options:
--------

    --author VAL    set author attr 
    --date VAL      set date attr (def: file mtime)
    --filename VAL  set filename attr 
    --pages VAL     set pagenumber and pagetotal attrs
    --project VAL   set project attr 
    --revision VAL  set revision attr 
    --title VAL     set title attr 
    -v              increase verbosity
    -h, --help      print this message and exit
    -V              print version and exit
    --              options terminator

description of supported sheet attributes
-----------------------------------------

    sheet-author        schematic's author
    sheet-date          schematics last modification
    sheet-filename      schematics filename
    sheet-pagenumber    schematic's page number
    sheet-pagetotal     number of schematics in project
    sheet-project       project name (same for all schematics)
    sheet-revision      project revision number (same for all schematics)
    sheet-title         schematic's title

