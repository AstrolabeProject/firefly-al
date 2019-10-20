FF=ff
FFWWW=${PWD}/www
FFIMG=ipac/firefly:withmenu
JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx8192m'
CNET=cuts_net
VNET=vos_net
PORT=8888

.PHONY: help gen exec run runD stop

help:
	@echo 'Make what? help, up, down, exec, run, runD'
	@echo '    where: help   - show this help message'
	@echo '           exec - exec into running Firefly container'
	@echo '           gen  - generate example UI files into subdirectory'
	@echo '           run  - start a standalone Firefly container on the VOS network'
	@echo '           runC  - start a standalone Firefly container on the CUTS network'
	@echo '           runD - start a standalone Firefly container on the VOS network in DEBUG mode'
	@echo '           stop - stop a running standalone Firefly container'

exec:
	docker cp .bash_env ${FF}:/etc/bash_env.trh
	docker exec -it ${FF} bash

gen:
	docker run -d --rm --name ${FF} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www ${FFIMG} --help

run:
	docker run -d --rm --name ${FF} --network ${VNET} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www -v ${PWD}/images:/external:ro ${FFIMG}

runC:
	docker run -d --rm --name ${FF} --network ${CNET} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www -v ${PWD}/images:/external:ro ${FFIMG}

runD:
	docker run -d --rm --name ${FF} --network ${VNET} -p${PORT}:8080 -e ${JOPTS} -v ${FFWWW}:/local/www -v ${PWD}/images:/external:ro -e 'DEBUG=TRUE' ${FFIMG}

stop:
	docker stop ${FF}
