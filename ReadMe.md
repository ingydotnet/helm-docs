helm-docs
=========

https://helm.sh/docs/ using [MkDocs Material](
https://squidfunk.github.io/mkdocs-material/)


## Overview

This repo is exploring how Helm's doc site might work using MkDocs Material
static documentation site framework.

The repo contains a `mkdocs.yml` config file, which at the moment is minimal.

The site currently only serves the `en` English pages, but will soon serve all
language content.

The published site is here: <https://ingydotnet.github.io/helm-docs/>.


## Usage

Clone this repo in a terminal and then run `make serve`.

This will:

* Install all the deps under `.venv/`
* Clone the Helm docs repo content
* Copy the content pages into the `docs/` directory
* Start a local site server: http://127.0.0.1:8000/helm-docs/

Open the URL.

You can make changes to the source files and the web page will show the
changes automatically.

For now we will mostly be trying out various MkDocs plugins, adding them to the
`mkdocs.yml` config file.

Use `ctrl+C` to stop the server.
