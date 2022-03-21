
.PHONY: start
start:
	@docker-compose up --build -d website postgres

.PHONY: attach
attach:
	@docker-compose stop website
	@docker-compose run --service-ports website

.PHONY: stop
stop:
	@docker-compose stop

.PHONY: init
init:
	@docker-compose build && docker-compose run --rm --name trader-app_init website docker/init

.PHONY: lint
lint:
	@docker-compose run --rm --no-deps --name trader-app_linter website bundle exec rubocop $(filter-out $@,$(MAKECMDGOALS))

.PHONY: lintjs
lintjs:
	@docker-compose run --rm --no-deps --name trader-app_linterjs website ./node_modules/.bin/eslint ./app/assets/javascripts/

.PHONY: bundle-install
bundle-install:
	@docker-compose run --rm --no-deps --name trader-app_install website bundle install --jobs=4

.PHONY: npm-install
npm-install:
	@docker-compose run --rm --no-deps --name trader-app_install website npm install

.PHONY: clean
clean:
	@docker-compose down -v

.PHONY: shell
shell:
	@docker-compose exec website bash

.PHONY: status
status:
	@echo "Running services:"
	@docker ps --filter name=alertbus --format "table {{.Names}}\t{{.RunningFor}}\t{{.Status}}"

.PHONY: logs
logs:
	@docker-compose logs

.PHONY: logstail
logstail:
	@docker-compose logs -f

.PHONY: test
test:
	@docker-compose run --rm --name trader-app_tests website docker/test $(filter-out $@,$(MAKECMDGOALS))

# Catch-all target which does nothing
%:
	@:
