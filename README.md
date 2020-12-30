# containerized-kiwix-server

## Step 1: Download some ZIM files

[FTP site with ZIM files](https://ftp.fau.de/kiwix/zim/).

Here are some smaller ones for testing:

1. [Assamese Medical Wikipedia (23 MB)](https://ftp.fau.de/kiwix/zim/wikipedia/wikipedia_as_medicine_2017-08.zim)
1. [English Wikipedia Bollywood Articles (265 MB)](https://ftp.fau.de/kiwix/zim/wikipedia/wikipedia_en_bollywood_2017-01.zim)
1. [Simple English Wikipedia w/ No Pictures (159 MB)](https://ftp.fau.de/kiwix/zim/wikipedia/wikipedia_en_simple_all_nopic_2016-08.zim)

## Step 2: Move the ZIM files to the 'zim' directory

```shell
# inside the folder where you downloaded the ZIMs (e.g. ~/Downloads)
$ mkdir -p ./dockerized-kiwix-server/zims
$ cp *.zim ./dockerized-kiwix-server/zims
```

## Step 3: Build the container

This will create the Linux machine, download the Kiwix tools (including `kiwix-serve`), copy the ZIM files over, then create the Kiwix library XML file.

```shell
$ pwd # -> ./dockerized-kiwix-server
$ docker build -t kiwix-serve .
# ... or with Buildah (Podman):
$ buildah bud -t kiwix-serve .
```

## Step 4: Run the container

This starts the container and the Kiwix server, and makes it available on your machine at `http://localhost:8080`.

```shell
$ docker run -d --name kiwix-serve -v $HOST_ZIM_DIR:/zims:ro -p 8080:8080 kiwix-serve
# ... or with Podman:
$ podman run -d --name kiwix-serve -v $HOST_ZIM_DIR:/zims:ro -p 8080:8080 kiwix-serve
```

To turn it off:

```shell
$ docker stop $(docker ps -qf "name=kiwix-serve")
# ... or with Podman:
$ podman stop $(podman ps -qf name=kiwix-serve)
```

## Step 5: Try it out in the browser

Go to http://localhost:8080.

# Differences to upstream version

> NB: In this context [jonboiser/dockerized-kiwix-server](https://github.com/jonboiser/dockerized-kiwix-server) is deemed the upstream version.

* Basing this on `ubuntu:focal` instead of `ubuntu:xenial`, which is a bit dated by now.
* Added an `apt-get full-upgrade`.
* Fixed up the way `wget` gets installed.
* Changed a little how the provisioning script works. Future version changes should be minimally invasive this way. Also, the downloaded tarball gets removed at the end.
* Just like the upstream of my upstream I am using a data volume.
* The job of creating the `library.xml` file is now delegated to the same script which acts as the entry point to the container.
* Prepared for running with Podman (this documentation was adjusted accordingly).
* Added `GNUmakefile` so that container creation is trivial now.

## Using GNU make with all this

> NB: we assume that GNU make will be invoked by `make` in the following sample section.

* Create image (unless it exists) and container (unless it exists):
  * Docker:  
    ```
    make
    ```
  * Podman:  
    ```
    make DEFAULT=podman
    ```
  * Podman, but giving an alternative location for the ZIM files:  
    ```
    make DEFAULT=podman ZIMDIR=$(pwd)/..
    ```
* Stop and remove container (if it exists) and image (if it exists):

  * Docker:  
    ```
    make clean
    ```
  * Podman:  
    ```
    make DEFAULT=podman clean
    ```
* Rebuild container and image, this combines the two actions above by first stopping and removing container and then image, followed by creating both of those from scratch.

The makefile will start the container with a read-only data volume for the ZIM files. No need that the container has any write access to those.

### Variables

Just like you can set `DEFAULT` to override the built-in default `docker` with `podman`, there are a few more items which influence the behavior of the `GNUmakefile`.

* `CONTNAME` (default: `kiwix-serve`) is the name given to the created container and the tag of the image created.  
  **NB:** Checks for the existence of the container and image rely on this value!
* `DEFAULT` (default: `docker`) is the way to influence which default target gets picked. This also influences whether `docker` or `podman` gets to run when removing the container and image.
* `ZIMDIR` (default: `/srv/zims`) is how you override the host-side path to the volume which which ought to contain the ZIM files.
