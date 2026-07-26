# ==============================================================================
# DiLang Developer Automation Makefile
# Delegates command targets to modular scripts in scripts/ directory
# ==============================================================================

.PHONY: setup doctor generate build run test lint clean models release

setup:
	@./scripts/setup.sh

doctor:
	@./scripts/doctor.sh

generate:
	@./scripts/generate.sh

build:
	@./scripts/build.sh $(target)

run:
	@./scripts/run.sh $(platform)

test:
	@./scripts/test.sh

lint:
	@./scripts/lint.sh

clean:
	@./scripts/clean.sh $(mode)

models:
	@./scripts/models.sh $(action)

release:
	@./scripts/release.sh $(target)
