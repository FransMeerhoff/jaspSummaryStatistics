context("Summary Stats Binomial Test Bayesian")

test_that("Main table results match", {
  options <- jaspTools::analysisOptions("SummaryStatsBinomialTestBayesian")
  
  options$successes                           <- 58
  options$failures                            <- 42
  options$betaPriorParamA                     <- 4
  options$betaPriorParamB                     <- 2
  options$testValue                           <- "0.2"
  options$bayesFactorType                     <- "BF01"
  options$plotPriorAndPosterior               <- FALSE
  options$plotPriorAndPosteriorAdditionalInfo <- FALSE
  
  results <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  table   <- results[["results"]][["binomialContainer"]][["collection"]][["binomialContainer_bayesianBinomialTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(4.32337507642424e-15, 42, 8.41375589059492e-17, 58, 0.2)
  )
})

test_that("Prior posterior plots match", {
  options <- jaspTools::analysisOptions("SummaryStatsBinomialTestBayesian")
  # without additional information
  options$testValue                           <- "0.5"
  options$successes                           <- 58
  options$failures                            <- 42
  options$plotPriorAndPosterior               <- TRUE
  options$plotPriorAndPosteriorAdditionalInfo <- FALSE
  results  <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-posterior-1", dir="SummaryStatsBinomialTestBayesian")
  
  options$successes                           <- 42
  options$failures                            <- 58
  results  <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-posterior-2", dir="SummaryStatsBinomialTestBayesian")
  
  # with additional information
  options$plotPriorAndPosterior               <- TRUE
  options$plotPriorAndPosteriorAdditionalInfo <- TRUE
  results  <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-posterior-3", dir="SummaryStatsBinomialTestBayesian")
  
  options$successes                           <- 58
  options$failures                            <- 42
  results  <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-posterior-4", dir="SummaryStatsBinomialTestBayesian")
})

test_that("Error message is validation", {
  options <- jaspTools::analysisOptions("SummaryStatsBinomialTestBayesian")
  
  options$successes                           <- 10
  options$failures                            <- 0
  options$betaPriorParamA                     <- 0.001
  options$betaPriorParamB                     <- 9999
  options$testValue                           <- "0.5"
  options$hypothesis                          <- "greaterThanTestValue"
  options$plotPriorAndPosterior               <- TRUE
  options$plotPriorAndPosteriorAdditionalInfo <- TRUE
  
  results <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  error   <- results[["results"]][["binomialContainer"]][["collection"]][["binomialContainer_priorPosteriorPlot"]][["error"]][["type"]]
  expect_identical(error, "badData")
})
