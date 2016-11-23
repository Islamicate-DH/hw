
import datetime

import os, sys

"""
    With this function I generate a file with all the necessary paths, which we need to download every day
    startin from the 1st Jan 2011 till now. We should set a date for now, too. 
"""
def getDayLinks():

##    base = datetime.date(2010, 1, 1)
##    date_list = [base + datetime.timedelta(days=x) for x in range(0, timespan)]
##    urls = '';
    f=open('urls_2014.txt','w')
        
    firstarticle=408662
    lastarticle=449275
    
    for day in range(firstarticle, lastarticle):
            urls = 'http://today.almasryalyoum.com/article2.aspx?ArticleID='+str(day)+'\n'
            f.write(urls)
    f.close

timespan= 365*1
getDayLinks()

"""
    Create Directories
    I actually don't need that.
"""
##for day in range(0,timespan):
##    os.makedirs( date_list[day].strftime('%Y/%-m/%-d') )


#http://today.almasryalyoum.com/article2.aspx?ArticleID=238700


