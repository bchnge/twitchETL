test_that("getTopGameIDs", {
  testthat::expect_gt(dim(getTopGameIDs('uxu7v5stx0s1hhqt0220nmgbaidstq', 5))[1],0)
})
