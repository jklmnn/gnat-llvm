GNAT LLVM
=========

This is an experimental Ada compiler based on LLVM, connecting the GNAT
front-end to the LLVM code generator.

This is a work-in-progress research project that's not meant for and
shouldn't be used for industrial purposes. It's meant to show the
feasibility of generating LLVM bitcode for Ada and to open the LLVM
ecosystem to Ada, including tools such as [KLEE](https://klee.github.io).

Note that we are not planning on replacing any existing GNAT port that's
based on GCC: this project is meant to provide additional, not replacement,
GNAT ports.

There are known bugs and limitations in this version.

Early users are welcome to experiment with this technology and provide
feedback on successes, usages, limitations, pull requests, etc.

- For more information on LLVM, see [llvm.org](https://llvm.org).
- For more information on GNAT, see [adacore.com](https://www.adacore.com).

GNAT LLVM has been built successfully on GNU/Linux and Mac OS Mojave x86_64
native targets, using LLVM 9.0.1. Do not hesitate to report success
on other configurations.

Tensilica Xtensa support
========================

This fork aims to provide Ada support for the ESP8266 and ESP32 chips by
using the [LLVM Xtensa backend](https://github.com/espressif/llvm-project).

Building
--------

To build GNAT LLVM from sources, follow these steps:

- Obtain a check out of the GNAT sources from gcc.gnu.org and the
  Xtensa LLVM backend

      $ git submodule update --init --recursive

- Then obtain a check out of the latest GNAT sources from gcc.gnu.org under
  the llvm-interface directory:

      $ git clone git://gcc.gnu.org/git/gcc.git llvm-interface/gcc

  then under non Windows systems:

      $ ln -s gcc/gcc/ada llvm-interface/gnat_src

  under Windows systems:

      $ mv llvm-interface/gcc/gcc/ada llvm-interface/gnat_src

- Install (and put in your PATH) a recent GNAT, e.g GNAT Community 2019,
  GCC 8 or GCC 9.

- Install LLVM and Clang 9.0.1

  The recommended way to build GNAT LLVM is to use an existing LLVM and clang
  9.0.1 package install via e.g.  "brew install llvm" on Mac OS or
  "sudo apt-get install llvm-dev" on Ubuntu. You can also build llvm yourself
  with the options that suit your needs. After installing/building, make sure
  the llvm bin directory containing llvm-config and clang is in your PATH.

  As alternative only suitable for core GNAT LLVM development on x86 native
  configurations only is to use the following command, assuming you have cmake
  version >= 3.7.2 in your path:

      $ make llvm

  Note that there's currently a bug in LLVM's aliasing handling.  We check
  for it and generate slightly pessimized code in that case, but a patch
  to be applied to LLVM's lib/Analyze directory is in the file
  llvm/patches/LLVMStructTBAAPatch.diff.

- Finally build GNAT LLVM:

      $ make

This creates a "ready to use" set of directories "bin" and "lib" under
llvm-interface which you can put in your PATH:

    PATH=$PWD/llvm-interface/bin:$PATH

- If you want in addition to generate bitcode for the GNAT runtime, you can do:

      $ make gnatlib-bc

  This will generate libgnat.bc and libgnarl.bc in the adalib directory, along
  with libgnat.a and libgnarl.a.

Usage
-----

- To run the compiler and produce a native object file:

      $ llvm-gcc -c file.adb

- To debug the compiler:

      $ gdb -args llvm-gnat1 -c file.adb

- To build a complete native executable:

      $ llvm-gnatmake main.adb

- To build a whole project:

      $ gprbuild --target=llvm -Pprj ...

- To generate LLVM bitcode (will generate a .bc file):

      $ llvm-gcc -c -emit-llvm file.adb

- To generate LLVM assembly (will generate a .ll file):

      $ llvm-gcc -c -S -emit-llvm file.adb

- To generate native assembly file (will generate a .s file):

      $ llvm-gcc -S file.adb

- To build for Xtensa:

      $ llvm-gnatmake -c unit.adb -cargs --target=xtensa -mcpu=esp8266

License
-------

The GNAT LLVM tool is licensed under the GNU General Public License version 3
or later; see file `COPYING3` for details.
