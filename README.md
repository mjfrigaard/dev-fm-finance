# DEV (fm-finance)

Interactive exercises for [Personal Finance: a Field Manual](https://mjfrigaard.github.io/fm-finance/). Each page matches a chapter in the book. It opens with Book Topics (a short chapter summary), then turns each math topic into a bar model and three levels of exercises:

* Level 1 (Guided): fill in the blanks of a finished formula.
* Level 2 (Practice): use the same formula on new numbers.
* Level 3 (Challenge): answer a new question with less help.

Each level has Excel, Python, and R tabs. The R and Python exercises run in the browser through the [quarto-live](https://github.com/r-wasm/quarto-live) extension (`_extensions/r-wasm/live/`), so readers don't need to install anything.

## Contents

```
Foundations        income, tracking_spending, budgeting, managing_debt, emergency_fund
Savings            savings_strategies, high_yield_accounts, automating_savings
Investing          investing_basics, retirement_accounts, index_funds, asset_allocation
Taxes & Insurance  taxes, insurance
Planning           financial_goals, major_purchases, estate_planning
Resources          r_vs_py, setup
```

Shared setup code lives in `_common.R` and `_common.py`. Themes are in `custom.scss`, `terminal.scss`, `light.scss`, and `dark.scss`.

## Rendering

Render locally (requires Quarto, R, and Python):

```bash
quarto render
```

Results are frozen in `_freeze/` (`freeze: auto`), so commit `_freeze/` after rendering. Pushing to `main` runs `.github/workflows/publish.yml`, which renders from the frozen results and deploys `_site/` to GitHub Pages.
