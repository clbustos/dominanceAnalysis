#' Distribution of a tropical native bird species inhabiting a small oceanic island.
#'
#' The dataset contains information about points distributed across a small oceanic island (Soares, 2017).
#' In each of these points, a 10-minute count was carried out to record the species presence
#' (assuming 1 if the species was present, or 0 if it was absent). The species'
#' presence/absence is the binary response variable (i.e., dependent variable).
#' Additionally, all sampled points were caracterized by multiple environmental variables.
#'
#' @format A data frame with 2398 rows and 8 variables:
#' \describe{
#' \item{ID}{Point identification}
#' \item{rem}{remoteness is an index that represents the difficulty of movement through the landscape, with the highest values corresponding to the most remote areas}
#' \item{land}{land use is an index that represents the land-use intensification, with the highest values corresponding to the more humanized areas (e.g., cities, agricultural areas, horticultures, oil-palm monocultures)}
#' \item{alt}{altitude is a continuous variable, with the highest values corresponding to the higher altitude areas}
#' \item{slo}{slope is a continuous variable, with the highest values corresponding to the steepest areas}
#' \item{rain}{rainfall is a continuous variable, with the highest values corresponding to the rainy wet areas}
#' \item{coast}{distance to the coast is the minimum linear distance between each point and the coast line, with the highest values corresponding to the points further away from the coastline}
#' \item{pres}{Species presence}
#' }
#' @source Soares, F.C., 2017. Modelling the distribution of Sao Tome bird species: Ecological determinants and conservation prioritization. Faculdade de Ciencias da Universidade de Lisboa.
"tropicbird"