.PHONY: help setup codegen run analyze test check format clean

FLUTTER ?= flutter
DART ?= dart
# Pass your key with: make run ANTHROPIC_API_KEY=sk-ant-...
ANTHROPIC_API_KEY ?=

help:
	@echo "make setup    - create .env from .env.example and fetch packages"
	@echo "make codegen  - regenerate Hive adapters (*.g.dart)"
	@echo "make run      - flutter run with ANTHROPIC_API_KEY passed via --dart-define"
	@echo "make analyze  - static analysis"
	@echo "make test     - unit tests"
	@echo "make check    - analyze + file-size + structure report"
	@echo "make format   - dart format lib/"
	@echo "make clean    - flutter clean"

setup:
	@test -f .env || cp .env.example .env
	$(FLUTTER) pub get

codegen:
	$(DART) run build_runner build --delete-conflicting-outputs

run: setup
	$(FLUTTER) run --dart-define=ANTHROPIC_API_KEY=$(ANTHROPIC_API_KEY)

analyze:
	$(FLUTTER) analyze

test:
	$(FLUTTER) test

check:
	./scripts/check_quality.sh

format:
	./scripts/format_all.sh

clean:
	$(FLUTTER) clean
