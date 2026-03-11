# MedDec Makefile
# PhysioNet user: set PHYSIONET_USER=your_username or 'source config.local' before make

PHYSIONET_USER ?= vasudev13
MIMIC_URL  := https://physionet.org/files/mimiciii/1.4/
MEDDEC_URL := https://physionet.org/files/meddec/1.0.0/

.PHONY: help install install-uv venv download download-mimic download-meddec run clean

help:
	@echo "MedDec targets:"
	@echo "  make install       - install uv (if needed), create venv, install from requirements.txt"
	@echo "  make install-uv    - install uv only"
	@echo "  make venv          - create venv and install requirements (assumes uv is installed)"
	@echo "  make download      - download MIMIC-III and MedDec from PhysioNet (prompts for password)"
	@echo "  make download-mimic  - download MIMIC-III only"
	@echo "  make download-meddec - download MedDec only"
	@echo "  make run           - run main.py (activate .venv first or use: .venv/bin/python main.py)"
	@echo "  make clean         - remove .venv and __pycache__"
	@echo ""
	@echo "Override PhysioNet user: PHYSIONET_USER=your_username make download"
	@echo "Or: source config.local  # then make download"

install-uv:
	@command -v uv >/dev/null 2>&1 || (echo "Installing uv..." && curl -LsSf https://astral.sh/uv/install.sh | sh)
	@uv --version

venv: install-uv
	uv venv
	uv pip install -r requirements.txt

install: venv
	@echo "Done. Activate with: source .venv/bin/activate"

download-mimic:
	wget -r -N -c -np --user "$(PHYSIONET_USER)" --ask-password "$(MIMIC_URL)"

download-meddec:
	wget -r -N -c -np --user "$(PHYSIONET_USER)" --ask-password "$(MEDDEC_URL)"

download: download-mimic download-meddec

run:
	.venv/bin/python main.py

clean:
	rm -rf .venv
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
