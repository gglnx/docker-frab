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

Add to the shared folder the configuration files and adjust them. Use `mysql` as mysql host.

#### [`database.yml`](database.yml.template)

```yaml
production:
  adapter: mysql2
  encoding: utf8
  database: frab
  username: frab
  password: my_password
  host: mysql
  port: 3306
```

#### [`settings.yml`](settings.yml.template)

```yaml
production:
  host: frab.example.com
  protocol: https
  from_email: noreply@frab.example.com
  # smtp server settings. see
  # http://api.rubyonrails.org/classes/ActionMailer/Base.html
  # for all available options
  smtp_settings:
    address: localhost
```

### Run container

After initializing the shared folder and the configuration you can start the container with frab. Startup takes a few minutes to complete installations tasks (create and migrate database, precompile assets).

```bash
docker run -e PASSENGER_APP_ENV=production --name frab --link mariadb:mysql -p 8999:80 -v ~/frab/:/home/app/shared/ gglnx/frab
``` 
