FF=ff
FFWWW=${PWD}/www
FFIMG=ipac/firefly:nightly
JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx8192m'
NET=vos_net
PORT=8888

.PHONY: help gen exec run runD stop

help:
	@echo 'Make what? help, up, down, exec, run, runD'
	@echo '    where: help   - show this help message'
	@echo '           exec - exec into running Firefly container'
	@echo '           gen  - generate example UI files into subdirectory'
	@echo '           run  - start a standalone Firefly container'
	@echo '           runD - start a standalone Firefly container in DEBUG mode'
	@echo '           stop - stop a running standalone Firefly container'

exec:
	docker exec -it ${FF} bash

gen:
	docker run -d --rm --name ${FF} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www ${FFIMG} --help

run:
	docker run -d --rm --name ${FF} --network ${NET} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www -v ${PWD}/images:/external ${FFIMG}

runD:
	docker run -d --rm --name ${FF} --network ${NET} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www -v ${PWD}/images:/external -e 'DEBUG=TRUE' ${FFIMG}

stop:
	docker stop ${FF}
