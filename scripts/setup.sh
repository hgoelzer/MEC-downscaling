#!/bin/bash
# Set up input files and directory structure

######### User input

# Run specific
run=N1850frc2_SMB1
syear=0001
eyear=0010

# Path setup
#filedir=/cluster/work/users/heig/archive/$run/lnd/hist # fram
#scratchdir=/cluster/work/users/heig/archive/$run/lnd/hist/SMB1
filedir=/projects/NS9252K/users/heig/NorESM/archive/$run/lnd/hist # nird
scratchdir=/projects/NS9252K/users/heig/SMB/$run/SMB
# Target grid and elevation
grid_file=../data/grid_CISM_GrIS_04000m.nc
elev_file=../data/cism_topography.nc
elev_varname=topg

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
cat params.tmp

# Create paths
mkdir -p ${scratchdir}/s1_vector
mkdir -p ${scratchdir}/s2_gridded3d
mkdir -p ${scratchdir}/s3_regridded
mkdir -p ${scratchdir}/s4_remapped
mkdir -p ${scratchdir}/s5_smb

# set up
/bin/cp params.tmp ../params
