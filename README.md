[//]: <> (BEGIN: HEADER)

# md2anki

Convert Markdown formatted documents to anki decks

[//]: <> (END: HEADER)

[![PyPI version](https://badge.fury.io/py/md2anki.svg)](https://badge.fury.io/py/md2anki)

The decks were tested on:

- [Anki (Desktop client, 2.1.56)](https://apps.ankiweb.net/)
- [Anki web (Browser client, 02.2022)](https://ankiweb.net/)
- [AnkiDroid (Android client, 2.15.6)](https://play.google.com/store/apps/details?id=com.ichi2.anki)

**TODO**:

- [ ] Add tests for anki note generation
- [ ] Enable code execution to additionally generate:
  - [ ] LaTeX `tikzpicture` Graphs

## Features

- Create an anki deck `.apkg` file
- The name of the deck and its notes will be updated on your next deck import (this works via automatic IDs, **deletions can not be tracked!**)
- Very simple basic structure that supports additionally anki note tags and anki subdecks:

- Supported question/answer content:
  - LaTeX math (inline and blocks)
  - Images (local files and URLs, vector and raster format)
  - Code (inline and blocks)
  - All basic Markdown features (i.e. tables, bold, italics, lines)
- Merge notes from multiple markdown input files into a single deck output file
- Export document and all used local assets to a custom directory that can easily be shared or used as backup

To evaluate code and export to pdf the following additional software needs to be installed:

```sh
# Linux (the apt package manager is just an example)
# > Evaluate code
sudo apt install clang nodejs
# > PDF export
sudo apt install librsvg2-bin pandoc texlive-xetex
```

```ps1
# Windows (the choco package manager is just an example)
# > Evaluate code
choco install llvm nodejs
# > PDF export
choco install miktex pandoc rsvg-convert
```

(On Windows `rsvg-convert` can sometimes throw errors in combination with `pandoc` but the latest build from [miyako](https://github.com/miyako/console-rsvg-convert/releases) does not throw them so try this one if you get errors)


```sh
# Linux + Windows
npm install -g ts-node
# > For matplotlib python graphs (used in some examples):
python -m pip install numpy matplotlib
```

### Examples

Checkout the [`examples`](examples) directory for more examples.

[//]: <> (BEGIN: EXAMPLES)

```markdown
# Example 'Basic' (3714486828)

## One line question (66b3661f-e22e-4986-a50d-569fdac454ad)

One line answer

## Multi line (24501c1a-f615-4355-a862-a00f64cc4725)

question thanks to a question answer separator (`---`)

---

Answer that has multiple lines.

**Basic** *Markdown* and <ins>HTML</ins> <del>formatting</del> is supported.

## Question with multiple (parenthesis) (is) (possible) (b7b85393-b76d-43e6-965a-d86108bf5b09)

Answer

## Lines in answers with multiple `---` (f0e03cb6-2015-4f64-bcd3-51e24763705b)

First question answer seperator in the question.

---

Answer

---

Second part of answer with a line before it.
```

```markdown
# Example 'Subdeck' (750441971)

Example document to show how subdecks work.

`{=:global_tag:=}`

## Question 1 (f51d6aa5-1e39-4ad7-94fb-042f7084eff5)

Answer

## Subdeck: Subdeck Heading 1 (406542328)

All notes of the level 3 will be added to this subdeck.

`{=:subdeck_tag_1:=}`

### Question 1.1 (583813da-5766-4cb8-b39f-ae0337e1f13c)

Answer

## Question 1.2 (f51d6aa5-1e39-4ad8-94fb-047f7094eff5)

Answer

## Subdeck: Subdeck Heading 2 (406541128)

`{=:subdeck_tag_2:=}`

### Question 2.1 (583813da-5766-4cb8-b39f-ae0337e1f13c)

Answer

### Subdeck: Subdeck Heading 3 (406641128)

All notes of the level 4 will be added to this subdeck.

`{=:subdeck_subdeck_tag:=}`

#### Question 3.1 (583813da-5786-4cb8-b39f-ae0337e1f13c)

Answer

### Question 2.2 (583223da-5786-4cb8-b39f-ae0337e1f13c)

Answer
```

[//]: <> (END: EXAMPLES)

## Usage

[//]: <> (BEGIN: USAGE)

```text
usage: md2anki [-h] [-v] [-d] [-anki-model MODEL_ID] [-o-anki APKG_FILE]
               [-o-md MD_FILE] [-o-md-dir MD_DIR] [-o-backup-dir BACKUP_DIR]
               [-o-pdf PDF_FILE] [-file-dir [FILE_DIR ...]]
               [-md-heading-depth HEADING_DEPTH]
               [-custom-program language program]
               [-custom-program-args language program-args]
               MD_INPUT_FILE [MD_INPUT_FILE ...]

Create an anki deck file (.apkg) from one or more Markdown documents. If no
custom output path is given the file name of the document (+ .apkg) is used.

positional arguments:
  MD_INPUT_FILE         Markdown (.md) input file that contains anki deck
                        notes

options:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit
  -d, --debug           enable debug output (default: False)
  -anki-model MODEL_ID  custom anki card model (md2anki_default,
                        md2anki_type_answer) (default: md2anki_default)
  -o-anki APKG_FILE     custom anki deck (.apkg) output file path [if not
                        given: md input file name + .apkg] (default: None)
  -o-md MD_FILE         custom updated (and merged if multiple input files)
                        Markdown (.md) output file path for all input files
                        (default: None)
  -o-md-dir MD_DIR      custom output directory for all updated Markdown (.md)
                        input files (default: None)
  -o-backup-dir BACKUP_DIR
                        create a backup of the anki deck (i.e. merges input
                        files and copies external files) in a directory
                        (default: None)
  -o-pdf PDF_FILE       create a PDF (.pdf) file of the anki deck (i.e. merges
                        input files and removes IDs) (default: None)
  -file-dir [FILE_DIR ...]
                        add directories that should be checked for referenced
                        files (like relative path images) (default: [])
  -md-heading-depth HEADING_DEPTH
                        use a custom Markdown heading depth (>=1) (default: 1)
  -custom-program language program
                        use custom program for code evaluation (default:
                        [('py', 'python'), ('js', 'node'), ('ts', 'ts-node'),
                        ('cpp', 'clang++'), ('cpp', 'main.exe'), ('c',
                        'clang'), ('c', 'main.exe')])
  -custom-program-args language program-args
                        use custom program args for code evaluation (default:
                        [('py', '["-c", "MD2ANKI_CODE"]'), ('js', '["-e",
                        "MD2ANKI_CODE"]'), ('ts',
                        '["MD2ANKI_CODE_FILE=code.ts"]'), ('cpp', '["-Wall",
                        "-std=c++20", "MD2ANKI_CODE_FILE=main.cpp", "-o",
                        "main.exe"]'), ('cpp', '[]'), ('c', '["-std=c17",
                        "MD2ANKI_CODE_FILE=main.c", "-o", "main.exe"]'), ('c',
                        '[]')])
```

[//]: <> (END: USAGE)

## Install

### PyPI

It can be installed using [`pip`](https://pypi.org/project/md2anki/):

```sh
# Install
pip install md2anki
# Uninstall
pip uninstall md2anki
```

### GitHub Releases

1. Download a wheel (`.whl`) file from [GitHub Releases](https://github.com/AnonymerNiklasistanonym/Md2Anki/releases)
2. Run:

   ```sh
   # Install
   pip install md2anki-$CURRENT_VERSION-py3-none-any.whl
   # Uninstall
   pip uninstall md2anki
   ```

### Build

Via the file [`setup.py`](setup.py) the package can be built:

#### Create package files

The following commands create the package files in a new directory called `dist`:

- `md2anki-$CURRENT_VERSION-py3-none-any.whl`
- `md2anki-$CURRENT_VERSION.tar.gz`

```sh
python -m pip install --upgrade build
python -m build
```

#### Install package files

The wheel (`.whl`) file can be installed and uninstalled via `pip`:

```sh
# Install
python -m pip install dist/md2anki-$CURRENT_VERSION-py3-none-any.whl
# Uninstall
python -m pip uninstall md2anki
```

## Markdown Editors

A list of editors which support WYSIWYG editing of such Markdown documents (source code and math blocks):

- [Typora](https://typora.io/) (paid, free to use until version 0.9)
- [Visual Studio Code](https://code.visualstudio.com/) (open source)

## Development

### Dependencies

- [`beautifulsoup4`](https://pypi.org/project/beautifulsoup4/): Edit HTML
- [`genanki`](https://pypi.org/project/genanki/): Write Anki decks
- [`Markdown`](https://pypi.org/project/Markdown/): Convert Markdown to HTML
- [`Pygments`](https://pypi.org/project/Pygments/): Convert source code to HTML with syntax highlighting/colors

```sh
python -m pip install --upgrade pip
# Runtime dependencies
python -m pip install --upgrade beautifulsoup4 genanki Markdown Pygments
# Save requirements
python -m pip freeze > "requirements.txt"
```

### Upload package to PyPI

1. [Create an PyPI account](https://pypi.org/account/login/)
2. Go to account settings, Scroll to API tokens, Create PyPI API token (with only the project scope if project already exists)

```sh
# Build
python -m pip install --upgrade pip build
python -m build
# Upload (only if a non existing version is found)
python -m pip install twine
python -m twine upload --skip-existing dist/*
# Use as username: "__token__"
# Use as password the created PyPI API token: "pypi-......"
```

### Type checks

Python files can be checked for type errors (to some extent) using the commands:

```sh
python -m pip install --upgrade mypy types-beautifulsoup4 types-Markdown types-Pygments
python -m mypy src setup.py examples tests clean.py main.py update_readme.py
```

### Format code

Python files can be formatted using the commands:

```sh
python -m pip install --upgrade black
# Add the option --check to only check if its already in the correct format
python -m black src setup.py examples tests clean.py main.py update_readme.py
```

### Code editors

This project was written using the following code editors (IDEs):

- [PyCharm (Community)](https://www.jetbrains.com/pycharm/download/)
- [Visual Studio Code](https://code.visualstudio.com/)
