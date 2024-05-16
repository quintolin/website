SHELL := /bin/sh
.POSIX: # enable POSIX compatibility
.SUFFIXES: # no special suffixes
.DEFAULT_GOAL := default

DOCKER_USER_ARGS = --user=$$(id --user):$$(id --group)
DOCKER_IMAGE_EDITORCONFIG_CHECKER = mstruebing/editorconfig-checker:v3.0.1
DOCKER_IMAGE_PHP_CS_FIXER = ghcr.io/php-cs-fixer/php-cs-fixer:3.54-php8.3
PHP_CS_FIXER_DOCKER_RUN_ARGS = ${DOCKER_USER_ARGS} --volume=$$PWD:/code ${DOCKER_IMAGE_PHP_CS_FIXER}
PHP_CS_FIXER_COMMON_ARGS = --verbose --show-progress=dots

# dummy entry to force make to do nothing by default
.PHONY: default
default:
	@echo "Please choose target explicitly."

# git helper: push current branch to configured remotes
.PHONY: git_push_current_branch
git_push_current_branch:
	git remote | xargs -L1 git push --verbose

# git helper: push all tags to all configured remotes
.PHONY: git_push_tags
git_push_tags:
	git remote | xargs -L1 git push --verbose --tags

# remove temporary files
.PHONY: clean_cache
clean_cache:
	if test -e .php-cs-fixer.cache; then rm --verbose .php-cs-fixer.cache; fi

# uninstall dependencies
.PHONY: composer_uninstall
composer_uninstall:
	if test -e composer.lock; then rm --verbose composer.lock; fi
	if test -e vendor; then rm --verbose --recursive vendor; fi

# install dependencies
.PHONY: composer_install
composer_install:
	composer install --verbose --optimize-autoloader

# lint all files against EditorConfig settings
.PHONY: lint_editorconfig
lint_editorconfig:
	docker container run --rm ${DOCKER_USER_ARGS} --volume=$$PWD:/check ${DOCKER_IMAGE_EDITORCONFIG_CHECKER}

# lint PHP coding style
.PHONY: lint_coding_style
lint_coding_style: composer_install
	docker container run --rm ${DOCKER_USER_ARGS} ${PHP_CS_FIXER_DOCKER_RUN_ARGS} check ${PHP_CS_FIXER_COMMON_ARGS}

# fix PHP coding style
.PHONY: fix_coding_style
fix_coding_style: composer_install
	docker container run --rm ${DOCKER_USER_ARGS} ${PHP_CS_FIXER_DOCKER_RUN_ARGS} fix ${PHP_CS_FIXER_COMMON_ARGS}
