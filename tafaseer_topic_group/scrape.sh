#!/bin/bash
RET=1; while [ "$RET" -eq 1 ]; do RET=$(Rscript altafsir_com_scraper.R); done
