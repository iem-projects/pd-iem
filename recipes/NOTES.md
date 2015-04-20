Pd-iem recipies
===============

a recipe should contain the information needed to (automatically)
build an external.



# things that need to be done:
- fetch dependencies (if needed)
- fetch external
- build external
- install external to a given directory

# things that don't need to be done
- fetch/install Pd
  - the Pd-installation path is provided via environment variables
    - ${PDINCLUDE}: path to Pd-headers
    - ${PDLIBDIR}: path to Pd-dlls
- the destination path is provided via an environment variable ${DESTDIR}.
   the library should install into a firstlevel subdirectory of this
   destination, e.g. ${DESTDIR}/zexy/
- embedding libraries

# embedding libraries
The plan is that you do not need to care about embedding libraries.
On OSX this can be done fully automatically (the resulting binary files
are queried for their dependencies, and those are installed side-by-side),
On W32 we are currently investigating the possibilities to fully automate this
(but it's a bit trickier, as no path information is saved in the binaries).

scratchpad::

    $ i686-w64-mingw32-objdump external.dll | grep "DLL Name: | sed -e 's|^.*DLL Name:||'
    # make sure that all embeddable libraries are in a given path (e.g. `.`) so
    # we can collect them

# Implementation

## simple approach
a recipe is a simple shell-script that performs all of the above tasks.
- advantage: very simple; recipies are standalone!
- advantage: recipies are standalone
- advantage: different fetch methods (wget, svn, zip) can be easily handled
- drawback: dependencies will be fetched (and built?) multiple times,
      with potentially conflicting versions.

### Example

    ## fetch dependencies
    # (nada)
    ## fetch external
    svn export https://svn.code.sf.net/p/pure-data/svn/trunk/externals/iem/iem_tab@17436 iem_tab
    ## build external
    make -C iem_tab/src PD_INCLUDE=${PDINCLUDE}
    ## install the external
    OUTDIR="${DESTDIR}/iem_tab"
    mkdir -p "${OUTDIR}"
    cp iem_tab/iem_tab.pd_darwin "${OUTDIR}/iem_tab.d_fat"
    cp iem_tab/*.pd "${OUTDIR}/"
    cp iem_Tab/*.txt "${OUTDIR}/"

## declarative approach
each recipe declares its dependencies; the dependencies for all recipies
are resolved before the actual build-stages are called.

- advantage: shorter build-times
- advantage: easier to write
- drawback: more complicated to implement

#### Makefile?
borrowing from Debian (debian/rules), why not use 'make' as the syntax for
writing these rules?

### Example:

     upstream=https://svn.code.sf.net/p/pure-data/svn/trunk/externals/iem/iem_tab@17436
     depends=https://raw.githubusercontent.com/iem-projects/homebrew-legacy/master/fftw.rb
     depends+=https://raw.githubusercontent.com/iem-projects/homebrew-legacy/master/gsl.rb
     build:
	make -C src PD_INCLUCE=${PDINCLUDE}
     install:
        install -p -m 755 $(DESTDIR)/iem_tab/
	install -p -m 644 *.pd_darwin $(DESTDIR)/iem_tab/
	install -p -m 644 *.pd $(DESTDIR)/iem_tab/
	install -p -m 644*.txt $(DESTDIR)/iem_tab/
     

