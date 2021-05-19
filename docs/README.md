# Regula documentation README

## Writing docs

To add a new page to the docs site: 

1. Create a `.md` file in the `regula/docs` directory
2. Add the filename to `regula/mkdocs.yml`

To link to other pages on the docs site, use relative links and specify the `.md` filename, not `.html`

Examples:

- `getting-started.md`
- `../getting-started.md`
- `../getting-started.md#installation`

For more information about working with our static site generator, see [MkDocs](https://www.mkdocs.org/). For more info about the theme (including how to use features like admonitions, code highlighting, emoji, etc.), see [Material for MkDocs](https://squidfunk.github.io/mkdocs-material-insiders/getting-started/).

## Previewing the docs site

Here's how to preview the docs site.

### Install MkDocs

1. Create a virtual environment:

```
python3 -m venv venv
```

2. Activate the virtual environment:

```
. venv/bin/activate
```

3. Install MkDocs and theme:

```
pip install mkdocs mkdocs-material
```

### Build the site - live preview

**Use this for local development.** This step kicks off a development server with live reload. Whenever you make changes to a file, MkDocs will automatically regenerate the file and refresh the site.

1. If you're not already in the virtual environment, activate it:

```
. venv/bin/activate
```

2. From the root of the `regula` repo, start the server:

```
mkdocs serve
```

You can view the site at http://127.0.0.1:8000

### Build the site

If you only need the generated site files and not a live preview (e.g., if you're manually deploying the site), run this command:

```
mkdocs build
```

MkDocs generates the site in the `site` directory.