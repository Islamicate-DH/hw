#!/usr/bin/env Rscript
# Only runs on R >= 3.3.1!
# Requires: install.packages(c('urltools', 'rvest', 'XML', 'magrittr', 'stringr', 'optparse'))
# Remember: every line of code one liability!

for (lib in c('urltools', 'curl', 'rvest', 'stringr', 'optparse', 'tools', 'methods')) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE))
}

default_url = 'http://www.altafsir.com/Tafasir.asp?tMadhNo=0&tTafsirNo=0&tSoraNo=1&tAyahNo=1&tDisplay=yes&LanguageID=1'
parameters  = param_get(default_url, c('tMadhNo', 'tTafsirNo', 'tSoraNo', 'tAyahNo'))
save_path   = file.path('..', '..', 'corpora', 'altafsir_com', 'downloaded')

# Dropdown boxes 1 and 3
number_of_madahib = 10
number_of_suwar  = 114
# Dropdown boxes 2 and 4,
# thank you Christoph!
number_of_tafaseer_per_madhab = c(8, 20, 10, 2, 7, 7, 4, 3, 5, 2) 
number_of_aayaat_per_sura     = c(7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99, 128, 111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30, 73, 54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29, 18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12, 12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, 22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6)

download_all <- function(url, path, start_pos=c(1,1,1,1), stop_pos=c(0,0,0,0))
{
  pos_set = FALSE
  t0 = proc.time()
  # The mother of all nested loops. Makes Ross' and Robert's hearts cringe,
  # but works. It would be more R-ish to use expand.grid on the `parameters'
  # data grid, unfortunately urltools does not seem to provide the necessary 
  # functions to do so.
  # ~~~
  # Major thanks to Franziska for all the sweets that made this possible!
  # Still haven't finished all the Knoppers!
  for (madhab in 1:number_of_madahib) {
    if (!pos_set && madhab < start_pos[1]) {next}
    for (tafsir in 1:number_of_tafaseer_per_madhab[madhab]) {
      if (!pos_set && tafsir < start_pos[2]) {next}
      for (sura in 1:number_of_suwar) {
        if (!pos_set && sura < start_pos[3]) {next}
        for (aaya in 1:number_of_aayaat_per_sura[sura]) {
          if (!pos_set) {if (aaya < start_pos[4]) {next} else {pos_set = TRUE}}
          delim = rep('–', 115)
          message(
            c("\033[2J","\033[0;0H"), delim, '\n Working…\n', delim,
            sprintf('\n Madhab:\t%s/%s | ', madhab, number_of_madahib),
            sprintf('Tafsir:\t%s/%s | ',     tafsir, number_of_tafaseer_per_madhab[madhab]),
            sprintf('Sura:\t%s/%s | ',       sura,   number_of_suwar),
            sprintf('Aaya:\t%s/%s | ',       aaya,   number_of_aayaat_per_sura[sura]),
            sprintf('Time elapsed:\t%.0f min\n', (proc.time() - t0)[3] / 60),
            delim, '\n', url)          
          download(url, path, sura, aaya, madhab, tafsir)
          # If this happens, we've hit the point where we're supposed to stop.
          if (identical(c(madhab,tafsir,sura,aaya), stop_pos)) {stop_execution()}
          sleep(0.1) # Sleep a little so we're not seen as a threat.
        }
      } 
    } 
  }
}

# Taken from http://stackoverflow.com/questions/17837289/break-exit-script
# I completely agree with the name of this function in any circumstance!
stop_execution <- function()
{
  cat("Reached end of requested range, stopping.")	
	pid = Sys.getpid() 
	pskill(pid, SIGINT)
	Sys.sleep(1)
}

# Taken from https://stat.ethz.ch/R-manual/R-devel/library/base/html/Sys.sleep.html
# Pretty much what has been lacking these last days...
sleep <- function(s)
{
  t0 = proc.time()
  Sys.sleep(s)
  proc.time() - t0
}

download <- function(url, root, sura, aaya, madhab, tafsir)
{
  url = param_set(url, 'tMadhNo',   madhab)
  url = param_set(url, 'tSoraNo',   sura)
  url = param_set(url, 'tTafsirNo', tafsir)
  url = param_set(url, 'tAyahNo',   aaya)
  # This is where we start 
  page = 1     
  no_pages = 1 # Might not be true, but we're assuming it for now
  # Will succeed at least once
  while (page <= no_pages) {
    path = file.path(root,
                     sprintf('quran_%03d', sura),
                     sprintf('aaya_%03d', aaya),
                     sprintf('madhab_%02d', madhab),
                     sprintf('tafsir_%02d', tafsir)) # Logical order
    file = file.path(path, sprintf('page_%02d.html', page))
    # The actual downloading and writing of the file,
    # unless it exists. Note that in that case it'll
    # be read from disk to figure out if there are
    # additional pages.
    if (!file.exists(file)) {
      url = param_set(url, 'Page', page)
      response = curl_fetch_memory(url)
      contents = iconv(rawToChar(response$content), from='CP1256', to='UTF-8')
      dir.create(path, showWarnings = FALSE, recursive = TRUE)
      write(contents, file)
      message(sprintf('\tSaved page %s to %s', page, file))
    }
    # Now let's find out the actual truth!
    if (page == 1 && file.info(file)$size > 0) {
      no_pages = extract_number_of_pages(read_html(file))}
    # Whatever it is, the show must go on...
    page = page + 1
  }
  # Position marker so we can pick up where we left off
  file = file.path(root, 'scraper_pos.dat')
  pos  = sprintf('%s,%s,%s,%s', madhab, tafsir, sura, aaya) # Website's order
  write(pos, file)
}

extract_number_of_pages <- function(raw_html)
{
  n <- raw_html %>%
    html_nodes('#DispFrame center u') %>%
    html_text() %>%
    as.numeric()
  # This is tricky in R: a NULL or NA value could result!
  if (length(n) < 1) {
    n = 1
  } else {
    n = n[length(n)]
  }
  message('\tNumber of pages: ', n)
  return(n)
}

# Figure stuff out...
option_list = list(
  make_option(
    c('-b', '--start'), 
    action='store', default=NA, type='character',
    help='Where to start downloading: madhab,tafsir,sura,aaya'),
  make_option(
    c('-e', '--stop'),
    action='store', default=NA, type='character',
    help='Where to stop downloading: madhab,tafsir,sura,aaya'
  )
); o = parse_args(OptionParser(option_list=option_list))

# Let's rock'n'roll!
if (!is.na(o$start) && !is.na(o$stop)) {
  # Assume we're one of many processes and only download what we're told
  start_pos = strtoi(unlist(strsplit(o$start, split=',')))
  stop_pos  = strtoi(unlist(strsplit(o$stop, split=',')))
  download_all(default_url, save_path, start_pos, stop_pos)
} else {
  # Assume we're just one process and it's our job to do it all
  file = file.path(save_path, 'scraper_pos.dat')
  if (file.exists(file)) {
    pos = unlist(read.csv(file, header=FALSE))
    download_all(default_url, save_path, pos)
  } else {
    download_all(default_url, save_path)
  }
}
