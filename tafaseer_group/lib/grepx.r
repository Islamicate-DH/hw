# Thankfully stolen from https://www.r-bloggers.com/regex-named-capture-in-r-round-2/,
# thank you, dear Lee Pang!

grepx = function(pattern, x, ...)
{
  args = list(...)
  args[['perl']] = T

  re = do.call(gregexpr, c(list(pattern, x), args))

  mapply(function(re, x){

    cap = sapply(attr(re, 'capture.names'), function(n, re, x){
      start = attr(re, 'capture.start')[, n]
      len   = attr(re, 'capture.length')[, n]
      end   = start + len - 1
      tok   = substr(rep(x, length(start)), start, end)

      return(tok)
    }, re, x, simplify=F, USE.NAMES=T)

    return(cap)
  }, re, x, SIMPLIFY=F)
}
