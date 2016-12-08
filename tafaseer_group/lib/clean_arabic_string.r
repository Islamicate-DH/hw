# Crude but effective by way of Unicode regex group
clean_arabic_string = function(string) {
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
        string, perl = TRUE
      ), perl = TRUE
    )
  )
}
