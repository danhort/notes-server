# Path to composer file
COMPOSE_PATH := ops/docker-compose.yml
# Project name
PROJECT_NAME := notes-server
# Shortcut for docker-compose
DC := docker-compose -p ${PROJECT_NAME} -f ${COMPOSE_PATH}

##
## --------------
## Docker Comands
## --------------
##

build: ## Build docker containers
	${DC} build 

start: ## Start docker containers
	@ ${DC} up -d

stop: ## Stop docker containers
	@ ${DC} down

kill: ## Kill docker containers
	@ ${DC} kill

cache: ## Flush cache stored in Redis
	@ ${DC} exec redis sh -c "redis-cli flushall"

user := www-data
php: ## ssh into php container [user=<user name>]
	@ ${DC} exec --user $(user) php sh

user := root
mysql: ## ssh into mysql container [user=<user name>]
	@ ${DC} exec --user $(user) mysql sh

db-import: ## import database file from mysqldump dir [file=<file name>]
	@ ${DC} exec --user root mysql sh -c "zcat /mysqldump/$(file) | mysql -uroot -plaravel laravel"

name := backup
db-dump: ## create a database dump to mysqldump dir [name=<file name>]
	@ ${DC} exec --user root mysql sh -c "mysqldump -uroot -plaravel laravel | gzip > mysqldump/$(name).sql.gz"

##
## --------------------
## Application Commands
## --------------------
##

composer: ## Composer commands [c="<command>"]
	@ ${DC} exec --user www-data php composer $(c)

npm: ## npm commands [c="<command>"]
	@ ${DC} exec --user www-data php npm $(c)

artisan: ## artisan commands [c="<command>"]
	@ ${DC} exec --user www-data php php artisan $(c)

##
##
.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
		| sed -e 's/^.*Makefile://g' \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' \
		| sed -e 's/\[32m##/[33m/'
.PHONY: help