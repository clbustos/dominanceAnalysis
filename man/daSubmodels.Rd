\name{daSubmodels}
\alias{daSubmodels}
\title{Returns all the submodels derived from full models.
You could set some variables as constantes, limiting the number of models.
Includes, by default, the null model}
\usage{
  daSubmodels(x, constants = NULL)
}
\arguments{
  \item{x}{regression class (lm or lmer)}

  \item{constants}{vector of constants}
}
\value{
  list level, pred.matrix, predictors, response, constants
}
\description{
  Returns all the submodels derived from full models. You
  could set some variables as constantes, limiting the
  number of models. Includes, by default, the null model
}

