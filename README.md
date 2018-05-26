My Packer templates and build script
======================================================================

  * Copyright (c) 2015-2018 SATOH Fumiyasu @ OSS Technology Corp., Japan
  * License: GNU General Public License version 3
  * URL: <https://github.com/fumiyas/packer-template>
  * Blog: <https://fumiyas.github.io/>
  * Twitter: <https://twitter.com/satoh_fumiyasu>

What's this?
---------------------------------------------------------------------

My Packer templates and build script

Requirements
---------------------------------------------------------------------

* Packer 0.11+
* Vagrant 1.9+
* VM Manager:
  * VirtualBox 5.1+
  * QEMU
  * VMware

Preparation
---------------------------------------------------------------------

### Install softwares from standard package repository

```console
$ apt install packer vagrant virtualbox qemu-kvm
...
$ go get github.com/mitchellh/packer
...
```

### Install softwares from package released on each developer site

* Packer Releases
  * https://github.com/mitchellh/packer/releases
* Vagrant by HashiCorp
  * https://www.vagrantup.com/downloads.html
* Oracle VM VirtualBox
  * https://www.virtualbox.org/wiki/Downloads

### Build and install Packer from source

Initial build and install:

```console
$ apt install golang
...
$ go get github.com/mitchellh/packer
...
$ ls ${GOPATH-$HOME/go}/bin/packer
...
```

Update to the latest development version:

```console
$ cd ${GOPATH-$HOME/go}/src/github.com/mitchellh/packer
$ git checkout master
$ git pull
$ make deps
$ make dev
...
```

Build the specific version:

```console
$ cd ${GOPATH-$HOME/go}/src/github.com/mitchellh/packer
$ git tag
...
$ git checkout -b v1.1.2 v1.1.2
Switched to a new branch 'v1.1.2'
$ make deps
$ make dev
...
```

Usage
----------------------------------------------------------------------

Create a configuration file for packer-build script:

```console
$ vi etc/CentOS-7.3.conf
...
```

Build boxes:

```console
$ bin/packer-build etc/CentOS-7.3.conf
...
$ ls -1 dist/CentOS-7.3-x86_64/1.0.0
CentOS-7.3-x86_64.libvirt.box
CentOS-7.3-x86_64.virtualbox.box
libvirt.json
packer-build.CentOS-7.3-x86_64.tar
virtualbox.json
```

Create (or update) index.json for providers:

```console
$ bin/box-index-providers dist/CentOS-7.3-x86_64/1.0.0
$ cat dist/CentOS-7.3-x86_64/1.0.0/index.json
...
```

Create (or update) index.json for versions:

```console
$ bin/box-index-versions dist/CentOS-7.3-x86_64
$ cat dist/CentOS-7.3-x86_64/index.json
...
```
