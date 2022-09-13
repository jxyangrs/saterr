#!/usr/bin/env python

"""
Dowloading ERA5 data from ECMWF
    sources are CDS or MARS
    CDS has 37-pressure-level or single-level
    MARS has 137-model level (MARS's surface is identical to CDS single-level)
    CDS downloading is fast, while MARS is slow

Examples:
    date_begin = '20140101' # beginning day
    date_end = '20140201' # ending day
    var_names = ['tp','skt','sst'] 
    data_source = 'CDS' 
    data_level = 'sl' 
    running the code: python main_era5.py
    
@author: John Xun Yang, jxyang@umd.edu, or johnxun@umich.edu, 04/17/2020, original code
         John Xun Yang, jxyang@umd.edu, or johnxun@umich.edu, 05/30/2021, flexible input
         John Xun Yang, jxyang@umd.edu, or johnxun@umich.edu, 10/10/2021, CDS & MARS
"""

from mod_era5_dn import era5_ec_dn

# =============================================================================
# setting
# =============================================================================

# date range and variables
# date_begin<= date <date_end
date_begin = '20140101' # beginning day
date_end = '20140201' # ending day
var_names = ['tp'] # short name per ECMWF convention; refer to era5_var_list['short_name']; https://apps.ecmwf.int/codes/grib/param-db

# CDS/MARS
#   CDS:    pl(37-level) and sl; fast
#   MARS:   ml(137-level); slow
#   ml/pl/sl = model-level/pressure-level/single-level
data_source = 'CDS' 
data_level = 'sl'


# =============================================================================
# downloading
# =============================================================================
era5_ec_dn(date_begin,date_end,var_names,data_source,data_level)






