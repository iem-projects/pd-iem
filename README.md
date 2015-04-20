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
at [How do I install externals and help files](http://puredata.info/docs/faq/how-do-i-install-externals-and-help-files/)


### Linux Debian and Debian derivates:

    aptitude install puredata
    aptitude install pd-iemlib pd-iemmatrix pd-iemambi pd-iemnet pd-comport pd-iemnet pd-net pd-osc pd-zexy pd-arduino pd-list-abs pd-bsaylor

### Mac OS-X

- per user installation path: `~/Library/Pd`
- global installation path: `/Library/Pd`

### W32

- per user installation path: `%AppData%\Pd`
- global installation path: `%CommonProgramFiles%\Pd`

## Troubleshouting

At the moment send an email to the [pd-list mailing list](http://lists.puredata.info/listinfo/pd-list) for questions,
later a bug tracker might be used.

