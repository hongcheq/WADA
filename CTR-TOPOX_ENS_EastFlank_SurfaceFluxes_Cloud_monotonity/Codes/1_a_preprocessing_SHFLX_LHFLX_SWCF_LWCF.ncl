;Function: using NCO to preprocess CTR files, and TOPOTEST files.
;Date: 20180708
;Note: modified 20180712 for additional members in 1996 and 2001.
;Note: modified 20180725 for additional 90 members. Now total member = 180.
;Note: modified 20180930 for sim2
;

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;=========== TOPOTEST ========
;PCT = "TOPO00"
;PCT = "TOPO20"
;PCT = "TOPO40"
;PCT = "TOPO60"
PCT = "TOPO80"

in_dir = "/DFS-L/DATA/pritchard/hongcheq/NERSC_Cori_edison/SCRATCH/archive/F_AMIP_CAM5_WADA_"+PCT+"_"
;in_dir = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_TOPO_"
;out_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
out_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes_SHFLX_LHFLX_SWCF_LWCF/"+PCT+"/"

year1989_str = (/"1989-12-01","1989-12-11","1989-12-21","1989-12-31","1990-01-10","1990-01-20","1990-01-30","1990-02-09","1990-02-19"/)
year1990_str = (/"1990-12-01","1990-12-11","1990-12-21","1990-12-31","1991-01-10","1991-01-20","1991-01-30","1991-02-09","1991-02-19"/)
year1991_str = (/"1991-12-01","1991-12-11","1991-12-21","1991-12-31","1992-01-10","1992-01-20","1992-01-30","1992-02-09","1992-02-19"/)
year1992_str = (/"1992-12-01","1992-12-11","1992-12-21","1992-12-31","1993-01-10","1993-01-20","1993-01-30","1993-02-09","1993-02-19"/)
year1993_str = (/"1993-12-01","1993-12-11","1993-12-21","1993-12-31","1994-01-10","1994-01-20","1994-01-30","1994-02-09","1994-02-19"/)
year1994_str = (/"1994-12-01","1994-12-11","1994-12-21","1994-12-31","1995-01-10","1995-01-20","1995-01-30","1995-02-09","1995-02-19"/)
year1995_str = (/"1995-12-01","1995-12-11","1995-12-21","1995-12-31","1996-01-10","1996-01-20","1996-01-30","1996-02-09","1996-02-19"/)

year1996_str = (/"1996-12-01","1996-12-11","1996-12-21","1996-12-31","1997-01-10","1997-01-20","1997-01-30","1997-02-09","1997-02-19"/)
year1997_str = (/"1997-12-01","1997-12-11","1997-12-21","1997-12-31","1998-01-10","1998-01-20","1998-01-30","1998-02-09","1998-02-19"/)
year1998_str = (/"1998-12-01","1998-12-11","1998-12-21","1998-12-31","1999-01-10","1999-01-20","1999-01-30","1999-02-09","1999-02-19"/)
year1999_str = (/"1999-12-01","1999-12-11","1999-12-21","1999-12-31","2000-01-10","2000-01-20","2000-01-30","2000-02-09","2000-02-19"/)
year2000_str = (/"2000-12-01","2000-12-11","2000-12-21","2000-12-31","2001-01-10","2001-01-20","2001-01-30","2001-02-09","2001-02-19"/)

year2001_str = (/"2001-12-01","2001-12-11","2001-12-21","2001-12-31","2002-01-10","2002-01-20","2002-01-30","2002-02-09","2002-02-19"/)
year2002_str = (/"2002-12-01","2002-12-11","2002-12-21","2002-12-31","2003-01-10","2003-01-20","2003-01-30","2003-02-09","2003-02-19"/)
year2003_str = (/"2003-12-01","2003-12-11","2003-12-21","2003-12-31","2004-01-10","2004-01-20","2004-01-30","2004-02-09","2004-02-19"/)
year2004_str = (/"2004-12-01","2004-12-11","2004-12-21","2004-12-31","2005-01-10","2005-01-20","2005-01-30","2005-02-09","2005-02-19"/)
year2005_str = (/"2005-12-01","2005-12-11","2005-12-21","2005-12-31","2006-01-10","2006-01-20","2006-01-30","2006-02-09","2006-02-19"/) 

year2006_str = (/"2006-12-01","2006-12-11","2006-12-21","2006-12-31","2007-01-10","2007-01-20","2007-01-30","2007-02-09","2007-02-19"/) 
year2007_str = (/"2007-12-01","2007-12-11","2007-12-21","2007-12-31","2008-01-10","2008-01-20","2008-01-30","2008-02-09","2008-02-19"/) 
year2008_str = (/"2008-12-01","2008-12-11","2008-12-21","2008-12-31","2009-01-10","2009-01-20","2009-01-30","2009-02-09","2009-02-19"/) 


;------- be aware that a space in the last ---------
var_str = "SHFLX,LHFLX,SWCF,LWCF,Z3,hyam,hybm,PS "

str_new = "_HCforcing"

do i_ens = 0,8

system("ncrcat -O -D 2 -v "+var_str+in_dir+"1989_sim2_" + year1989_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1989_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1990_sim2_" + year1990_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1990_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1991_sim2_" + year1991_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1991_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1992_sim2_" + year1992_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1992_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1993_sim2_" + year1993_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1993_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1994_sim2_" + year1994_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1994_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1995_sim2_" + year1995_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1995_str(i_ens)+".TOPOTEST.nc")

system("ncrcat -O -D 2 -v "+var_str+in_dir+"1996_sim2_" + year1996_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1996_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1997_sim2_" + year1997_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1997_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1998_sim2_" + year1998_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1998_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1999_sim2_" + year1999_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year1999_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2000_sim2_" + year2000_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2000_str(i_ens)+".TOPOTEST.nc")

system("ncrcat -O -D 2 -v "+var_str+in_dir+"2001_sim2_" + year2001_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2001_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2002_sim2_" + year2002_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2002_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2003_sim2_" + year2003_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2003_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2004_sim2_" + year2004_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2004_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2005_sim2_" + year2005_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2005_str(i_ens)+".TOPOTEST.nc")

system("ncrcat -O -D 2 -v "+var_str+in_dir+"2006_sim2_" + year2006_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2006_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2007_sim2_" + year2007_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2007_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2008_sim2_" + year2008_str(i_ens)+str_new+"/atm/hist/*h1*.nc -o "+out_dir+year2008_str(i_ens)+".TOPOTEST.nc")

end do

;===========CTR ===============
;CTR already done
;...
;--------------------

;;========== Calculate the mean and std of ensemble in TOPOTEST ======
;;-----combine different members into a single file
system("ncecat -u realization "+out_dir+"*.nc -o "+out_dir+"ENS.TOPOTEST.nc")
;
;;-----calculate the ensemble mean along the realization dimension
system("ncwa -O -a realization "+out_dir+"ENS.TOPOTEST.nc "+out_dir+"ENS.mean.TOPOTEST.nc")
;
;;-----Calculate Anomaly -
system("ncbo -O "+out_dir+"ENS.TOPOTEST.nc "+out_dir+"ENS.mean.TOPOTEST.nc "+out_dir+"ENS.anom.TOPOTEST.nc")
;
;;------Calculate the standard deviation along realization dimension-
system("ncra -O -y rmssdn "+out_dir+"ENS.anom.TOPOTEST.nc "+out_dir+"ENS.std.TOPOTEST.nc")
;

end
