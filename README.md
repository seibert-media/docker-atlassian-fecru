# docker-atlassian-fecru

This is a Docker-Image for Atlassian Fisheye/Crucible based on [Alpine Linux](http://alpinelinux.org/), which is kept as small as possible.

## Features

* Small image size
* Setting application context path

## Variables

* TOMCAT_CONTEXT_PATH

## Ports
* 8060

## Getting started

Run Fisheye/Crucible standalone and navigate to `http://[dockerhost]:8060` to finish configuration:

```bash
docker run -tid -p 8060:8060 seibertmedia/atlassian-fecru:latest
```

Run Fisheye/Crucible standalone with custom application context and navigate to `http://[dockerhost]:8060/fecru` to finish configuration:

```bash
docker run -tid -p 8060:8060 -e TOMCAT_CONTEXT_PATH="fecru" seibertmedia/atlassian-fecru:latest
```

Specify persistent volume for Fisheye/Crucible data directory and redirect application logs to stdout:

```bash
docker run -tid -p 8060:8060 -p 7999:7999 -v fecru_data:/var/opt/atlassian/application-data/fecru seibertmedia/atlassian-fecru:latest
```
