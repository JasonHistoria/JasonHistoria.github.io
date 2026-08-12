# Personal homepage — Jinghao Liu

Built from [al-folio](https://github.com/alshedivat/al-folio) v1.x (Jekyll).
Deploys to GitHub Pages via `.github/workflows/deploy.yml` on every push to `main`.

## Preview locally

```sh
./serve.sh          # → http://localhost:4000
```

Ruby comes from a conda env, not the system: system Ruby here is 3.0.2 (too old
for the `bundler 4.x` this lockfile needs) and has no dev headers, and this user
is not in the `docker` group so the upstream `docker compose up` path is closed.
`serve.sh` documents the one-time env setup at the top if the env goes missing.

## The CV

The PDF at `assets/pdf/cv.pdf` is **built from `assets/rendercv/main.tex`** — plain
LaTeX, not rendercv's YAML format despite the directory name. After editing the
`.tex`, rebuild and reinstall the PDF:

```sh
cd assets/rendercv
pdflatex -interaction=nonstopmode main.tex && pdflatex -interaction=nonstopmode main.tex
cp main.pdf ../pdf/cv.pdf && rm -f main.aux main.log main.out main.pdf
```

It is tuned to fit on **one page**; the margin and `\titlespacing` in the preamble
are what hold it there. Adding a bullet will usually spill to page 2 — check the
page count before committing.

## Design overrides

The visual changes to stock al-folio live in exactly two files:

- `_sass/_custom.scss` — all of them. Accent colour, link/focus treatment,
  publication chips, section rules, reduced-motion guard. Commented per block.
- `assets/css/main.scss` — a shadow of the gem's entry point, byte-identical
  except for one added `@use "custom"` line at the end.

On upgrading `al_folio_core`, diff `assets/css/main.scss` against the gem's copy
in `vendor/bundle/ruby/*/gems/al_folio_core-*/assets/css/main.scss` and re-apply
that one line if the entry point changed. Nothing else is shadowed.

## Still to do

| Where | What |
| --- | --- |
| `_data/cv.yml` | Two years marked `<-- CHECK` are guesses: UW `start_date: 2022`, UCSD `end_date: 2028`. |
| `_pages/misc.md` | Write a few lines, then set `nav: true`. Hidden from the nav until you do. |
| `_data/cv.yml` | `Experience:` section is commented out — the LaTeX CV has the content if you want to mirror it. |
| `_bibliography/papers.bib` | Add `code = {...}` when the Flex-π repo goes public. |
| `_data/coauthors.yml` | Homepages for Yuzhi Fan, Lei Cai, Minwen Liao, Jesse Zhang — they get auto-linked. |
| `assets/rendercv/main.tex` | Contact email is `jliu63@uw.edu`; the site uses `jliu63@cs.washington.edu`. Pick one. |

YAML gotcha: an unquoted value containing `: ` breaks the build, and the error
does not name the file. Write `label: "Foo: bar"`, not `label: Foo: bar`.
BibTeX gotcha: `%` is not a comment character inside a `.bib` entry.

## Deploy

The repo **must** be named `JasonHistoria.github.io` — that is what makes the URL
`https://jasonhistoria.github.io` with a blank baseurl.

```sh
git init && git add -A && git commit -m "Personal homepage"
gh repo create JasonHistoria.github.io --public --source=. --push
```

Then in the repo's **Settings → Pages**, set Source to *Deploy from a branch* →
branch `gh-pages` / root. The workflow builds `_site` and force-pushes it to
`gh-pages`; the first run takes a few minutes.

## Structure

| Path | Holds |
| --- | --- |
| `_pages/about.md` | homepage: bio, then news, then selected papers (order is fixed by the theme) |
| `_pages/publications.md` | renders everything in `_bibliography/papers.bib` |
| `_pages/cv.md` + `_data/cv.yml` | CV page; the page is a stub, content lives in the YAML |
| `_pages/misc.md` | the personal corner |
| `_news/*.md` | one file per news line, shown newest-first on the homepage |
| `_data/coauthors.yml` | co-author homepages, auto-linked in author lists |
| `_data/venues.yml` | the coloured venue badge to the left of each paper |
| `_data/socials.yml` | the icon row under your photo |

Adding a paper = one entry in `papers.bib`. `selected={true}` also puts it on the
homepage; `preview={file.jpg}` (in `assets/img/publication_preview/`) gives it a
thumbnail. Full field list: `docs/CUSTOMIZE.md`.

## Deviations from upstream al-folio

- Demo content removed: blog, projects, books, teaching, repositories, profiles pages; Einstein's bibliography; the demo Jupyter notebook.
- CI trimmed to `deploy.yml` only — the other 20 workflows test al-folio itself and would fail here.
- `external_sources` emptied: upstream pulled posts from a stranger's Medium feed on every build.
- Publication citation badges (Altmetric/Dimensions/Scholar) off — a day-old preprint has none. Turn `google_scholar` back on in `_config.yml` once indexed.
- `max_author_limit` blanked so all seven authors show.
- Pagination and blog features off; there is no blog.
