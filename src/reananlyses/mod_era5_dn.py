"""
Modules for downloading ERA5 data
    era5_ec_dn
    era5_cds_sl_dn
    era5_cds_pl_dn
    era5_mars_ml_dn
    era5_var_list

@author: John Yang, jxyang@umd.edu, 04/17/2020, original code
         John Yang, jxyang@umd.edu, 05/30/2021, flexible input
         John Yang, jxyang@umd.edu, 10/09/2021, CDS and MARS
"""

# =============================================================================
# Downloading ERA5 data from ECMWF
#
# Input:
#       date_begin,     beginning date (string)    
#       date_end,       ending date (string)    
#       var_names,      a list of variable names (list)   
#       data_source,    data source (list),                 CDS/MARS
#       data_level,     data level (list),                  sl/pl/ml
#
# Output:
#       monthly or daily netcdf files, e.g.
#       'era5_sl_var_skt_mon201906.nc'
#
# History:
#       John Xun Yang, jxyang@umd.edu, 10/08/2021, original code
# =============================================================================
def era5_ec_dn(date_begin,date_end,var_names,data_source,data_level):
    var_list = era5_var_list()
    
    for ivar in var_names:
        temp = var_list['short_name']
        ind = temp.index(ivar)
        var_name = temp[ind]
        if data_source=='CDS':
            if data_level == 'sl':
                era5_cds_sl_dn(date_begin,date_end,var_name)
            elif data_level=='pl':
                era5_cds_pl_dn(date_begin,date_end,var_name)
        elif data_source=='MARS':
            if data_level=='ml':
                era5_mars_ml_dn(date_begin,date_end,var_name)
        else:
            print('data_source is wrong')
            return


# =============================================================================
# Downloading ERA5 single-level data from CDS (fast)
#
# Input:
#       date_begin,     beginning date (string)    
#       date_end,       ending date (string)    
#       var_name,       variable name (string)   
#
# Output:
#       monthly netcdf files, e.g.
#       'era5_sl_var_skt_mon201906.nc'
#
# History:
#       John Xun Yang, jxyang@umd.edu, 10/08/2021, original code
# =============================================================================
def era5_cds_sl_dn(date_begin,date_end,var_name):
    import cdsapi
    from mod_date import month_dateend,range_dates
    
    # -----------------------------------
    # date range
    # -----------------------------------
    # date range
    month_begin_date,month_end_date = month_dateend(date_begin[0:6],date_end[0:6])
    
    # -----------------------------------
    # downloading
    # -----------------------------------
    server = cdsapi.Client()
    
    for i in range(len(month_begin_date)):
        imonth_begin_date = month_begin_date[i]
        imonth_end_date = month_end_date[i]
        month_dates = range_dates(imonth_begin_date,imonth_end_date)
    
        data_source = 'reanalysis-era5-single-levels'
        data_spc = {
                    'variable': var_name,
                    'date': month_dates, # cds does not support syntax of date1/to/date2
                    'time': '00/to/23/by/1',
                    'product_type': 'reanalysis',
                    'format': 'netcdf'
                    }
            
        file_savename = 'era5_sl_var_'+var_name+'_mon'+imonth_begin_date[0:6]+'.nc'
        server.retrieve(data_source,
                        data_spc,
                        file_savename)
        print(file_savename)
                        

# =============================================================================
# Downloading ERA5 pressure-level from CDS subset (fast)
#   including total precipitaton
# Input:
#       date_begin,     beginning date (string)    
#       date_end,       ending date (string)    
#       var_name,       variable name (string)   
#
# Output:
#       daily netcdf file, e.g.
#       'era5_pl_var_q_date20190601.nc'
#
# History:
#       John Xun Yang, jxyang@umd.edu, 10/08/2021, original code
# =============================================================================
def era5_cds_pl_dn(date_begin,date_end,var_name):
    import cdsapi
    from mod_date import range_dates
    
    # -----------------------------------
    # date range
    # -----------------------------------
    dates = range_dates(date_begin,date_end)
    dates = dates[0:len(dates)-1]
    
    # -----------------------------------
    # downloading
    # -----------------------------------
    server = cdsapi.Client()
    
    for idate in dates:
        data_source = 'reanalysis-era5-pressure-levels'
        data_spc = {
                    'variable': var_name,
                    'pressure_level': '1/to/1000',
                    'date': idate,
                    'time': '00/to/23/by/1',
                    'product_type': 'reanalysis',
                    'format': 'netcdf'
                    }
            
        file_savename = 'era5_pl_var_'+var_name+'_date'+idate+'.nc'
        server.retrieve(data_source,
                        data_spc,
                        file_savename)
        print(file_savename)
                        

# =============================================================================
# Downloading ERA5 data from MARS (slow)
#   Some variables on MARS are not included on CDS
#
# Input:
#       date_begin,     beginning date (string)    
#       date_end,       ending date (string)    
#       var_name,       variable name (string)   
#           
# Output:
#       atmospheric variables at model-level-137, e.g.
#       'era5_ana_ml137_var_q_date20190601.nc'
#
# Reference:
#       https://apps.ecmwf.int/data-catalogues/era5/?class=ea  
#  
# History:
#       John Xun Yang, jxyang@umd.edu, 10/08/2021, original code
# =============================================================================
def era5_mars_ml_dn(date_begin,date_end,var_name):
    import cdsapi
    from mod_date import range_dates
    
    # -----------------------------------
    # date range
    # -----------------------------------
    dates = range_dates(date_begin,date_end)
    
    # -----------------------------------
    # downloading
    # -----------------------------------
    server = cdsapi.Client()
    
    for idate in dates:
        data_source = 'reanalysis-era5-complete'
        data_spc = {
                    'variable': var_name,
                    'levtype': 'ml',
                    'levelist': '1/to/137/by/1',
                    'date': idate,
                    'time': '00/to/23/by/1',
                    'grid': '0.25/0.25',
                    'class': 'ea',
                    'type': 'an',
                    'expver': '1',               
                    'format': 'netcdf'
                    }
            
        file_savename = 'era5_ana_ml137_var_'+var_name+'_date'+idate+'.nc'
        server.retrieve(data_source,
                        data_spc,
                        file_savename)
        print(file_savename)

# =============================================================================
# ERA5 variable list with names and ID
#       sl,     single level
#       atm,    atmosphere vertical profile (37/137)
#
# Reference:
#       https://apps.ecmwf.int/codes/grib/param-db    
#
# Output:
#       variable list
#           var_name_long,      full name
#           var_name_short,     short name
#           var_para_ID,        number ID
#           var_type,           sl/atm; single-level or atmosphere
#
# History:
#       John Xun Yang, jxyang@umd.edu, 10/08/2021, original code
# =============================================================================
def era5_var_list():
    var_name_long = ['surface_pressure','10m_u_component_of_wind','10m_v_component_of_wind','skin_temperature','sea_surface_temperature',
                     'temperature','specific_humidity',
                     'fraction_of_cloud_cover','specific_cloud_ice_water_content','specific_cloud_liquid_water_content','specific_rain_water_content','specific_snow_water_content',
                     'total_precipitation'
                     ]
    
    var_name_short = ['sp','10u','10v','skt','sst',
                      't','q',
                      'crwc','cswc','clwc','ciwc','cc',
                      'tp']
    
    var_para_ID = ['134','165','166','235','34',
              '130','133',
              '75','76','246','247','248',
              '228']
    
    var_type = ['sl','sl','sl','sl','sl',
                'atm','atm',
                'atm','atm','atm','atm','atm','atm',
                'sl']
    
    var_list = {
                'long_name': var_name_long,
                'short_name': var_name_short,
                'ID': var_para_ID,
                'type': var_type
                }
    return var_list
    
    
                 