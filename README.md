
## Astrolabe customized version of the Firefly server.

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

**Author**: [Tom Hicks](https://github.com/hickst)

**Purpose**: This project creates a Docker image of the IPAC Firefly astronomical server and visualizer [IPAC/Firefly](https://github.com/Caltech-IPAC/firefly). This version of Firefly has been customized for the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

## Installation

***Note**: This is a special, customized version of Firefly. Installation of this version requires a working Docker installation, version 19.03 or greater, and **Docker must be running in swarm mode**. You must also successfully start the [Astrolabe VOS Server](https://github.com/AstrolabeProject/vos.git) **before** starting this Firefly.*

### 1. Checkout this project

Git `clone` this project to your local disk and enter the project directory:
```
  > git clone https://github.com/AstrolabeProject/firefly-al.git
  > cd firefly-al
```

### 2. Enable Docker swarm mode

Since you cannot run this version of Firefly without first having started the [Astrolabe VOS Server](https://github.com/AstrolabeProject/vos.git), you must have already enabled Swarm mode.


### 3. Prepare the deployment

Before starting Firefly, you must create a directory containing your images, or link to an existing one. **The image directory (or link) must be created in the working directory for this project** (i.e. the directory into which you checked out this project).

To create a link (which must be named "*images*") to an existing directory of JWST images and catalogs on your local disk:
```
  > ln -s path/to/directory/of/your/JWST/fits/files images
```

### 4. Start Firefly

To start Firefly, and connect it to the running VO Server, use the `docker stack deploy` command:
```
  > docker stack deploy -c docker-compose.yml ff
```
OR, if you are familiar with `Make`, use the convenient Makefile:
```
  > make up
```
and then wait for the Firefly container to initialize, which **may take a minute or so** as the container must be downloaded (the first time only) and started.

You can use common Docker commands to monitor the status of the Firefly container. The `docker service` command shows the newly started Firefly container and the running VO Server containers:
```
  > docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                           PORTS
czxb57t3lg2w        ff_firefly          replicated          1/1                 ipac/firefly:rc-2019.3   *:8888->8080/tcp
1m841e7liokk        vos_celery          replicated          1/1                 astrolabe/cuts:latest
v59tayb4v5n0        vos_cuts            replicated          1/1                 astrolabe/cuts:latest    *:8000->8000/tcp
7lxjg8h50l0c        vos_pgdb            replicated          1/1                 astrolabe/vosdb:latest   *:5432->5432/tcp
dab3jzqf032d        vos_redis           replicated          1/1                 redis:5.0-alpine         *:6379->6379/tcp
zbynaauuna18        vos_vos             replicated          1/1                 astrolabe/dals:latest    *:8080->8080/tcp
```
Firefly will be ready when the `REPLICAS` column shows 1/1 for it.

The `docker container` command is also useful to view the status of the Firefly and VO Server containers:
```
  > docker container ls -a
    CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                NAMES
34db47ff0c69        ipac/firefly:rc-2019.3   "/bin/bash -c './lau…"   1 minute ago        Up 1 minute         5050/tcp, 8080/tcp   ff_firefly.1.i1fpsy7n78alh183f1jcyn7iw
7138a0f4ab88        astrolabe/dals:latest    "catalina.sh run"        2 hours ago         Up 2 hours          8080/tcp             vos_vos.1.qiwaa1vf8uoj4dpab5hovakxp
4c63d1668481        astrolabe/cuts:latest    "gunicorn -c /cuts/c…"   2 hours ago         Up 2 hours                               vos_cuts.1.v8w6gs1rjo1jecu64xbov41qs
e2a970bfa0b4        astrolabe/cuts:latest    "celery worker -l de…"   2 hours ago         Up 2 hours                               vos_celery.1.sdiia00iapiwyxdu6cvlubsar
59008932fd1f        astrolabe/vosdb:latest   "docker-entrypoint.s…"   2 hours ago         Up 2 hours          5432/tcp             vos_pgdb.1.h7petbeck29mf39stnoye8cip
6b970370405f        redis:5.0-alpine         "docker-entrypoint.s…"   2 hours ago         Up 2 hours          6379/tcp             vos_redis.1.x5n2ngphgyzxs87etrideb5sl
```
The `STATUS` column (to the right) should eventually show "Up" for the Firefly container.


## Accessing Firefly

If deployment was successful, you will be able to access the customized version of Firefly from within a browser on your local machine:

  - Access the Firefly server at [http://localhost:8888/local](http://localhost:8888/local)

***Note**: The customizations in this version of Firefly are **only** available at the specificed **local** URL above (note it ends with `local`). They will not appear if you use the standard Firefly server URL (which ends with `firefly`).*


## Stopping Firefly

To stop Firefly use the `docker stack rm` command:
```
  > docker stack rm ff
```
OR, if you are familiar with `Make`, use the convenient Makefile:
```
  > make down
```
The Firefly container should stop within a minute or so. This can be monitored with the Docker commands given (above) in the Startup section.


## Using Firefly

### Loading cutouts into Firefly from the images server

After opening the Firefly viewer in a browser, select the `Images` button and you should see the
custom `JWST Images` entry at the top of the `Select Data Set` frame. JWST cutouts requested
here will be generated by the running VO Server and returned to Firefly just like any other
remote image data source.

### Loading images into Firefly from your local disk

You can load one or more images directly from your local image directory as follows:

 1. Click the `Images` button on the top button bar to bring up the `Images Search` window.
 2. Select `URL` in the `Select Image Source` box.
 3. Enter the *file URL* for one of the images in your local image directory. Precede the actual filename with `file:///external/`. For example: `file:///external/goods_s_F356W_2018_08_30.fits`
 4. Click the `Search` button at the bottom of the `Images Search` window.
 5. Depending on size, the image should load in about 2-15 seconds.

### Loading the JWST catalog into Firefly from the VO Server

To search the JWST catalog in the local VO Server:

 1. Click the Catalogs button on the top button bar to bring up the catalogs window.
 2. Select the `VO Catalog` tab at the top of the catalogs window.
 3. Enter coordinates (no names) for the search, such as `53.16 -27.78`
 4. Select a search radius and units, such as `4 arcseconds`
 5. Enter the `Cone Search URL` for the local VO Server, which is `http://dals:8080/dals/scs-jaguar`
 6. Click the `Search` button at the bottom of the catalogs window.
 7. The results from the catalog search should open and display next to the previously loaded image.

## License

Software licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).
