context("replaceTermsInString() method")

terms.r<-c(group.1="x1+x2", group.2="x3+x4", group.3="x5+x6")
test_that("should return the same string for NULL replacement", {
  expect_equal(replaceTermsInString("x1+x2+x3+x4", replacement = NULL), "x1+x2+x3+x4")
})

test_that("should return the same string for unnamed replacement", {
  expect_equal(replaceTermsInString("x1+x2+x3+x4", replacement = c("x1","x2")), "x1+x2+x3+x4")
})

test_that("should return replacement according to names", {
  expect_equal(replaceTermsInString("x1+x2+x3+x4+x5+x6", replacement = terms.r), "group.1+group.2+group.3")
})

test_that("should return partial replacement according to names", {
  expect_equal(replaceTermsInString("x1+x2+x3+x4+x5+x6", replacement = terms.r[1:2]), "group.1+group.2+x5+x6")
  expect_equal(replaceTermsInString("x1+x2+x3+x4+x5+x6", replacement = c(group.1="x1+x2", group.2="x3+x4", "x5+x6")), "group.1+group.2+x5+x6")
})
