# docker-streamripper

[Streamripper](http://streamripper.sourceforge.net/) is an application that lets you record streaming mp3 to your hard drive.
This is a [docker](https://www.docker.io) image that eases setup.

## About Streamripper

> *From [the official about page](http://streamripper.sourceforge.net/about.php):*

Streamripper started as a way to separate tracks via Shoutcast's title-streaming feature. 
his has now been expanded into a much more generic feature, where part of the program only tries
to "hint" at where one track starts and another ends, thus allowing a mp3 decoding engine to scan for a silent mark,
which is used to find an exact track separation.

Streamripper allows you to download an entire station of music.
Many of these mp3 radio stations only play certain genres, so you can now download an entire collection of goa/trance music,
an entire collection of jazz, punk rock, whatever you want. 

## Usage

This docker image is available as a [trusted build on the docker index](https://index.docker.io/u/clue/streamripper/),
so using it is as simple as running:

```bash
$ docker run clue/streamripper -h
```

Using this image for the first time will start a download automatically.
Further runs will be immediate, as the image will be cached locally.

Docker containers run in an isolated environment, so in order to access your ripped mp3 files
you will have to mount a volume (shared directory) like this:

```bash
$ docker run -v $HOME/MyMusic:/home/streamripper clue/streamripper […]
```

We're almost done. Now you need to get the streaming URL of your favorite online radio station.
The [SHOUTcast](http://www.shoutcast.com/) index is probably a good start if you're unsure.
The streaming URL to your online radio station will need to be passed as an argument to the streamripper container.

You can also supply any number of additional streamripper arguments that will be passed through unmodified.
Describing all of them here is a bit out of scope, so you're recommended to familiarize yourself
with the help (see the above `-h` example).

A common way to put this all together looks like this:

```bash
$ docker run -d -v $HOME/MyMusic:/home/streamripper clue/streamripper http://mystation.local/radio.pls -s -m 30 --xs2 -o never -T
```

This will start the streamripper container in a detached session in the background.
This container is disposable, as it doesn't store any sensitive information at all.
If you don't need it anymore, you can `stop` and `remove` it.
