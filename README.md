# FRR build Docker images

## How it's used

First, create some/all images with `mkimages.sh`.  This creates a bunch of
docker images normally named `frr-build/debian/buster` and co.  For all images
this can take an hour or two depending on how fast your system and internet
connection is.

After these images are available, you can run `./build.sh`, e.g.:

```
$ ./build.sh -s ~/src/frr -i frr-build/debian/buster package
```

Which after a successful run will leave a bunch of .deb files in a directory
in /tmp.  (To pre-set a directory, use the `-d` option.)


## Known issues

* Debian
  * the .deb versioning needs fixing/polishing (can't have the same package
    version but different contents)
  * need to figure out how to build a proper source deb
* Ubuntu
  * while release names are used for debian, ubuntu uses numbers.  This is
    because few people know what "Ubuntu bionic" is, while for Debian equally
    few people know what "Debian 10" is.  (It's 18.04 and buster btw.)
* OpenWRT
  * the OpenWRT target is currently hardcoded to ar71xx / mips\_24kc
  * building the tarball doesn't work because the host environment is missing
    some packages
* Fedora, OpenSuse, CentOS
  * need a cleanup
* tsrun needs to be added to this git
  * it's a simple tool to run some command while capturing its output to a
    log file with timestamps
