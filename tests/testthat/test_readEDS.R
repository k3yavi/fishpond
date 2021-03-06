context("readEDS")
library(fishpond)
test_that("Reading in Alevin EDS format works", {

  dir <- system.file("extdata", package="tximportData")
  files <- file.path(dir,"alevin/neurons_900_v014/alevin/quants_mat.gz")
  file.exists(files)
  dir <- sub("/alevin$","",dirname(files))  
  barcode.file <- file.path(dir, "alevin/quants_mat_rows.txt")
  gene.file <- file.path(dir, "alevin/quants_mat_cols.txt")
  cell.names <- readLines(barcode.file)
  gene.names <- readLines(gene.file)
  num.cells <- length(cell.names)
  num.genes <- length(gene.names)
  mat <- readEDS(numOfGenes=num.genes, numOfOriginalCells=num.cells, countMatFilename=files)

  expect_equal(nrow(mat), num.genes)
  expect_equal(ncol(mat), num.cells)
  cts <- mat@x
  # max count is < 1 million for this dataset
  expect_lte(max(cts), 1e6)
  expect_gte(min(cts), 0)

})
