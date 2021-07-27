#!/bin/bash
# Set up input files and directory structure

######### User input

# Run specific
#run=NHISTpiaeroxid_f09_tn14_keyClim20201217
#syear=1970
#eyear=1999

run=N1850frc2G_f19_tn14_gl4_SMB1_purr
syear=1700
eyear=1729

#run=N1850frc2G_f09_tn14_gl4_SMB1_pro1
#syear=1700
#eyear=1729

# NorESM betzy archive
filedir=/cluster/work/users/heig/archive/$run/lnd/hist
scratchdir=/cluster/projects/nn9560k/heig/smb/${run}_t/MEC

# NorESM fram 
#filedir=/cluster/work/users/heig/archive/$run/lnd/hist 

# NorESM nird
#filedir=/projects/NS9560K/users/heig/NorESM/archive/$run/lnd/hist # nird
#scratchdir=/projects/NS9560K/users/heig/SMB/$run/SMB


# Target grid and elevation
grid_file=../data/grid_CISM_GrIS_04000m.nc
elev_file=../data/cism_topography.nc
elev_varname=topg

# Options
# fill missing values in gcm output. Needed in particular for low res model
# 0= no fill, 1=fill by bilinear interpolation, 2=fill by nearest neighbor 
opt_fill=1

###############

# Create param file
echo "# Generated params file" > params.tmp
echo "run="${run} >> params.tmp
echo "syear="${syear} >> params.tmp
echo "eyear="${eyear} >> params.tmp
echo "filedir="${filedir} >> params.tmp
echo "scratchdir="${scratchdir} >> params.tmp
echo "grid_file="${grid_file} >> params.tmp
echo "elev_file="${elev_file} >> params.tmp
echo "elev_varname="${elev_varname} >> params.tmp
echo "opt_fill="${opt_fill} >> params.tmp
cat params.tmp

# Create paths
mkdir -p ${scratchdir}/s1_vector
mkdir -p ${scratchdir}/s2_gridded3d
mkdir -p ${scratchdir}/s3_regridded
mkdir -p ${scratchdir}/s4_remapped
mkdir -p ${scratchdir}/s5_smb
mkdir -p ${scratchdir}/s6_timeseries
mkdir -p ${scratchdir}/s7_artm
mkdir -p ${scratchdir}/s8_timeseries_artm

# set up
/bin/cp params.tmp ../params
