#!/usr/bin/env Rscript

source('first_steps.R')

# -----------------------------------------------------------
# Regular expressions for ending up with just the Arabic text
# -----------------------------------------------------------

text.single_cleaned_string.v <- gsub(
  # Second, collapse all occurances of multiple
  # spaces into a single space each.
  '[ ]{2,}', ' ', 
  gsub(
    # First, remove everything that is not a space 
    # or an Arabic character or that is an opening
    # or closing perenthesis
    '[^( \\p{Arabic})]|[()]', '', 
    text.single_string.v, perl = TRUE
  ), perl = TRUE
)

# Output what we have
# message(paste('text.single_cleaned_string.v:', text.single_cleaned_string.v))