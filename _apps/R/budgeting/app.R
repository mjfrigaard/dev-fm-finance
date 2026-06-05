library(shiny)
library(bslib)

percent_of_income <- function(expense, income) (expense / income) * 100

to_annual <- function(amount, period) {
  factors <- c(daily = 365, weekly = 52, monthly = 12)
  amount * factors[[period]]
}

opportunity_cost <- function(amount, rate, years) amount * (1 + rate)^years

months_to_break_even <- function(upfront_cost, monthly_savings) {
  upfront_cost / monthly_savings
}

ui <- page_navbar(
  title = "Budgeting Math",
  theme = bs_theme(bootswatch = "flatly"),

  nav_panel(
    "Percent of Income",
    layout_sidebar(
      sidebar = sidebar(
        numericInput("pct_expense", "Expense ($)", value = 1500, min = 0, step = 50),
        numericInput("pct_income", "Take-home income ($)", value = 5000, min = 1, step = 100)
      ),
      card(
        card_header("Percent of income"),
        verbatimTextOutput("pct_result")
      )
    )
  ),

  nav_panel(
    "Annualizing",
    layout_sidebar(
      sidebar = sidebar(
        numericInput("ann_amount", "Amount ($)", value = 5, min = 0, step = 1),
        selectInput("ann_period", "Period",
          choices = c("Daily" = "daily", "Weekly" = "weekly", "Monthly" = "monthly"))
      ),
      card(
        card_header("Annual equivalent"),
        verbatimTextOutput("ann_result")
      )
    )
  ),

  nav_panel(
    "Opportunity Cost",
    layout_sidebar(
      sidebar = sidebar(
        numericInput("opp_amount", "Amount ($)", value = 25000, min = 0, step = 1000),
        numericInput("opp_rate", "Annual return (%)", value = 7, min = 0, max = 30, step = 0.5),
        numericInput("opp_years", "Years", value = 30, min = 1, max = 50, step = 1)
      ),
      card(
        card_header("Future value"),
        verbatimTextOutput("opp_result")
      )
    )
  ),

  nav_panel(
    "Break-Even",
    layout_sidebar(
      sidebar = sidebar(
        numericInput("be_upfront", "Upfront cost ($)", value = 500, min = 0, step = 50),
        numericInput("be_savings", "Monthly savings ($)", value = 60, min = 0.01, step = 5)
      ),
      card(
        card_header("Months to break even"),
        verbatimTextOutput("be_result")
      )
    )
  )
)

server <- function(input, output, session) {

  output$pct_result <- renderText({
    pct <- percent_of_income(input$pct_expense, input$pct_income)
    sprintf("%.1f%% of income", pct)
  })

  output$ann_result <- renderText({
    annual <- to_annual(input$ann_amount, input$ann_period)
    sprintf("$%s / year", format(round(annual, 2), big.mark = ",", nsmall = 2))
  })

  output$opp_result <- renderText({
    fv <- opportunity_cost(input$opp_amount, input$opp_rate / 100, input$opp_years)
    sprintf("$%s", format(round(fv), big.mark = ","))
  })

  output$be_result <- renderText({
    months <- months_to_break_even(input$be_upfront, input$be_savings)
    sprintf("%.1f months (%.1f years)", months, months / 12)
  })
}

shinyApp(ui, server)
