;Function: MSE difference between CTR ensemble and TOPO ensemble, with significance.
;Date: 20181031
;Date: 20181130

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

chunk = 32
num_time = 96

num1 = new(32,integer)
num2 = new(32,integer)

do i_chunk = 0,chunk-1
num1_temp = i_chunk * num_time/chunk
num2_temp = num1_temp + num_time/chunk - 1

num1(i_chunk) = num1_temp
num2(i_chunk) = num2_temp
end do  ; do i_chunk

;-------------
str_time = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
end do

;=====================================
do index = 0,31

TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_str = "ENS.std.mean.TOPOTEST.MSE.time"+str_time(index)+".nc"

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_str = "ENS.std.mean.CTR.MSE.time"+str_time(index)+".nc"

;var = (/"MSE"/)

f_TOPO = addfile(TOPO_dir+TOPO_str,"r")

f_CTR = addfile(CTR_dir+CTR_str,"r")

MSE_mean_TOPO = f_TOPO->MSE_TOPO_mean
MSE_std_TOPO = f_TOPO->MSE_TOPO_std

MSE_mean_CTR = f_CTR->MSE_CTR_mean
MSE_std_CTR = f_CTR->MSE_CTR_std

;------------- hybrid to pressure coordinate -----
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO->hyam
hybm = f_TOPO->hybm

MSE_mean_TOPO_pnew = vinth2p(MSE_mean_TOPO,hyam,hybm,pnew,f_TOPO->PS_TOPO_mean,1,P0mb,1,False)
;printVarSummary(var_mean_TOPO_pnew)
MSE_std_TOPO_pnew = vinth2p(MSE_std_TOPO,hyam,hybm,pnew,f_TOPO->PS_TOPO_mean,1,P0mb,1,False)
;printVarSummary(var_std_TOPO_pnew)

MSE_mean_CTR_pnew = vinth2p(MSE_mean_CTR,hyam,hybm,pnew,f_CTR->PS_CTR_mean,1,P0mb,1,False)
;printVarSummary(var_mean_CTR_pnew)
MSE_std_CTR_pnew = vinth2p(MSE_std_CTR,hyam,hybm,pnew,f_CTR->PS_CTR_mean,1,P0mb,1,False)
;printVarSummary(var_std_CTR_pnew)

;-------------

siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(MSE_mean_TOPO_pnew,MSE_std_TOPO_pnew^2,indep_sample,MSE_mean_CTR_pnew,MSE_std_CTR_pnew^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
;
;===Note: In your previous analysis on daily output, TOPO and CTR time dimention matches well because in the 1_a_preprocessing, the processing of CTR files were using ncrcat connnect all together first, then use ncrcat again to tease out the slice of the same time  dimension as in TOPOTEST.
;=====   In this new 1 hr output, you used ncrcat to combine 4 day of files for CTR without combining all ~ 3month CTR data together, without using ncrcat (together with print(Calendar(X&time))), therefore, the CTR lag TOPO time dimension by 1 hr. You checked time_bnds to conclude this conclusion==== 

;-------change units ----
MSE_mean_TOPO_pnew = MSE_mean_TOPO_pnew / 1000.0 
MSE_mean_TOPO_pnew@units = "kJ/kg"

MSE_mean_CTR_pnew = MSE_mean_CTR_pnew / 1000.0 
MSE_mean_CTR_pnew@units = "kJ/kg"

diff_TOPO_CTR = MSE_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO - var_mean_CTR
diff_TOPO_CTR = MSE_mean_CTR_pnew - MSE_mean_TOPO_pnew

diff_TOPO_CTR_sig = MSE_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO - var_mean_CTR,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig = where(prob .lt. siglvl,MSE_mean_CTR_pnew - MSE_mean_TOPO_pnew,diff_TOPO_CTR@_FillValue)

printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)

;================ plot ===========
;total 96 hr in the TOPOTEST after branching
;total_hr = 96
;total_hr = 6
total_hr = 3

do i_hr = 0,total_hr-1

wks = gsn_open_wks("png","../Figures/2_Regional_MSE_500hPa_TOPO_vs_CTR_ihr"+tostring(index*3+i_hr+1))
wks_sig = gsn_open_wks("png","../Figures/2_Sig_Regional_MSE_500hPa_TOPO_vs_CTR_ihr"+tostring(index*3+i_hr+1))
wks_CTR = gsn_open_wks("png","../Figures/2_CTR_Regional_MSE_500hPa_TOPO_vs_CTR_ihr"+tostring(index*3+i_hr+1))

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = "MSE(500hPa), CTR - TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1)
;res@tiMainString = "MSE(avg of lowest 3 lvls), TOPO - CTR, ENS(180), ihr="+tostring(index*3+i_hr+1)
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -6.0
res@cnMaxLevelValF = 6.0
res@cnLevelSpacingF = 0.5
;res@cnMinLevelValF = -10.0
;res@cnMaxLevelValF = 10.0
;res@cnLevelSpacingF = 0.5

;res@cnMinLevelValF = -0.5
;res@cnMaxLevelValF = 0.5
;res@cnLevelSpacingF = 0.05

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0
;
res@gsnLeftString = "Moist Static Energy"
;lowest three level are lev = 957, 976, 992.

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_hr,{500.0},:,:),res)
delete(res@gsnCenterString)

plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_sig(i_hr,{500.0},:,:),res)
delete(res@gsnCenterString)

;================
res@gsnFrame = True
res@gsnDraw = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 220.0
res@cnMaxLevelValF = 360.0
res@cnLevelSpacingF = 5.0

res@cnFillPalette = "MPL_Blues"

res@tiMainString = "MSE(500hPa), CTR, ENS(180), ihr="+tostring(index*3+i_hr+1)

plot_CTR = gsn_csm_contour_map_ce(wks_CTR,MSE_mean_CTR_pnew(i_hr,{500.0},:,:),res)

delete(res@cnFillPalette)

delete(res@gsnFrame)
delete(res@gsnDraw)
end do
;==============================

end do ; do index

end
