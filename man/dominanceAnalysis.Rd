\name{dominanceAnalysis}
\alias{dominanceAnalysis}
\title{Dominance Analysis
Based on Azen and Bodescu(1993) and all their derivations}
\usage{
  dominanceAnalysis(x, constants = c(),
    fit.functions = "default", data = NULL,
    null.model = NULL, ...)
}
\arguments{
  \item{x}{lm, glm or another regression based linear
  model}

  \item{constants}{variables to remain unchanged between
  models}

  \item{fit.functions}{list of functions which provides fit
  indexes for model.}

  \item{data}{optional data.frame to which fit the
  formulas}

  \item{null.model}{for mixel models, null model against to
  test the submodels}

  \item{...}{Other arguments provided to lm or lmer (not
  implemented yet)}
}
\value{
  dominanceAnalysis object
}
\description{
  Dominance Analysis Based on Azen and Bodescu(1993) and
  all their derivations
}

