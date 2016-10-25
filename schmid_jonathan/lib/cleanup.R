# Simple but effective by way of Unicode regex group
cleanArabicString <- function(string) {
  return(
    gsub(
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
  )
)
