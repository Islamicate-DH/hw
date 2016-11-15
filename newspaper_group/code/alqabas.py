##def getDayLinks(timespan):
##
##    urls = '';
##    f=open('urls.txt','w')
##
##
##    for day in range(14107, timespan):
##            urls ="http://thawra.sy/_archive2.asp?num=%d&cat=default"%day
##            #print(urls+"\n")
##            f.write(urls+"\n")
##    f.close
##
##
##
##    ## http://www.alayam.com/epaper/2010/10/1/PdfFileDownload?filename=01.pdf&id=7844
##
##    ## filenames werden hochgezaehlt, id bleibt bei ausgabe gleich
##    href="/PdfFileDownload?filename=01.pdf&id=10080"
##    ## seitenzahl differs
##    ## loop through pages and gen. links
##    ## kann auch einfach alles runterladen bis 50 pages


import urllib.request

def main():
    download_file("http://www.alayam.com/epaper/2015/08/29/PdfFileDownload?filename=01.pdf&id=7844")

def download_file(download_url):
    response = urllib.request.urlopen(download_url)
    file = open("document.pdf", 'wb')
    file.write(response.read())
    file.close()
    print("Completed")

if __name__ == "__main__":
    main()
