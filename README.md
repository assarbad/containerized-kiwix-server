dockerized-kiwix-server
=================

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
$ docker run -d --name kiwix-serve -p 8080:8080 kiwix-serve
# ... or with Podman:
$ podman run -d --name kiwix-serve -p 8080:8080 kiwix-serve
```

To turn it off:

```shell
$ docker stop $(docker ps -qf "name=kiwix-serve")
# ... or with Podman:
$ podman stop $(podman ps -qf name=kiwix-serve)
```

## Step 5: Try it out in the browser

Go to http://localhost:8080.

