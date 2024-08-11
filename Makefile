# Disable printing "Entering/Leaving directory ..."
MAKEFLAGS += --no-print-directory

NUMPROC ?= $(shell nproc)

.PHONY: help \
		.jp-build-only .jp-check-files-on-error jp-configure jp-build jp-extract-data jp-make-asm jp-map-mismatch jp-clean

.DEFAULT_GOAL := help

# python script that parses makefiles and pretty-prints help messages
define PY_HELP_SCRIPT
import os
import re
import sys

CYAN = "\033[36m"
CRST = "\033[0m"

makefiles = sys.argv[1:]
target_max_len = 0
target_help_list = []

for file in makefiles:
	with open(file, mode="r") as fh:
		for line in fh:
			if match := re.match(r"^([a-zA-Z0-9_-]+):\s*##\s*(.*)$$", line):
				target, help_str = match.groups()
				target_max_len = max(target_max_len, len(target))
				target_help_list.append((target, help_str))

			if match := re.match(r"^##\s*(.*)$$", line):
				comment = match.group(1)
				target_help_list.append((None, comment))

all_targets = [target for target, help_or_comment in target_help_list if target]

print(f"{CYAN}usage:{CRST} make <{CYAN}{f'{CRST}|{CYAN}'.join(all_targets)}{CRST}>")
print()

for target, help_or_comment in target_help_list:
	if target:
		print(f"  {CYAN}{target:{target_max_len + 2}s}{CRST} {help_or_comment}")
	else:
		print(help_or_comment)

print()
endef

export PY_HELP_SCRIPT
PYHELP := python3 -c "$$PY_HELP_SCRIPT"

help: ## Show this help
	@$(PYHELP) $(MAKEFILE_LIST)
##
## JP Commands:
jp-configure: ## Configure JP project (needs SLPS_250.57)
	@python3 configure.py config/jp/kf4.jp.yaml -c

.jp-build-only:
	@cd config/jp; \
	ninja -t clean; \
	ninja -j$(NUMPROC)

.jp-check-files-on-error:
	ls -l config/jp/build/SLPS_250.57 config/jp/SLPS_250.57

jp-build: ## Build JP project
	@$(MAKE) .jp-build-only || $(MAKE) .jp-check-files-on-error

jp-extract-data:  ## Extract variables from .data in JP config directory
	@python3 tools/python/parse_data.py jp

jp-make-asm:  ## Create expected asm folder in JP config directory
	@python3 configure.py config/jp/kf4.jp.yaml --make-asm

jp-map-mismatch:  ## Check for mismatches in JP mapfile
	@python3 tools/python/map_mismatch.py --language jp

jp-clean:  ## Clean artifact in JP config directory
	@cd config/jp; \
	ninja -t clean;

# Include custom makefile for user-defined commands
-include Makefile.custom
