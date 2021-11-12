ENVLOC=/etc/trhenv
FFWWW=${PWD}/www
FFIMG=ipac/firefly:release-2021.3.3
IMG=ffal:devel
IMGS=${PWD}/images
JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx10240m -Djava.security.egd=file:/dev/./urandom'
NAME=ffal
PORT=8888
STACK=loc

.PHONY: help docker down exec gen run stop up update

help:
#	@echo 'Make what? help, docker, down, exec, gen, run, stop, up, update'
	@echo 'Make what? help, docker, exec, gen, run, stop, update'
	@echo '  where: help - show this help message'
	@echo '         docker - build the custom Firefly container image'
#	@echo '         down - stop the Firefly server on the private network'
	@echo '         exec - exec into the running Firefly server (CLI arg: NAME=containerID)'
	@echo '         gen  - generate initial UI file stubs into a subdirectory'
	@echo '         run  - start a standalone Firefly server on this host'
	@echo '         stop - stop the standalone Firefly server on this host'
#	@echo '         up   - start a Firefly server on a private network'
	@echo '         update - copy index.html into running Firefly server (for development)'

docker:
	docker build -t ${IMG} .

down:
	docker stack rm ${STACK}

exec:
	docker cp .bash_env ${NAME}:${ENVLOC}
	docker exec -it ${NAME} bash

gen:
	docker run -d --rm --name ${NAME} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www ${FFIMG} --help

run:
	docker run -d --rm --name ${NAME} -p${PORT}:8080 -e ${JOPTS} -v ${IMGS}:/external:ro ${IMG}

stop:
	docker stop ${NAME}

up:
	docker stack deploy -c docker-compose.yml ${STACK}

update:
	docker cp ${PWD}/www/index.html ${NAME}:/local/www
