# clue/streamripper

[Streamripper](http://streamripper.sourceforge.net/) is an application that lets you record streaming mp3 to your hard drive. This is a [Docker](https://www.docker.com) image that eases setup.

## About Streamripper

> *From [the official about page](http://streamripper.sourceforge.net/about.php):*

Streamripper started as a way to separate tracks via Shoutcast's title-streaming feature. This has now been expanded into a much more generic feature, where part of the program only tries to "hint" at where one track starts and another ends, thus allowing a mp3 decoding engine to scan for a silent mark, which is used to find an exact track separation.

Streamripper allows you to download an entire station of music. Many of these mp3 radio stations only play certain genres, so you can now download an entire collection of goa/trance music, an entire collection of jazz, punk rock, whatever you want. 

## Usage

This docker image is available as an [automated build on Docker Hub](https://hub.docker.com/r/clue/streamripper/), so using it is as simple as running:

```bash
$ docker run clue/streamripper -h
```

Using this image for the first time will start a download automatically. Further runs will be immediate, as the image will be cached locally.

Docker containers run in an isolated environment, so in order to access your ripped mp3 files you will have to mount a volume (shared directory) like this:

```bash
-v $HOME/MyMusic:/home/streamripper
```

We're almost done. Now you need to get the streaming URL of your favorite online radio station. The [SHOUTcast](http://www.shoutcast.com/) index is probably a good start if you're unsure. The streaming URL to your online radio station will need to be passed as an argument to the streamripper container.

You can also supply any number of additional streamripper arguments that will be passed through unmodified. Describing all of them here is a bit out of scope, so you're recommended to familiarize yourself with the help (see the above `-h` example).

A common way to put this all together looks like this:

```bash
$ docker run -d -v $HOME/MyMusic:/home/streamripper clue/streamripper http://mystation.local/radio.pls -s -m 30 --xs2 -o never -T
```

This will start the streamripper container in a detached session in the background.

## Relay stream

Streamripper supports creating a "relay stream" that allows clients to connect to the stream that is currently being ripped. This means that you can share the same stream without causing another connection to the remote radio station.

This image is configured to automatically pass the required streamripper options and to automatically expose the streamripper stream relay on port `8000`. If you want to publish this port for outside access, you can simply pass a binding like this:

```
-p 8000:8000
```

## Cleanup

This container is disposable, as it doesn't store any sensitive information at all. If you don't need it anymore, you can `stop` and `remove` it.

## Docker Compose

Similarly, you can also use [Docker Compose](https://docs.docker.com/compose/) to configure and run this image. Simply create a `docker-compose.yml` file like this:

```yml
version: '3'
services:
  streamripper:
    image: clue/streamripper
    restart: always
    ports:
#     - 8000:8000 # optionally publish relay stream
    volumes:
      - $HOME/MyMusic:/home/streamripper
    command: http://mystation.local/radio.pls -s -m 30 --xs2 -o never -T
```

You can then run this as a background service like this:

```bash
$ docker-compose up -d
```

If you want to access (share) the ripped MP3 files through a webbrowser, you may simply use the [clue/h5ai](https://github.com/clue/docker-h5ai) Docker image:

```yml
version: '3'
services:
  streamripper:
    image: clue/streamripper
    restart: always
    volumes:
      - $HOME/MyMusic:/home/streamripper
    command: http://mystation.local/radio.pls -s -m 30 --xs2 -o never -T
  web:
    image: clue/h5ai
    ports:
      - 80:80
    volumes:
      - $HOME/MyMusic:/var/www
```

When running this you will now be presented with a beautiful listing of all new songs:

![](https://cloud.githubusercontent.com/assets/776829/3098666/440f3ca6-e5ef-11e3-8979-36d2ac1a36a0.png)

> Disclaimer: It goes without saying that it should be in your best interest to support the artists and stations. Sharing copyrighted files with the public is not a good idea unless you have permission to do so. Running this in your local network to discover new music may or may not be legal in your jurisdiction, sharing this with the public probably is not (IANAL).
