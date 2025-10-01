context("dominance analysis plots")

lm.attitude<-lm(rating~complaints+privileges+learning+raises+critical+advance,attitude)
da.attitude<-dominanceAnalysis(lm.attitude)

test_that("raise error on incorrect graph type", {
  expect_error(plot(da.attitude, which.graph='wrong'),"which.graph should be")
})

test_that("raise error on incorrect fit function", {
  expect_error(plot(da.attitude, fit.function='wrong'),"fit.function should be")

})

test_that("complete graph should be a ggplot object", {
  p1<-plot(da.attitude)
  expect_true(ggplot2::is_ggplot(p1))
})

test_that("complete graph without facetshould be a ggplot object", {
  p1<-plot(da.attitude,which.graph = "complete_no_facet")
  expect_true(ggplot2::is_ggplot(p1))
})

test_that("conditional graph without facetshould be a ggplot object", {
  p1<-plot(da.attitude,which.graph = "conditional")
  expect_true(ggplot2::is_ggplot(p1))
})

test_that("general graph without facetshould be a ggplot object", {
  p1<-plot(da.attitude,which.graph = "general")
  expect_true(ggplot2::is_ggplot(p1))
})
