#!/bin/bash
# Make a T2M forcing time series

set -x
set -e

# Requires module nco
# Currently on fram
# module load NCO/4.7.9-intel-2018b

# User settings
params=$1

if [ ! -f ${params} ]; then
    echo Error: parameter file $params not found, exiting! 
    exit
fi

## User settings
source $params

#run=N1850frc2_SMB1
#syear=0001
#eyear=0002
#filedir=/luster/work/users/heig/archive/$run/lnd/hist
#scratchdir=/cluster/work/users/heig/archive/N1850frc2_SMB1/lnd/hist/SMB

###
# Directories with files from step before (can be symlink)
INDIR=$scratchdir/s9_t2m
OUTDIR=$scratchdir/s10_timeseries_t2m

/bin/rm -r $OUTDIR
mkdir -p ${OUTDIR} 

# Select variables to process
FILES=$(ls $INDIR/*nc)

# target file
OUTFILE=${OUTDIR}/t2m_${syear}-${eyear}_${run}.nc
OUTFILE_ltm=${OUTDIR}/t2m_ltm0_${syear}-${eyear}_${run}.nc

echo $FILES

# concat
ncrcat -O -v T2M $FILES ${OUTFILE}

# Work in netcdf3 as a workaround of renaming problems 
ncks -O -h -3 ${OUTFILE} tmp.nc

# rename variables and dims
ncrename -v T2M,t2m tmp.nc 
ncrename -O -d x,x1 -d y,y1 tmp.nc 

# Make a time axis
ncap2 -O -v -s "time=array(${syear},1,\$time)" tmp.nc  ${OUTDIR}/time_${syear}-${eyear}.nc
ncks -A -v time ${OUTDIR}/time_${syear}-${eyear}.nc tmp.nc  

# Add diemsion variables
ncks -A -v x1,y1 x1y1_04km.nc tmp.nc

# Back to netcdf4
ncks -O -h -4 tmp.nc ${OUTFILE}
 
# Unit conversion ?
#ncap2 -O -s "t2m=t2m" ${OUTFILE} ${OUTFILE}
ncatted -h -a units,t2m,o,c,"degree_Celsius" ${OUTFILE} 
ncatted -h -a coordinates,t2m,d,, ${OUTFILE} 

# make long term average
ncra -d time,0,-1 ${OUTFILE} ${OUTFILE_ltm}


### Masking
## create mask time series
#ncks -v t2m -d time,0 output.nc t2m_ref.nc
#cp t2m_ref.nc  t2m_ref2.nc
#ncrcat t2m_ref.nc t2m_ref2.nc t2m0.nc
#for i in {1..119}; do  /bin/mv t2m0.nc t2m_ref2.nc; ncrcat t2m_ref.nc t2m_ref2.nc t2m0.nc; done 
## add time axis 
#ncks -A -v time time_1850-1969.nc t2m0.nc
#ncks -A -v t2m_ref t2m0.nc ${OUTFILE} 
#ncap2 -O -s "where (t2m_ref==-2000) t2m=-2000" ${OUTFILE} ${OUTFILE} 
#ncks -C -O -x -v t2m_ref ${OUTFILE} ${OUTFILE} 
