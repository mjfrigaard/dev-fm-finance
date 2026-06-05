# DEV (fm-finance)

This folder is for testing the code and functions in the fm-finance book.

## Shiny apps

Interactive apps live under `_apps/`, organized by language and chapter:

```
_apps/
├── R/
│   └── budgeting/
│       └── app.R
└── Python/
    └── budgeting/
        └── app.py
```

### R

From an R session (with `shiny` and `bslib` installed):

```r
shiny::runApp("_apps/R/budgeting")
```

Or from the terminal:

```bash
Rscript -e 'shiny::runApp("_apps/R/budgeting")'
```

### Python

With `shiny` installed (`pip install shiny`):

```bash
shiny run _apps/Python/budgeting/app.py
```

To enable auto-reload during development:

```bash
shiny run --reload _apps/Python/budgeting/app.py
```
