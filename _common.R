set.seed(1014)

# Python environment ----
# Pin to the project virtualenv before any py_* call so that both
# py_module_available() and the Python chunks use the same interpreter.
# required = FALSE lets it fall back gracefully on a fresh machine.
reticulate::use_virtualenv("r-reticulate", required = FALSE)

# Install any missing packages into whichever Python was just pinned.
for (.pkg in c("numpy", "polars")) {
  if (!reticulate::py_module_available(.pkg)) {
    reticulate::py_install(.pkg, pip = TRUE)
  }
}
rm(.pkg)

# knitr settings ----
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  fig.retina = 2,
  fig.width = 6,
  fig.asp = 2/3,
  fig.show = "hold"
)

# options ----
options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.print_max = Inf,
  pillar.print_min = 20,
  pillar.bold = TRUE,
  width = 60,
  scipen = 9999
)

# Not in ----
"%nin%" <- function(x, y) {
  return(!(x %in% y))
}

# Formatting utilities ----
fmt_dollar <- function(x, digits = 2) {
  paste0("$", formatC(x, format = "f", digits = digits, big.mark = ","))
}

fmt_pct <- function(x, digits = 1) {
  paste0(round(x * 100, digits), "%")
}

co_box <- function(
  color = "b",
  header = "header",
  contents = "Your text",
  size = "1.10",
  hsize = "1.15",
  fold = FALSE,
  look = "default") {
  
  if (look == "simple") {
    look <- "simple"
  } else if (look == "minimal") {
    look <- "minimal"
  } else {
    look <- "default"
  }
  
  fold <- tolower(as.character(fold))
  size <- as.character(size)
  
  class <- switch(color,
    b = "note",
    g = "tip",
    r = "important",
    o = "warning",
    y = "caution",
    stop("Invalid `type`", call. = FALSE)
  )
  
  switch(color,
    b = cat(paste0(
      "\n\n",
      ":::: {.callout-", class, " collapse='", fold, "'", " appearance='", look, "' icon=false}", "\n\n",
      "## [", header, "]{style='font-weight: bold; font-size: ", hsize, "em;'}\n\n",
      "::: {style='font-size: ", size, "em; color: #282b2d;'}\n\n",
      "\n", glue::glue_collapse(contents), "\n\n",
      "::: \n\n",
      "::::", "\n"
    )),
    g = cat(paste0(
      "\n\n",
      ":::: {.callout-", class, " collapse='", fold, "'", " appearance='", look, "' icon=false}", "\n\n",
      "## [", header, "]{style='font-weight: bold; font-size: ", hsize, "em;'}\n\n",
      "::: {style='font-size: ", size, "em; color: #282b2d;'}\n\n",
      "\n", glue::glue_collapse(contents), "\n\n",
      "::: \n\n",
      "::::", "\n"
    )),
    y = cat(paste0(
      "\n\n",
      ":::: {.callout-", class, " collapse='", fold, "'", " appearance='", look, "' icon=false}", "\n\n",
      "## [", header, "]{style='font-weight: bold; font-size: ", hsize, "em;'}\n\n",
      "::: {style='font-size: ", size, "em; color: #282b2d;'}\n\n",
      "\n", glue::glue_collapse(contents), "\n\n",
      "::: \n\n",
      "::::", "\n"
    )),
    o = cat(paste0(
      "\n\n",
      ":::: {.callout-", class, " collapse='", fold, "'", " appearance='", look, "' icon=false}", "\n\n",
      "## [", header, "]{style='font-weight: bold; font-size: ", hsize, "em;'}\n\n",
      "::: {style='font-size: ", size, "em; color: #282b2d;'}\n\n",
      "\n", glue::glue_collapse(contents), "\n\n",
      "::: \n\n",
      "::::", "\n"
    )),
    r = cat(paste0(
      "\n\n",
      ":::: {.callout-", class, " collapse='", fold, "'", " appearance='", look, "' icon=false}", "\n\n",
      "## [", header, "]{style='font-weight: bold; font-size: ", hsize, "em;'}\n\n",
      "::: {style='font-size: ", size, "em; color: #282b2d;'}\n\n",
      "\n", glue::glue_collapse(contents), "\n\n",
      "::: \n\n",
      "::::", "\n"
    )),
    stop("Invalid `type`", call. = FALSE)
  )
}
# dark mode plots ----
# Chunks that build a ggplot render twice: the original plot (light) and a
# terminal styled copy (dark). Quarto's `renderings` shows the one that
# matches the reader's color scheme.
theme_fm_dark <- function() {
  ggplot2::theme(
    plot.background   = ggplot2::element_rect(fill = "#000000", colour = NA),
    panel.background  = ggplot2::element_rect(fill = "#000000", colour = NA),
    legend.background = ggplot2::element_rect(fill = "#000000", colour = NA),
    legend.key        = ggplot2::element_rect(fill = "#000000", colour = NA),
    strip.background  = ggplot2::element_rect(fill = "#0d0d0d", colour = NA),
    panel.grid.major  = ggplot2::element_line(colour = "#2b2b2b"),
    panel.grid.minor  = ggplot2::element_line(colour = "#1a1a1a"),
    text              = ggplot2::element_text(colour = "#e2dccf"),
    axis.text         = ggplot2::element_text(colour = "#9a9488"),
    plot.title        = ggplot2::element_text(colour = "#ffa028"),
    strip.text        = ggplot2::element_text(colour = "#ffa028"),
    geom              = ggplot2::element_geom(ink = "#e2dccf", paper = "#000000")
  )
}

fm_dark <- function(p) {
  dark_ink <- c("#1C1C1E", "#1c1c1e", "black", "#000000")
  for (i in seq_along(p$layers)) {
    lyr <- p$layers[[i]]
    is_text <- inherits(lyr$geom, c("GeomText", "GeomLabel"))
    if (!is_text && isTRUE(lyr$aes_params$colour %in% dark_ink)) {
      lyr <- structure(rlang::env_clone(lyr), class = class(lyr))
      lyr$aes_params$colour <- "#9a9488"
      p$layers[[i]] <- lyr
    }
  }
  p + theme_fm_dark()
}

registerS3method(
  "knit_print", "ggplot",
  function(x, options, ...) {
    print(x)
    if (!is.null(options$renderings)) print(fm_dark(x))
    invisible()
  },
  envir = asNamespace("knitr")
)

knitr::opts_chunk$set(dark_plots = TRUE)
knitr::opts_hooks$set(dark_plots = function(options) {
  if (isTRUE(options$dark_plots) && is.null(options$renderings) &&
      any(grepl("ggplot(", options$code, fixed = TRUE))) {
    options$renderings <- c("light", "dark")
    options$fig.show <- "hold"
  }
  options
})
