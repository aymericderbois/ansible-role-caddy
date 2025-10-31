.PHONY: help install lint test test-all test-distro clean ci

.DEFAULT_GOAL := help

help: ## Afficher cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Installer les dependances avec uv
	uv sync

lint: ## Lancer les linters (yamllint et ansible-lint)
	uv run yamllint .
	uv run ansible-lint

test: ## Lancer les tests Molecule (Debian 12 par defaut)
	uv run molecule test

test-all: ## Lancer tous les tests Debian 11, 12 et 13
	MOLECULE_DISTRO=debian11 uv run molecule test
	MOLECULE_DISTRO=debian12 uv run molecule test
	MOLECULE_DISTRO=debian13 uv run molecule test

test-distro: ## Lancer les tests pour une distro specifique (usage: make test-distro DISTRO=debian12)
	MOLECULE_DISTRO=$(DISTRO) uv run molecule test

clean: ## Nettoyer les fichiers temporaires et l'environnement Molecule
	uv run molecule destroy

ci: lint test ## Simuler le pipeline CI localement
