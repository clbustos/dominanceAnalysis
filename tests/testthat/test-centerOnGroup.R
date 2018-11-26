context("Center on Group")

test_that("centerOnGroup should return correct values", {
  d.f<-data.frame(g=gl(3,3),x.1=rnorm(9))
  x.means<-aggregate(data.frame(x.1.mean=d.f$x.1),list(g=d.f$g),mean)
  d.f.2<-merge(d.f,x.means)
  centered<-d.f$x.1-d.f.2$x.1.mean
  cof<-centerOnGroup(data.frame(x=d.f$x.1),d.f$g)
  expect_equal(cof$mean.x, expected=d.f.2$x.1.mean)
  expect_equal(cof$centered.x, expected=centered)

})