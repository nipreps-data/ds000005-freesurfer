

#---------------------------------
# New invocation of recon-all Mon Dec  4 21:50:09 EST 2023 

 mri_convert /data/nipreps-data/ds000005-freesurfer/sourcedata/ds000005/sub-01/anat/sub-01_T1w.nii.gz /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/orig/001.mgz 



#---------------------------------
# New invocation of recon-all Mon Dec  4 21:52:52 EST 2023 
#--------------------------------------------
#@# MotionCor Mon Dec  4 21:52:52 EST 2023

 cp /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/orig/001.mgz /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/rawavg.mgz 


 mri_info /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/rawavg.mgz 


 mri_convert /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/rawavg.mgz /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/transforms/talairach.xfm /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/orig.mgz /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/orig.mgz 


 mri_info /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Mon Dec  4 21:52:58 EST 2023

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --ants-n4 --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

lta_convert --src orig.mgz --trg /usr/local/freesurfer/7.4.1/average/mni305.cor.mgz --inxfm transforms/talairach.xfm --outlta transforms/talairach.xfm.lta --subject fsaverage --ltavox2vox
#--------------------------------------------
#@# Talairach Failure Detection Mon Dec  4 21:55:49 EST 2023

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /usr/local/freesurfer/7.4.1/bin/extract_talairach_avi_QA.awk /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/transforms/talairach_avi.log 


 tal_QC_AZS /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Mon Dec  4 21:55:49 EST 2023

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 --ants-n4 


 mri_add_xform_to_header -c /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Mon Dec  4 21:58:39 EST 2023

 mri_normalize -g 1 -seed 1234 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Mon Dec  4 21:59:40 EST 2023

 mri_em_register -skull nu.mgz /usr/local/freesurfer/7.4.1/average/RB_all_withskull_2020_01_02.gca transforms/talairach_with_skull.lta 


 mri_watershed -T1 -brain_atlas /usr/local/freesurfer/7.4.1/average/RB_all_withskull_2020_01_02.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Mon Dec  4 22:01:57 EST 2023

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /usr/local/freesurfer/7.4.1/average/RB_all_2020-01-02.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Mon Dec  4 22:03:31 EST 2023

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /usr/local/freesurfer/7.4.1/average/RB_all_2020-01-02.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Mon Dec  4 22:04:18 EST 2023

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /usr/local/freesurfer/7.4.1/average/RB_all_2020-01-02.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Mon Dec  4 22:41:59 EST 2023

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /usr/local/freesurfer/7.4.1/average/RB_all_2020-01-02.gca aseg.auto_noCCseg.mgz 

#--------------------------------------
#@# CC Seg Mon Dec  4 23:05:37 EST 2023

 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/transforms/cc_up.lta sub-01 

#--------------------------------------
#@# Merge ASeg Mon Dec  4 23:06:01 EST 2023

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Mon Dec  4 23:06:01 EST 2023

 mri_normalize -seed 1234 -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Mon Dec  4 23:07:37 EST 2023

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Mon Dec  4 23:07:38 EST 2023

 AntsDenoiseImageFs -i brain.mgz -o antsdn.brain.mgz 


 mri_segment -wsizemm 13 -mprage antsdn.brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Mon Dec  4 23:09:13 EST 2023

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.presurf.mgz -ctab /usr/local/freesurfer/7.4.1/SubCorticalMassLUT.txt wm.mgz filled.mgz 

 cp filled.mgz filled.auto.mgz
#--------------------------------------------
#@# Tessellate lh Mon Dec  4 23:09:58 EST 2023

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh Mon Dec  4 23:10:01 EST 2023

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Mon Dec  4 23:10:04 EST 2023

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh Mon Dec  4 23:10:04 EST 2023

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Mon Dec  4 23:10:06 EST 2023

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh Mon Dec  4 23:10:06 EST 2023

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Mon Dec  4 23:10:15 EST 2023

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh Mon Dec  4 23:10:15 EST 2023

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#@# Fix Topology lh Mon Dec  4 23:11:19 EST 2023

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 sub-01 lh 

#@# Fix Topology rh Mon Dec  4 23:11:19 EST 2023

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 sub-01 rh 


 mris_euler_number ../surf/lh.orig.premesh 


 mris_euler_number ../surf/rh.orig.premesh 


 mris_remesh --remesh --iters 3 --input /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.orig.premesh --output /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.orig 


 mris_remesh --remesh --iters 3 --input /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.orig.premesh --output /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm -f ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm -f ../surf/rh.inflated 

#--------------------------------------------
#@# AutoDetGWStats lh Mon Dec  4 23:16:09 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.lh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/lh.orig.premesh
#--------------------------------------------
#@# AutoDetGWStats rh Mon Dec  4 23:16:11 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.rh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/rh.orig.premesh
#--------------------------------------------
#@# WhitePreAparc lh Mon Dec  4 23:16:14 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --wm wm.mgz --threads 10 --invol brain.finalsurfs.mgz --lh --i ../surf/lh.orig --o ../surf/lh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# WhitePreAparc rh Mon Dec  4 23:18:39 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --wm wm.mgz --threads 10 --invol brain.finalsurfs.mgz --rh --i ../surf/rh.orig --o ../surf/rh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# CortexLabel lh Mon Dec  4 23:21:31 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 0 ../label/lh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg lh Mon Dec  4 23:21:43 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 1 ../label/lh.cortex+hipamyg.label
#--------------------------------------------
#@# CortexLabel rh Mon Dec  4 23:21:54 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 0 ../label/rh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg rh Mon Dec  4 23:22:06 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 1 ../label/rh.cortex+hipamyg.label
#--------------------------------------------
#@# Smooth2 lh Mon Dec  4 23:22:18 EST 2023

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh Mon Dec  4 23:22:18 EST 2023

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Mon Dec  4 23:22:20 EST 2023

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh Mon Dec  4 23:22:20 EST 2023

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh Mon Dec  4 23:22:31 EST 2023

 mris_curvature -w -seed 1234 lh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh Mon Dec  4 23:22:31 EST 2023

 mris_curvature -w -seed 1234 rh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 

#--------------------------------------------
#@# Sphere lh Mon Dec  4 23:23:08 EST 2023

 mris_sphere -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh Mon Dec  4 23:23:08 EST 2023

 mris_sphere -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh Mon Dec  4 23:28:49 EST 2023

 mris_register -curv ../surf/lh.sphere /usr/local/freesurfer/7.4.1/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh Mon Dec  4 23:28:49 EST 2023

 mris_register -curv ../surf/rh.sphere /usr/local/freesurfer/7.4.1/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Mon Dec  4 23:34:21 EST 2023

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh Mon Dec  4 23:34:21 EST 2023

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Mon Dec  4 23:34:22 EST 2023

 mrisp_paint -a 5 /usr/local/freesurfer/7.4.1/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh Mon Dec  4 23:34:22 EST 2023

 mrisp_paint -a 5 /usr/local/freesurfer/7.4.1/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Mon Dec  4 23:34:22 EST 2023

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /usr/local/freesurfer/7.4.1/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh Mon Dec  4 23:34:22 EST 2023

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /usr/local/freesurfer/7.4.1/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# WhiteSurfs lh Mon Dec  4 23:34:31 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 10 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot
#--------------------------------------------
#@# WhiteSurfs rh Mon Dec  4 23:36:18 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 10 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot
#--------------------------------------------
#@# T1PialSurf lh Mon Dec  4 23:38:20 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 10 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white --o ../surf/lh.pial.T1 --pial --nsmooth 0 --rip-label ../label/lh.cortex+hipamyg.label --pin-medial-wall ../label/lh.cortex.label --aparc ../label/lh.aparc.annot --repulse-surf ../surf/lh.white --white-surf ../surf/lh.white
#--------------------------------------------
#@# T1PialSurf rh Mon Dec  4 23:40:30 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 10 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white --o ../surf/rh.pial.T1 --pial --nsmooth 0 --rip-label ../label/rh.cortex+hipamyg.label --pin-medial-wall ../label/rh.cortex.label --aparc ../label/rh.aparc.annot --repulse-surf ../surf/rh.white --white-surf ../surf/rh.white
#@# white curv lh Mon Dec  4 23:42:21 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
#@# white area lh Mon Dec  4 23:42:22 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
#@# pial curv lh Mon Dec  4 23:42:23 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
#@# pial area lh Mon Dec  4 23:42:24 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
#@# thickness lh Mon Dec  4 23:42:24 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# area and vertex vol lh Mon Dec  4 23:42:47 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# white curv rh Mon Dec  4 23:42:48 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
#@# white area rh Mon Dec  4 23:42:50 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
#@# pial curv rh Mon Dec  4 23:42:50 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
#@# pial area rh Mon Dec  4 23:42:51 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
#@# thickness rh Mon Dec  4 23:42:52 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
#@# area and vertex vol rh Mon Dec  4 23:43:15 EST 2023
cd /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness

#-----------------------------------------
#@# Curvature Stats lh Mon Dec  4 23:43:16 EST 2023

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-01 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Mon Dec  4 23:43:18 EST 2023

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-01 rh curv sulc 

#--------------------------------------------
#@# Cortical ribbon mask Mon Dec  4 23:43:20 EST 2023

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-01 

#-----------------------------------------
#@# Cortical Parc 2 lh Mon Dec  4 23:46:44 EST 2023

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /usr/local/freesurfer/7.4.1/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh Mon Dec  4 23:46:44 EST 2023

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /usr/local/freesurfer/7.4.1/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 3 lh Mon Dec  4 23:46:55 EST 2023

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /usr/local/freesurfer/7.4.1/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh Mon Dec  4 23:46:55 EST 2023

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /usr/local/freesurfer/7.4.1/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# WM/GM Contrast lh Mon Dec  4 23:47:03 EST 2023

 pctsurfcon --s sub-01 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh Mon Dec  4 23:47:03 EST 2023

 pctsurfcon --s sub-01 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities Mon Dec  4 23:47:05 EST 2023

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# APas-to-ASeg Mon Dec  4 23:47:16 EST 2023

 mri_surf2volseg --o aseg.mgz --i aseg.presurf.hypos.mgz --fix-presurf-with-ribbon /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/mri/ribbon.mgz --threads 10 --lh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.cortex.label --lh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.white --lh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.pial --rh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.cortex.label --rh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.white --rh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.pial 


 mri_brainvol_stats --subject sub-01 

#-----------------------------------------
#@# AParc-to-ASeg aparc Mon Dec  4 23:47:23 EST 2023

 mri_surf2volseg --o aparc+aseg.mgz --label-cortex --i aseg.mgz --threads 10 --lh-annot /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.aparc.annot 1000 --lh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.cortex.label --lh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.white --lh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.pial --rh-annot /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.aparc.annot 2000 --rh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.cortex.label --rh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.white --rh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.a2009s Mon Dec  4 23:48:01 EST 2023

 mri_surf2volseg --o aparc.a2009s+aseg.mgz --label-cortex --i aseg.mgz --threads 10 --lh-annot /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.aparc.a2009s.annot 11100 --lh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.cortex.label --lh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.white --lh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.pial --rh-annot /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.aparc.a2009s.annot 12100 --rh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.cortex.label --rh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.white --rh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.DKTatlas Mon Dec  4 23:48:38 EST 2023

 mri_surf2volseg --o aparc.DKTatlas+aseg.mgz --label-cortex --i aseg.mgz --threads 10 --lh-annot /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.aparc.DKTatlas.annot 1000 --lh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.cortex.label --lh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.white --lh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.pial --rh-annot /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.aparc.DKTatlas.annot 2000 --rh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.cortex.label --rh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.white --rh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.pial 

#-----------------------------------------
#@# WMParc Mon Dec  4 23:49:15 EST 2023

 mri_surf2volseg --o wmparc.mgz --label-wm --i aparc+aseg.mgz --threads 10 --lh-annot /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.aparc.annot 3000 --lh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/lh.cortex.label --lh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.white --lh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/lh.pial --rh-annot /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.aparc.annot 4000 --rh-cortex-mask /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/label/rh.cortex.label --rh-white /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.white --rh-pial /data/nipreps-data/ds000005-freesurfer/subjects/sub-01/surf/rh.pial 


 mri_segstats --seed 1234 --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-01 --surf-wm-vol --ctab /usr/local/freesurfer/7.4.1/WMParcStatsLUT.txt --etiv 

#-----------------------------------------
#@# Parcellation Stats lh Mon Dec  4 23:52:13 EST 2023

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-01 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-01 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh Mon Dec  4 23:52:13 EST 2023

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-01 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-01 rh pial 

#-----------------------------------------
#@# Parcellation Stats 2 lh Mon Dec  4 23:52:23 EST 2023

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-01 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh Mon Dec  4 23:52:23 EST 2023

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-01 rh white 

#-----------------------------------------
#@# Parcellation Stats 3 lh Mon Dec  4 23:52:32 EST 2023

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-01 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh Mon Dec  4 23:52:32 EST 2023

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-01 rh white 

#--------------------------------------------
#@# ASeg Stats Mon Dec  4 23:52:40 EST 2023

 mri_segstats --seed 1234 --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /usr/local/freesurfer/7.4.1/ASegStatsLUT.txt --subject sub-01 

INFO: fsaverage subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to fsaverage subject...

 cd /data/nipreps-data/ds000005-freesurfer/subjects; ln -s /usr/local/freesurfer/7.4.1/subjects/fsaverage; cd - 

#--------------------------------------------
#@# BA_exvivo Labels lh Mon Dec  4 23:53:09 EST 2023

 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-01 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-01 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-01 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-01 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-01 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.FG1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.FG2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.FG3.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG3.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.FG4.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG4.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.hOc1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.hOc2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.hOc3v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc3v.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.hOc4v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc4v.mpm.vpnl.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-01 --ctab /usr/local/freesurfer/7.4.1/average/colortable_vpnl.txt --hemi lh --a mpm.vpnl --maxstatwinner --noverbose --l lh.FG1.mpm.vpnl.label --l lh.FG2.mpm.vpnl.label --l lh.FG3.mpm.vpnl.label --l lh.FG4.mpm.vpnl.label --l lh.hOc1.mpm.vpnl.label --l lh.hOc2.mpm.vpnl.label --l lh.hOc3v.mpm.vpnl.label --l lh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-01 --hemi lh --ctab /usr/local/freesurfer/7.4.1/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.perirhinal_exvivo.label --l lh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-01 --hemi lh --ctab /usr/local/freesurfer/7.4.1/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-01 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-01 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh Mon Dec  4 23:54:01 EST 2023

 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-01 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-01 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-01 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-01 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-01 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.FG1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.FG2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.FG3.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG3.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.FG4.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG4.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.hOc1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.hOc2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.hOc3v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc3v.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.hOc4v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc4v.mpm.vpnl.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-01 --ctab /usr/local/freesurfer/7.4.1/average/colortable_vpnl.txt --hemi rh --a mpm.vpnl --maxstatwinner --noverbose --l rh.FG1.mpm.vpnl.label --l rh.FG2.mpm.vpnl.label --l rh.FG3.mpm.vpnl.label --l rh.FG4.mpm.vpnl.label --l rh.hOc1.mpm.vpnl.label --l rh.hOc2.mpm.vpnl.label --l rh.hOc3v.mpm.vpnl.label --l rh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /data/nipreps-data/ds000005-freesurfer/subjects/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-01 --hemi rh --ctab /usr/local/freesurfer/7.4.1/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.perirhinal_exvivo.label --l rh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-01 --hemi rh --ctab /usr/local/freesurfer/7.4.1/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-01 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-01 rh white 

