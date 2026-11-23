.PHONY: install compile test lint typecheck verify clean players-data players-results paper2

install:
	uv sync --extra dev

compile:
	uv run python -m compileall -q src tests

test:
	uv run pytest

lint:
	uv run ruff check .
	uv run ruff format --check .

typecheck:
	uv run mypy

verify: compile lint typecheck test

# Data: downloads (cached, with SHA-256 manifests) and processed tables.
players-data:
	uv run python scripts/players/acquire_transfermarkt.py
	uv run python scripts/players/acquire_statsbomb.py
	uv run python scripts/players/build_panel.py
	uv run python scripts/players/acquire_asa.py

# Every analysis, master seed 20261114 (pre-registration A12). Hours, not minutes.
players-results:
	uv run python scripts/players/run_descriptive.py
	uv run python scripts/players/run_impact.py
	uv run python scripts/players/run_tournaments.py
	uv run python scripts/players/run_league.py
	uv run python scripts/players/run_ranking.py

# Numbers, tables and figures come from results/players/, never typed into the paper.
# The finished PDF is copied to the repository root so it is visible on GitHub.
paper2:
	uv run python scripts/players/make_paper2.py
	latexmk -pdf -g -halt-on-error -interaction=nonstopmode -outdir=build -cd paper-unmeasured/main.tex
	cp paper-unmeasured/build/main.pdf The-Unmeasured-Remainder.pdf

clean:
	rm -rf .pytest_cache .mypy_cache .ruff_cache paper-unmeasured/build
	find . -name __pycache__ -type d -exec rm -rf {} +
