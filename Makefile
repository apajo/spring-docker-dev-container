.PHONY: install dev build all
SHELL:= /bin/bash
.SILENT: quiet

name="spring-starter"

arg = "$(filter-out $@,$(MAKECMDGOALS))"
pwd = $(shell pwd)
buildTime = $(shell date)

help:		## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

all:		## Initial setup for the container
	make build
	make run
#	make shell

build:		## Build the image
	docker build -t $(name) .

build-force:	## Force rebuild (no cache)
	-make kill
	docker build --no-cache -t $(name) .

run:		## Run the container
	docker run -it --rm -p 8080:8080 --mount type=bind,source="$(pwd)"/src,target=/app/src --name $(name) $(name)
	docker ps -a

kill:		## Kill the container
	-docker kill $(name)
	-docker rm $(name)

test:		## Test the connection to container
	wget -O - http://localhost:8080/

# https://www.alibabacloud.com/blog/how-to-use-nginx-as-an-https-forward-proxy-server_595799
cert:		## Create certificate
	openssl s_client -connect www.baidu.com:443 -servername www.baidu.com