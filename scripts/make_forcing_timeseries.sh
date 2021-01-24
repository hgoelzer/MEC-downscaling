#!/bin/bash
# Make an SMB forcing tiem series

set -x
set -e

# Requires module nco
# Currently on fram
# module load NCO/4.7.9-intel-2018b

## User settings

source ../params
#run=N1850frc2_SMB1
#syear=0001
#eyear=0002
#filedir=/luster/work/users/heig/archive/$run/lnd/hist
#scratchdir=/cluster/work/users/heig/archive/N1850frc2_SMB1/lnd/hist/SMB

###
# Directories with files from step before (can be symlink)
INDIR=$scratchdir/s5_smb
OUTDIR=$scratchdir/s6_timeseries
mkdir -p ${OUTDIR} 

# Select variables to process
FILES=$(ls $INDIR/*nc)

# target file
OUTFILE=${OUTDIR}/smb_${syear}-${eyear}_${run}.nc

echo $FILES

# concat
#for afile in $FILES; do
#    ncecat -O -u time $afile $afile
#done
ncrcat -O -v SMB $FILES ${OUTFILE}

# remove unused vars
ncks -C -O -x -v lon,lat,lon_bnds,lat_bnds ${OUTFILE} ${OUTFILE}

# rename variables and dims
ncrename -v SMB,smb ${OUTFILE} 
#ncrename -v lala,smb ${OUTFILE} 
ncrename -d x,x1 ${OUTFILE} 
ncrename -d y,y1 ${OUTFILE} 

# Make a time axis
ncap2 -O -v -s "time=array(${syear},1,\$time)" ${OUTFILE} ${OUTDIR}/time_${syear}-${eyear}.nc
ncks -A -v time ${OUTDIR}/time_${syear}-${eyear}.nc ${OUTFILE} 

# Add diemsion variables
# workaround for HDF error: move to classic model
nccopy -k classic ${OUTFILE} tmp.nc
ncks -A -v x1,y1 x1y1_04km.nc tmp.nc
mv tmp.nc ${OUTFILE}
 
# Unit conversion
ncap2 -O -s "smb=smb*31556926" ${OUTFILE} ${OUTFILE}
ncatted -h -a units,smb,o,c,"mm/yr water equivalent" ${OUTFILE} 
ncatted -h -a coordinates,smb,d,, ${OUTFILE} 

### Masking
## create mask time series
#ncks -v smb -d time,0 output.nc smb_ref.nc
#cp smb_ref.nc  smb_ref2.nc
#ncrcat smb_ref.nc smb_ref2.nc smb0.nc
#for i in {1..119}; do  /bin/mv smb0.nc smb_ref2.nc; ncrcat smb_ref.nc smb_ref2.nc smb0.nc; done 
## add time axis 
#ncks -A -v time time_1850-1969.nc smb0.nc
#ncks -A -v smb_ref smb0.nc ${OUTFILE} 
#ncap2 -O -s "where (smb_ref==-2000) smb=-2000" ${OUTFILE} ${OUTFILE} 
#ncks -C -O -x -v smb_ref ${OUTFILE} ${OUTFILE} 
