# docker-frab

This repository contains a Dockerfile complete with dummy configuration for installation of [Frab](https://github.com/frab/frab) (currently using the `master` branch and `mysql` as database).

## Requirements

* [Docker](https://www.docker.com/)
* Running container with MySQL/MariaDB, e.g. [`mariadb`](https://registry.hub.docker.com/_/mariadb/)

## Installation

Download the [automated build](https://registry.hub.docker.com/u/gglnx/frab/) from public [Docker Hub Registry](https://registry.hub.docker.com/):

```bash
docker pull gglnx/frab
```

### Alternative: Building from source

You can create your own build directly from the [repository](https://github.com/gglnx/docker-frab) with `docker build`:

```bash
docker build -t="gglnx/frab" https://github.com/gglnx/docker-frab.git 
```

### Create shared folder

Create on the host machine a folder which will contain shared files like configuration, uploaded and generated files. This folder will be linked with container later.

```bash
mkdir ~/frab/
```

### Add configuration

Add to the shared folder the `.env` configuration file. Use the included `.env.template` as a template and `mysql` as mysql host.

### Run container

After initializing the shared folder and the configuration you can start the container with frab. Startup takes a few minutes to complete installations tasks (create and migrate database, precompile assets).

```bash
docker run -e PASSENGER_APP_ENV=production --name frab --link mariadb:mysql -v ~/frab/:/home/app/shared/ gglnx/frab
``` 
