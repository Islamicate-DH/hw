#!/usr/bin/env Rscript

library(data.table)
csv = fread('stopwords.csv')
saveRDS(csv, 'stopwords.rds')
