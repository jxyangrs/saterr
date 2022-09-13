'''
Modules for date range
    month_dateend
    range_dates

@author: John Yang, jxyang@umd.edu, 04/17/2020, original code
         John Yang, jxyang@umd.edu, 05/30/2021, flexible input
         John Yang, jxyang@umd.edu, 10/09/2021, CDS and MARS
'''

# =============================================================================
# Beginning and ending of months
#
# Input:
#       month_begin,    beginning month (yyyymm)    
#       month_end,      ending month (yyyymm)    
#
# Output:
#       month_begin,    e.g. ['20190101','20190201']
#       month_end,      e.g. ['20190131','20190228']
#
# History:
#       John Xun Yang, jxyang@umd.edu, 05/03/2021, original code
#       John Xun Yang, jxyang@umd.edu, 10/08/2021, yyymmdd
# =============================================================================
def month_dateend(month_begin,month_end):

    import datetime
    import numpy as np
    
    date_begin = datetime.datetime.strptime(month_begin,'%Y%m')
    date_end = datetime.datetime.strptime(month_end,'%Y%m')
    
    if date_begin>date_end:
        print('error of month_begin > month_end')
        return
    
    # month range
    ind1 = date_begin.month
    ind2 = date_end.month
    
    year = np.arange(date_begin.year,date_end.year+1,1)
    month = np.arange(1,12+1,1)
    
    month_begin = list()
    month_end = list()
    
    for iy in year:
        for im in month:
            idate = datetime.datetime(iy,im,1)
            
            t = datetime.datetime.toordinal(idate)
            idate_vec = datetime.datetime.fromordinal(t)
            idate_str = datetime.datetime.strftime(idate_vec, '%Y%m%d')
            month_begin.append(idate_str)
            
            t = t-1
            idate_vec = datetime.datetime.fromordinal(t)
            idate_str = datetime.datetime.strftime(idate_vec, '%Y%m%d')
            month_end.append(idate_str)
    
    if date_begin==date_end:
        month_begin1 = list()
        month_end1 = list()
        month_begin1.append(month_begin[ind1-1])
        month_end1.append(month_end[ind2])
        month_begin = month_begin1
        month_end = month_end1
    elif date_begin<date_end:
        month_begin = month_begin[ind1-1:len(month_begin)-(12-ind2)]
        month_end = month_end[ind1:len(month_end)-(12-ind2-1)]    
    
    return month_begin,month_end


# =============================================================================
# Dates raning from beginning and ending dates
# date_begin<= time <= date_end
#
# Input:
#       date_begin,     beginning date (yyyymmdd)    
#       date_end,       ending date (yyyymmdd)    
#
# Output:
#       rdates,    
#       
# Examples:
#       rdates = range_dates('20190101','20190103')
#
# History:
#       John Xun Yang, jxyang@umd.edu, 05/03/2021, original code
# =============================================================================
def range_dates(date_begin,date_end):

    import datetime
    
    dt1 = datetime.datetime.strptime(date_begin,'%Y%m%d')
    dt2 = datetime.datetime.strptime(date_end,'%Y%m%d')
    
    idate = dt1
    step = datetime.timedelta(days=1)
    rdates = list()
    while idate <= dt2:
        rdates.append(datetime.datetime.strftime(idate,'%Y%m%d'))
        idate = idate+step
    
    return rdates
