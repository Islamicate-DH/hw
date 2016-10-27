#!/bin/bash
RET=1; while [ "$RET" -eq 1 ]; do RET=$(Rscript scrape_corpus.R); done
