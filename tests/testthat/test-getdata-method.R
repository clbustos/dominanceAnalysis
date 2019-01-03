context("test-getdata-method")
library(lme4)
my_data="my data"

test_that("glm with data in x$data", {
  x<-list(data=my_data)
  class(x)<-"glm"
  expect_equal(getData(x),my_data)
})

test_that("glm with data in x$model", {
  x<-list(model=my_data)
  class(x)<-"glm"
  expect_equal(getData(x),my_data)
})


test_that("lm with data extrated from call",{
  x1<-rnorm(10)
  x2<-rnorm(10)
  y<-x1+x2+rnorm(10)
  .dff<<-data.frame(xa=x1,xb=x2,yy=y)
  lm.1<-lm(yy~xa+xb, data=.dff)
  #print(getData(lm.1))
  #print(.dff)
  expect_equal(getData(lm.1),.dff)
  .dff<<-NULL
})


test_that("lmer with data extrated from call",{
  x1<-rnorm(10)
  x2<-rnorm(10)
  g<-gl(5,2)
  y<-x1+x2+rnorm(10)
  dff<-data.frame(xa=x1,xb=x2,yy=y,g=g)
  lmer.1<-lmer(yy~xa+xb+(1|g), data=dff)
  #print(getData(lm.1))
  #print(.dff)
  expect_equal(getData(lmer.1)[,colnames(dff)],dff)
})

test_that("lm with data extrated from model",{
  x<-list(model=my_data)
  class(x)<-"lm"
  expect_equal(getData(x),my_data)
})

test_that("lm without data should raise error",{
  x<-list()
  class(x)<-"lm"
  expect_error(getData(x),"Can't get data")
})
