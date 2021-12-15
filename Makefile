APP_DIRECTORY=src
TEST_DIRECTORY=tests

default: help

# Create the project's virtual environment
create-venv:
	( \
		python3.8 -m venv venv; \
		. ./venv/bin/activate; \
		pip install --upgrade pip; \
	)

# Install all dependencies to local environment
install-dev:
	( \
		. ./venv/bin/activate; \
		pip install -r requirements.txt; \
	)

# Builds the requirements.txt file with current
freeze:
	( \
		. ./venv/bin/activate; \
		pip freeze > requirements.txt; \
	)

# Formats the code through Black
format:
	( \
		. ./venv/bin/activate; \
		isort $(APP_DIRECTORY); \
		black $(APP_DIRECTORY); \
	)

# Runs the code through lint
lint:
	( \
		. ./venv/bin/activate; \
		pylint $(APP_DIRECTORY); \
	)

# Runs the application
run-app:
	( \
		. ./venv/bin/activate; \
		ENV=dev python -m $(APP_DIRECTORY); \
	)

# Runs automatic tests
test:
	( \
		. ./venv/bin/activate; \
		pytest -v -p no:warnings $(TEST_DIRECTORY); \
	)

test-cov:
	( \
		. ./venv/bin/activate; \
		pytest -v -p no:warnings --cov-report term-missing --cov=src $(TEST_DIRECTORY); \
	)

# Display this help
help:
	@printf '  \033[34mUsage: \033[37m  make <target> [flags...]'
	@echo ''
	@printf '\033[34m';
	@echo '  Targets:'
	@awk '/^#/{ comment = substr($$0,3) } comment && /^[a-zA-Z][a-zA-Z0-9_-]+ ?:/{ print "   \033[32m", $$1, "\033[37m", comment }' ./Makefile | column -t -s ':'
	@echo ''
	@printf '\033[34m';
	@echo '  Flags:'
	@awk '/^#/{ comment = substr($$0,3) } comment && /^[a-zA-Z][a-zA-Z0-9_-]+ ?\?=/{ print "   \033[32m", $$1, "\033[33m", $$2, "\033[37m", comment }' ./Makefile | column -t -s '?='
