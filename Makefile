SHELL := /bin/bash
PYTHON_VERSION := 3.13
OS_VERSION_ID := $(shell . /etc/os-release && echo $$VERSION_ID)
OS_CODENAME := $(shell . /etc/os-release && echo $$VERSION_CODENAME)
IS_WSL := $(shell if [[ -n "$$WSL_DISTRO_NAME" ]] || grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then echo "true"; else echo "false"; fi)


uv:  ## installs uv
	@if [[ ! -f ~/.local/bin/uv ]] ; then \
	    echo "installing uv..." ; \
		curl -LsSf https://astral.sh/uv/install.sh | sh ; \
	fi
	@export PATH="~/.local/bin:$$PATH"
	@echo "uv is installed at: $$(which uv)"
	@~/.local/bin/uv --version
	@~/.local/bin/uv python install cpython$(PYTHON_VERSION)

setup:
	@if [[ -f ~/.local/bin/uv ]] && [[ ! -f .venv/bin/python ]] ; then ~/.local/bin/uv python install cpython$(PYTHON_VERSION) ; ~/.local/bin/uv venv --python $(PYTHON_VERSION) ; fi
	source .venv/bin/activate \
	  && ~/.local/bin/uv pip install -U wheel \
	  && ~/.local/bin/uv pip install pip \
	  && ~/.local/bin/uv pip install -r requirements.txt

geckodriver:
	if [[ ! -f ./geckodriver ]] ; then wget https://github.com/mozilla/geckodriver/releases/download/v0.36.0/geckodriver-v0.36.0-linux64.tar.gz ; tar xzf geckodriver-v0.36.0-linux64.tar.gz ; rm geckodriver-v0.36.0-linux64.tar.gz ; fi
