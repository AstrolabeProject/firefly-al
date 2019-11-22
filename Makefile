ENVLOC=/etc/trhenv
FFWWW=${PWD}/www
FFIMG=ipac/firefly:rc-2019.3
JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx8192m'
NAME=ff
PORT=8888
STACK=ff

.PHONY: help down exec gen up update

help:
	@echo 'Make what? help, exec, down, gen, up'
	@echo '    where: help - show this help message'
	@echo '           down - stop the Firefly server on the VOS network'
	@echo '           exec - exec into the running Firefly server (CLI arg: NAME=containerID)'
	@echo '           gen  - generate initial UI file stubs into a subdirectory'
	@echo '           up   - start a Firefly server on the VOS network'
	@echo '           update - copy index.html into running Firefly server (for development)'

down:
	docker stack rm ${STACK}

exec:
	docker cp .bash_env ${NAME}:${ENVLOC}
	docker exec -it ${NAME} bash

gen:
	docker run -d --rm --name ${NAME} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www ${FFIMG} --help

up:
	docker stack deploy -c docker-compose.yml ${STACK}

update:
	docker cp ${PWD}/www/index.html ${NAME}:/local/www
