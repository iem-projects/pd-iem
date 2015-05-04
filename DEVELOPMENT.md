Pd IEM Distribution Development
===============================

- Follow the spirit of upstream!

- When fixing bugs in upstream, make sure that this doesn't break thing outside the scope of Pd-iem

## Supported Operating Systems

Currently we support building externals on two systems:

- `osx`: builds fat (i386, amd64) binaries that must run on OSX-10.5 and upwards. Builds are run natively (on an OSX host)
- `w32`: builds i386 binaries that must run on XP and upwards. Builds are cross-compiled using MinGW-64 (on a linux host)

## Running a build

Simply run the `ALL.sh` script in the root of *pd-iem*.
It should do all things necessary for you,
but you need to tell it for which Operating System (currently either `osx` or `w32`) you want to build.

    ./ALL -s w32

If all goes well, you should find a zip-file in the (probably created) `dist/` folder,
containing all built externals and abstractions.

### Step by step

There are three main steps to build `pd-iem`:

- `prepare.sh` will download the sources for all the libraries; it will also install any dependencies (including Pd)

- `build.sh` will run the `Makefiles` for the libraries to compile any externals

- `install.sh` will install the libraries (including help-patches, examples,...) into subfolders of `dist/pd-iem`

The `ALL.sh` script really only runs these three scripts for you.


## Adding a new library

All libraries are fetched/built/installed via simple Makefiles, which you find in the `recipes/` directory.
Each library *must* have a separate Makefile for each Operating System, which is named `<library>.<os>`, e.g.

- `foolib.w32`
- `foolib.osx`

Each Makefile must provide the following targets
- `depends`
- `build`
- `install`
- `clean` (this is currently unused)

Each Makefile (for the various recipes) is executed in a separate directory.
You can freely add/remove files in this directory (and subdirectory), but please:
- don't modify content outside your directory (e.g. in `../`)
- do not expect content outside your directory (e.g. If you library depends on `libfoo` and
you know that another library also depends on `libfoo`, you must not attempt to share the dependency;
use a separate download for each library).


### `depends`: prepare the build
This target is supposed to fetch the source code of a given library.
When downloading the source code via a VCS (Version Control System, like `cvs`, `svn` or `git`),
make sure that you specify the exact revision (please don't track a moving target, like the `trunk` branch).
You might also want to remove any previous download of the library, to avoid side-effects.

Example:

    depends:
		rm -rf foolib
		svn export -q https://svn.code.sf.net/p/pure-data/svn/trunk/externals/foolib@12345 foolib


If your library requires external dependencies not available on the build-host, you must install them as well.
If there are binary packages of the dependency available for your OS, feel free to use them
(otherwise, you will need to build the dependencies from sources).

Example:

    depends:
		rm -rf foolib
		svn export -q https://svn.code.sf.net/p/pure-data/svn/trunk/externals/foolib@12345 foolib
	# foolib requires fftw
 	    wget -c -O "fftw.zip" "ftp://ftp.fftw.org/pub/fftw/fftw-3.3.4-dll32.zip" && \
                unzip -qd "fftw" "fftw.zip"

### `build`: create binaries

Example:

    build:
    	make -C foolib PD_PATH=$(PDDIR)

### `install`: assemble for distribution
This target must install all files you want to distribute in the `$(DESTDIR)/<library>` directory.
The `$(DESTDIR)` directory is given as a variable.

If possible, use the `install` target of your library's Makefile; if there is none, install the files manually.

Example:

    install:
        make -C foolib install
	# but this forgets the wav-files, so we install them manually:
	    install -p -m 755 -d $(DESTDIR)/foolib/
	    install -p -m 644 foolib/*.wav $(DESTDIR)/foolib/

## the build environment

### Filesystem layout

- `build/`: this is where the libraries and their dependencies are extracted and built. Each library gets a sandboxed directory `build/<library>.<os>/`

- `dist`: this is were the distribution is bundled; it contains a a single subdirectory `pd-iem` that can be zipped to get a distributable.

### Variables

#### Pd-installation
You must **not** assume, that the build-host has a standard Pd-installation (e.g. in `/Applications`, `%ProgramFiles%` or `/usr/bin`)

Instead, Pd-iem is built against a local download of Pd-vanilla (see `ingredients-<os>.sh`).
The exact location of this installation is given in the following variables:

- `PDDIR`: path to the resources of a Pd-installation (the directory that contains `bin/` and `src/`).

- `PD_INCLUDE`: path to the Pd header files  (`$(PDDIR)/src`)

For compatibility with Pd-extended Makefiles, the Pd-headers are *also* available in `$(PDDIR)/include/pd`.

#### config.mk

TODO


## Embedding Dependencies
Do not worry about embedding the dependencies.
The build-system will try to find all the libraries that your binaries depend on and put them into a safe place.

### Embedding OSX-dependencies
All dependencies that are available locally on the build-host (usually in `/usr/local/`) will be automatically embedded,
if they are found at the path indicated by the linker.
Dependencies in the OSX-System directories (`/usr/lib`, `/System/`) will be ignored!

This means, that usually you shouldn't need to worry.

### Embedding W32-dependencies
Since W32 does not provide any information inside a binary on where to search for libraries, the build script simply
searches the build-sandbox of your library for missing dependencies.
This means that it is crucial, to have the DLLs of all dependencies available inside your sandbox.
(Files not found are ignored / expected to be available on the deployment machine.)

## W32 specials

Nothing special, but we are cross-compiling the externals on linux uwing MinGW-64.

Also, I would like to use [ravis-ci](https://travis-ci.org/iem-projects/pd-iem/) for automated building,
which currently provides `Ubuntu 12.04 "Precise Penguin"` build machines.
These lack a few features, namely `pthread` support when cross-compiling.
Hopefully they will upgrade their build-machines to something more up-to-date soon.

In the meantime, see `recipes/mrpeach-net.w32` on how to *optionally* build externals requiring pthreads.

## OSX specials

### FAT binaries

You must make sure that your binaries (including all its dependencies) are built as universal ("fat") binaries for (at least)
`i386` and `x86_64` (aka: `amd64`).

In most cases it is sufficient to add `-arch i386 -arch x86_64` to both `CFLAGS` and `LDFLAGS`.

If this is not possible for whatever reasons, you can also build 32bit (`-arch i386`) and 64bit (`-arch x86_64`) binaries separately,
and combine them using `lipo`:

    $ lipo -create i386/foolib.pd_darwin amd64/foolib.pd_darwin -output foolib.d_fat

When installing external dependencies, these need to be universal as well.
E.g. using `brew`, many packages have a `--universal` flag

    $ brew install fftw --universal

### OSX-10.5 compatibility

When building on recent OSX-installations (anything `>10.5`), you need to take care that the binaries are built with a compatibility
layer enabled.
This can be done by setting the environmental variable `MACOSX_DEPLOYMENT_TARGET` to `10.5`.
Luckily, the Pd-iem build system does this automatically for you, so usually you do not need to worry.

However, when using external dependencies, these need to be built for OSX-10.5 as well.

#### brew & OSX-10.5 compat
E.g. packages found in `brew` will never have these compatibility flags enabled.

I have therefore created a separate repository with (a few) brew formulae that build libraries for `10.5` when given the proper `--osxversion` argument.

Example:

    brew install https://raw.githubusercontent.com/iem-projects/homebrew-legacy/master/fftw.rb --universal --osxversion=10.5

Btw, it's better to use the `MACOSX_DEPLOYMENT_TARGET` variable than to hardcode the value of `10.5` in your script.


## Learning by examples

Check out the numerous recipes in the `recipes/` directory on how to solve different problems:

- template-based externals: `bsaylor`, `mrpeach-net`, `mrpeach-osc`, `windowing`

- autotools-based externals: `zexy`, `iemmatrix`

- missing `install`-target: `iem_ambi`, `iem_tab`

- fixing upstream sources: `bsaylor`, `iem_tab`

- external dependencies: `bsaylor`, `iemmatrix` (includes building of dependency on w32)

- pthreads: `mrpeach-net`

