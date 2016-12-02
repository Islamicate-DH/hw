###############################################################################
###############################################################################
##                              SCRAPE-FUNCTIONS
###############################################################################
###############################################################################


###############################################################################
##                              HESPRESS
###############################################################################
scrape.index.hespress <- function(day.links, target.folder) {
  # Scrape all articles which are linked on the current index-page
  # of the day.
  #
  # Called by: scrape.day.hespress
  # Args:
  #   day.links: A list of links to index pages.
  #   target.folder: A character string to set the target folder.
  for (link in day.links) {
    file <- paste(target.folder, gsub("/", "_", link), sep = "")
    ## if the file is already downloaded, skip it.
    if (!file.exists(file)) {
      tryCatch({
        article.homepage <- read_html(curl(
            paste("http://www.hespress.com", link, sep = ""),
            handle = curl::new_handle("useragent" = "Mozilla/5.0")
          ), encoding = "UTF-8")
        write_xml(article.homepage, file)
        sleep(0.1)
      } , error = function(e) {
        write(link,
              paste(target.folder, "missed.log", sep = ""),
              append = TRUE)
      })  # end of tryCatch
    }  # end of if file.exists
  }  # end of for-loop
}  # end of scrape.index.hespress

scrape.day.hespress <- function(hespress.url, target.folder) {
  # Navigate to all top level index pages which have links to articles.
  # The algorithm stops when all of the index pages have been checked.
  # The actual scraping is done in scrape.index.hespress
  #
  # Args:
  #   hespress.url: Link to the first index-page of the day.
  #   target.folder: A character string to set the target folder.
  
  ## while there is still another index-page for the current day continue scraping.
  while (length(grep("index", hespress.url)) > 0) {
    tryCatch({
      homepage <- read_html(hespress.url)
      day.links <- homepage %>% html_nodes("h2.section_title a") %>% html_attr("href")
      ## Each index page has several articles which are to be saved.
      scrape.index(day.links, target.folder)
      # go to next index ('increment index')
      hespress.url <- homepage %>% html_node("span.page_active+a") %>% html_attr("href")
    }, error = function(e) {
      write(hespress.url,
            paste(target.folder, "missed.log", sep = ""),
            append = TRUE)
    })  # end of tryCatch
  }  # end of while-loop
}  # end of scrape.day.hespress


###############################################################################
##                              THAWRA
###############################################################################
scrape.article.thawra <- function(article.homepage, target.folder) {
  # Scrapes an article of the Thawra-Homepage and saves it as html.
  #
  # Called by: scrape.day.thawra
  # Args:
  #   article.homepage: Link to one specific article.
  #   target.folder: A character string to set the target folder.
  
  my.filename <- paste(target.folder, "/",
          gsub("/", "_", article.homepage),
          ".html", sep = "")
  if (!file.exists(my.filename)) {
    tryCatch({
      homepage.day.article <- read_html(article.homepage, encoding = "Windows-1256")
      write_xml(homepage.day.article, my.filename)
      sleep(0.1)
    } , error = function(e) {
      write(article.homepage,
            paste(target.folder, 'log', sep = ""),
            append = TRUE)
    })  # end of tryCatch
  } else {
    print(paste("skip", article.homepage, 
                "because i have it already.", sep = " "))
  } # end of file.exists
}  # end of scrape.article.thawra

scrape.day.thawra <- function(day.homepage.url, target.folder) {
  # Navigate to the main page and collect all links. In the following,
  # the relative links are processed, to load them directly with html_read.
  # This is done in scrape.article.thawra
  #
  # Args:
  #   day.homepage.url:
  #   target.folder: A character string to set the target folder.
  ### TODO base.url?
  
  # Precondition: The dates are generated with a simple python-skript:
  # It generates a sequence of 'pseudo-dates'. Each day has a number but
  # not a day.
  
  homepage <- read_html(day.homepage.url, encoding = "Windows-1256") ## charset!
  # get links and prepend base.url
  homepages.to.scrape <- homepage %>%  html_nodes("p a")  %>% html_attr("href")
  homepages.day.v <- sapply(
    base.url, paste, homepages.to.scrape[grep("archive", homepages.to.scrape)], sep = ""
    )
  sleep(0.1)
  sapply(homepages.day.v, scrape.article.thawra, target.folder)
} # end of scrape.day.thawra-function

###############################################################################
##                              AHRAM
###############################################################################
scrape.day.ahram <- function(day.to.observe, target.folder) {
  # Navigates to all article-pages of one day and saves them as
  # HTML in a target-folder.
  #
  # Called by: scrape_session.sh
  #            The bash-script uses tmux to paralellize the scraping.
  # Args:
  #   day.to.observe: A string with day date which is to be scraped.
  #   target.folder: A character string to set the target folder.
  base.ahram.url <- "http://www.ahram.org.eg/archive/"
  # articles are saved one stage down.
  ahram.url <- "http://www.ahram.org.eg/archive/news/"
  
  ahram.day.url <- paste(ahram.url, day.to.observe, "/index.aspx", sep = "")
  homepages.rel.v <- getLinks(ahram.day.url, "a")
  # also prepends http
  homepages.v <- filter_homepages.ahram(homepages.rel.v)
  # articles have this format
  homepages.v <- homepages.v[grep("*[0-9].aspx$", homepages.v)]
  homepages.names.v <- gsub("/", "_", homepages.v)
  for (i in 1:length(homepages.v)) {
    # to avoid the duplicate issue the files are saved with complete url.
    my.filename <- paste(target.folder, gsub("/", "_", homepages.names.v[i]), sep = "/")
    if (!file.exists(my.filename)) {
      tryCatch({
        ahram.homepage <- read_html(homepages.v[i], encoding = "UTF-8")
        write_xml(ahram.homepage, my.filename)
        sleep(0.1)
      } , error = function(e) {
        write(homepages.v[i],
              paste(target.folder, 'log', sep = ""),
              append = TRUE)
      })  # end of tryCatch
    } else {
      print(paste("skip", homepages.v[i], "because i have it already.", sep =
                    " "))
    }# end of file.exists
  }# end of for-loop
} # end of scrape.day.ahram

scrape.article.alwatan <- function(homepage.url.article, target.folder) {
    # Scrape specific article from Alwatan homepage. The links are generated by a
    # Python script.
    #
    # Args:
    #   homepage.url.article: A direct link to an article
    #   target.folder: A character string to set the target folder.
    my.filename <- paste(target.folder, "/",
            gsub("/", "_", homepage.url.article),
            ".html", sep = "")
    
    if (!file.exists(my.filename)) {
      tryCatch({
        homepage.day.article <-
          read_html(homepage.url.article, encoding = "UTF-8")
        write_xml(homepage.day.article, my.filename)
        sleep(0.1)
      } , error = function(e) {
        write(homepage.url.article,
              paste(target.folder, 'log', sep = ""),
              append = TRUE)
      })  # end of tryCatch
    } else {
      print(paste("skip", homepage.url.article,
        "because i have it already.", sep = " ")
        )  # end of tryCatch
    }  # end of file.exists
  }  # end of scrape.article.alwatan

filter_homepages.ahram<-function(homepages.v) {
  # Filtering twitter, fb etc lateron.
  #
  # Called by: scrape.day.ahram
  # Args:
  #   homepages.v: Vector with direct and relative links
  #   to articles.
  ahram.url<-"http://www.ahram.org.eg/archive/news/" # articles are saved one stage down. 
  result<-c(
    # pages are saved as relative links.
    sapply(ahram.url,paste,
           homepages.v[grep('http|RssContent|javascript',homepages.v,invert = TRUE)], sep=""),
    # selects all subpages of ahram which are not links of archive
    homepages.v[intersect(grep('http://',homepages.v),
                          grep('ahram',homepages.v)  )]
  )  # end of c()
  return(result)
}  # end of filter_homepages.ahram

getLinks <- function(homepage.url, link.element) {
  # Getting links of a index-homepage, which are located in a
  # specific HTML-element. 
  #
  # Called by: several top-level scraping functions
  # Args:
  #   homepage.url: Index-URL which is to be scraped.
  #   link.element: HTML-element which holds the links.
  homepage <- read_html(homepage.url)
  link.element.v <- homepage %>%
    html_nodes(link.element) %>% html_attr("href")
  homepages.v <- unlist(link.element.v)
  homepages.v <- homepages.v[homepages.v != ""]  # to make sure there aren't any empty elements.
  return(homepages.v)
}  # end of getLinks