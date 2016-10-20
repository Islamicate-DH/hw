#!/usr/bin/env Rscript

# Relative to homework repo root.
dir  <- '../../corpus/up0600AH'
# The smallest file of the bunch. Should work on all Unices.
file <- file.path(dir, '0303Nasai.Tabaqat.JK000831-ara1')

# ------------------------------------------------------
# Code from Jockers, chapter 2 which I found interesting
# ------------------------------------------------------

message(paste('Opened', file))
text.v <- scan(file, what='character', sep='\n')

# It would actually be a little nicer to just look up the
# line manually, but okay, this is just an exercise, right?
start.v <- which(text.v == '# أخبرنا علي بن منير ثنا الحسن بن رشيق ثنا أبو عبد الرحمن أحمد بن شعيب')
end.v <- which(text.v == '~~على خير خلقه محمد وآله وأزواجه وأصحابه أجمعين برحمته وهو أرحم الراحمين')

start.metadata.v <- text.v[1:(start.v-1)]
end.metadata.v <- text.v[(end.v+1):length(text.v)]
metadata.v <- c(start.metadata.v, end.metadata.v)
text.lines.v <- text.v[start.v:end.v]
text.single_string.v <- paste(text.lines.v, collapse=' ')

# Output what we have
# message(paste('text.single_string.v:', text.single_string.v))
