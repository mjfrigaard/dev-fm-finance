from shiny import App, ui, render


def percent_of_income(expense, income):
    return (expense / income) * 100


def to_annual(amount, period):
    factors = {"daily": 365, "weekly": 52, "monthly": 12}
    return amount * factors[period]


def opportunity_cost(amount, rate, years):
    return amount * (1 + rate) ** years


def months_to_break_even(upfront_cost, monthly_savings):
    return upfront_cost / monthly_savings


app_ui = ui.page_navbar(
    ui.nav_panel(
        "Percent of Income",
        ui.layout_sidebar(
            ui.sidebar(
                ui.input_numeric("pct_expense", "Expense ($)", value=1500, min=0, step=50),
                ui.input_numeric("pct_income", "Take-home income ($)", value=5000, min=1, step=100),
            ),
            ui.card(
                ui.card_header("Percent of income"),
                ui.output_text_verbatim("pct_result"),
            ),
        ),
    ),
    ui.nav_panel(
        "Annualizing",
        ui.layout_sidebar(
            ui.sidebar(
                ui.input_numeric("ann_amount", "Amount ($)", value=5, min=0, step=1),
                ui.input_select(
                    "ann_period", "Period",
                    choices={"daily": "Daily", "weekly": "Weekly", "monthly": "Monthly"},
                ),
            ),
            ui.card(
                ui.card_header("Annual equivalent"),
                ui.output_text_verbatim("ann_result"),
            ),
        ),
    ),
    ui.nav_panel(
        "Opportunity Cost",
        ui.layout_sidebar(
            ui.sidebar(
                ui.input_numeric("opp_amount", "Amount ($)", value=25000, min=0, step=1000),
                ui.input_numeric("opp_rate", "Annual return (%)", value=7, min=0, max=30, step=0.5),
                ui.input_numeric("opp_years", "Years", value=30, min=1, max=50, step=1),
            ),
            ui.card(
                ui.card_header("Future value"),
                ui.output_text_verbatim("opp_result"),
            ),
        ),
    ),
    ui.nav_panel(
        "Break-Even",
        ui.layout_sidebar(
            ui.sidebar(
                ui.input_numeric("be_upfront", "Upfront cost ($)", value=500, min=0, step=50),
                ui.input_numeric("be_savings", "Monthly savings ($)", value=60, min=0.01, step=5),
            ),
            ui.card(
                ui.card_header("Months to break even"),
                ui.output_text_verbatim("be_result"),
            ),
        ),
    ),
    title="Budgeting Math",
)


def server(input, output, session):
    @render.text
    def pct_result():
        pct = percent_of_income(input.pct_expense(), input.pct_income())
        return f"{pct:.1f}% of income"

    @render.text
    def ann_result():
        annual = to_annual(input.ann_amount(), input.ann_period())
        return f"${annual:,.2f} / year"

    @render.text
    def opp_result():
        fv = opportunity_cost(input.opp_amount(), input.opp_rate() / 100, input.opp_years())
        return f"${fv:,.0f}"

    @render.text
    def be_result():
        months = months_to_break_even(input.be_upfront(), input.be_savings())
        return f"{months:.1f} months ({months / 12:.1f} years)"


app = App(app_ui, server)
