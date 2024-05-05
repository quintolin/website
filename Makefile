SHELL := /bin/sh
.POSIX: # enable POSIX compatibility
.SUFFIXES: # no special suffixes
.DEFAULT_GOAL := default

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
