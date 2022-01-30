ARGS=
ENVLOC=/etc/trhenv
FFWWW=${PWD}/www
FFIMG=ipac/firefly:release-2021.4.0
IMG=astrolabe/ffal:local
IMGS=${PWD}/images
JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx10240m -Djava.security.egd=file:/dev/./urandom'
NAME=fflocal
PORT=8888
SHELL=/bin/bash
GROUP=local

.PHONY: help docker down exec gen run stop up update

help:
	@echo 'Make what? help, docker, down, exec, gen, run, stop, up-dev, up, update'
	@echo '  where: help - show this help message'
	@echo '         docker - build the custom Firefly container image'
	@echo '         down   - compose stop the Firefly server'
	@echo '         exec   - exec into the running Firefly server (CLI arg: NAME=containerID)'
	@echo '         gen    - generate initial UI file stubs into a subdirectory'
	@echo '         run    - start a standalone Firefly server on this host'
	@echo '         stop   - stop the standalone Firefly server on this host'
	@echo '         up-dev - compose start a Firefly server (console logging)'
	@echo '         up     - compose start a Firefly server (background logging)'
	@echo '         update - copy index.html into running Firefly server (for development)'

bash:
	docker run -it --rm --name ${NAME} -p${PORT}:8080 -e ${JOPTS} -v ${IMGS}:/external:ro --entrypoint ${SHELL} ${IMG} ${ARGS}


docker:
	docker build -t ${IMG} .

down:
	docker compose -p ${GROUP} down

exec:
	docker cp .bash_env ${NAME}:${ENVLOC}
	docker exec -it ${NAME} bash

gen:
	docker run -d --rm --name ${NAME} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www ${FFIMG} --help

run:
	docker run -d --rm --name ${NAME} -p${PORT}:8080 -e ${JOPTS} -v ${IMGS}:/external:ro ${IMG}

stop:
	docker stop ${NAME}

up-dev:
	docker compose -p ${GROUP} up

up:
	docker compose -p ${GROUP} up --detach

update:
	docker cp ${PWD}/www/index.html ${NAME}:/local/www
