context("rankUsingMatrix methods: Rank values using matrix")

test_that("show complete dominance", {
  c.names<-c("A","B","C","D")
  dom.matrix<-matrix(c(0.5,  1,  1,  1,
                       0  ,0.5,  1,  1,
                       0  ,  0,0.5,  1,
                       0  ,  0, 0 , 0.5),4,4,byrow = T,dimnames = list(c.names,c.names))

  expect_equal(rankUsingMatrix(dom.matrix), c(A="B,C,D", B="C,D", C="D",D=""))

})

test_that("show partial dominance", {
  c.names<-c("A","B","C","D")
  dom.matrix<-matrix(c(0.5,  1,  1,  0.5,
                       0  ,0.5,  1,  1,
                       0  ,  0,0.5,  1,
                       0.5  ,  0, 0 , 0.5),4,4,byrow = T,dimnames = list(c.names,c.names))

  expect_equal(rankUsingMatrix(dom.matrix), c(A="B,C", B="C,D", C="D",D=""))

})

test_that("raise an error if is not a square matrix",{
  c.names<-c("A","B","C","D")
  dom.matrix<-matrix(c(0.5,  1,  1,  0.5,
                       0  ,0.5,  1,  1,
                       0  ,  0,0.5,  1),3,4,byrow = T,dimnames = list(c.names[1:3],c.names))

  expect_error(rankUsingMatrix(dom.matrix), "Not symmetric matrix" )
})