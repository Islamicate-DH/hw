#!/usr/bin/env Rscript

library(data.table)

args = commandArgs(trailingOnly = TRUE)
csv = fread(args[1])
saveRDS(csv, args[2])
