# Debian Backports builder

## Intro

This helper is used to build Debian backports.

It basically follows this [doc](https://wiki.debian.org/SimpleBackportCreation#Go_further), but in a container.

## Usage

Simply run one of the scripts in the root directory.

Built `deb` files will be generated in an `out` directory.

## New backport

To build a new backport :

* create a new folder
* create one or multiple script(s) (see `ser2net/2-ser2net.sh` for example)
* create a Dockerfile
  * install the dependencies
  * adds the script(s)
* create a shell script at the root
