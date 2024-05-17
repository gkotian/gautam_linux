# This file is intended to simply be included from another Makefile. It defines
# additional convenience variables & targets.

# Protip: When including this file from the main Makefile, prefix '-' to the
# include statement like so:
#     -include ${HOME}/.config/resonanz/extras.Makefile
# That way, if the file doesn't exist, the 'help' target won't be available, but
# at least the other targets will work as expected.


# ---- Variables ---------------------------------------------------------------

# Variables to control coloured output. Can be used in echo/printf statements,
# like so:
#     foo:
#         @echo "${RED}this text will be red, ${GREEN}while this will be green"
# To disable coloured output, prefix the make command with 'NOCOLOR=1', like so:
#     $> NOCOLOR=1 make help
ifndef NOCOLOR
	RED    := $(shell tput -Txterm setaf 1)
	GREEN  := $(shell tput -Txterm setaf 2)
	YELLOW := $(shell tput -Txterm setaf 3)
	RESET  := $(shell tput -Txterm sgr0)
endif


# ---- Targets -----------------------------------------------------------------

# Provides friendly help texts for other targets defined in the main Makefile.
# To configure the help text for a target, simply add a single line comment
# starting with '##' on the line immediately preceding the target, like so:
#
#     ## This comment will be the help text for target 'foo'
#     foo:
#         <commands-of-target-foo>
help:
	@awk '/^[a-zA-Z_0-9%:\\\/-]+:/ { \
		msg = match(lastLine, /^## (.*)/); \
			if (msg) { \
				cmd = $$1; \
				msg = substr(lastLine, RSTART + 3, RLENGTH); \
				gsub("\\\\", "", cmd); \
				gsub(":+$$", "", cmd); \
				printf "  ${GREEN}make %-20s${RESET} %s\n", cmd, msg; \
			} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

# Runs a simple spell check
spellcheck:
	@set -e; \
	EXIT_CODE=0; \
	docker image inspect spellcheck >/dev/null 2>&1 || EXIT_CODE="$$?"; \
	if [ "$$EXIT_CODE" -ne 0 ]; then \
		echo "Image 'spellcheck' not found."; \
		echo "Check resonanz/misc/README.md in the ops repo to see how it's built"; \
		false; \
	fi
	@docker run --rm --tty \
		--mount "type=bind,source=${PWD},target=/project,readonly" \
		spellcheck:latest

.PHONY: help \
	spellcheck
