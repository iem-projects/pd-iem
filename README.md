Pd IEM Distribution
===================

The Pure Data IEM Distribution (short PIDIST) is a binary collection of core Pd
libraries.

Releases are done whenever one or more of the libraries have a major update.

A main goal is to use Pd-vanilla standard search paths as much as possible and
to use the proposed structure of the used libraries as intended by their
authors.

Note: Linux binary distributions are well supported by the resp. package
managers, so we do not provide linux binaries here; just install Pd-vanilla and
the individual packages as listed below.


## included libraries

- iemlib (iemlib1,iemlib2,iemabs)
- iemmatrix
- iem_ambi
- iem_tab
- comport
- iemnet, net (use optional one of ths)
- osc
- zexy
- arduino
- windowing
- list-abs
- bsaylor

(For Gem, also developed at IEM, use the [separate download page](http://gem.iem.at/))

## Installation

Unpack the downloaded file and copy the contents to one of the places proposed
at [How do I install externals and help files](http://puredata.info/docs/faq/how-do-i-install-externals-and-help-files/) (or see below).


### Linux Debian and Debian derivates:

    aptitude install puredata
    aptitude install pd-iemlib pd-iemmatrix pd-iemambi pd-iemnet pd-comport pd-iemnet pd-net pd-osc pd-zexy pd-arduino pd-list-abs pd-bsaylor

### Mac OS-X

- per user installation path: `~/Library/Pd`
- global installation path: `/Library/Pd`

### W32

- per user installation path: `%AppData%\Pd`
- global installation path: `%CommonProgramFiles%\Pd`

#### on W32 search paths

Until very recently (`Pd<=0.46-6`!), the default W32 search paths were unfortunately slightly broken and used
- global installation path: `%ProgramFiles%\Common Files\Pd` (this expands to the same value as `%AppData%\Pd` on *Windows-XP* and *Windows7*, though the behaviour might change in the future)
- per user installation path: `%UserProfile%\Application Data\Pd` (this expands to the same value as `%CommonProgramFiles%\Pd` on *Windows-XP*; but **not** and *Windows7*)

To avoid confusion we suggest installing the externals in the *global installation path* for now (until `Pd>=0.46-7` is released).

## Troubleshouting

At the moment send an email to the [pd-list mailing list](http://lists.puredata.info/listinfo/pd-list) for questions,
later a bug tracker might be used.



## FAQ

#### Q: I extracted the ZIP-file, but Pd still cannot find the new objects

- The target directory should contain the *contents* of the `pd-iem` directory.
E.g. you should have folder named `iemlib`, but **not** a folder named `pd-iem` at your destination.

- If nothing helps, start Pd with `-verbose` (in the *Path* preferences, check the `verbose` toggle, and restart Pd):
this will make Pd print out all the places where it looks for the library.
Compare that list to the directory you put your externals into.
