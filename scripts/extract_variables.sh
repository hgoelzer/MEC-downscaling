#!/bin/bash
# Extract column variables from archive
# Here, yearly averages over monthly files

# Requires module nco and cdo
# Currently on fram
# module load CDO/1.9.5-intel-2018b
# module load NCO/4.7.9-intel-2018b

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

#varlist="QICE"
#varlist="QSNOMELT"
#varlist="TOPO_COL"

# We need TOPO_COL to extract EC surface elevations
#varlist="QICE SNOW QSNOFRZ QSNOMELT QICE_MELT QSOIL TOPO_COL"
varlist="QICE SNOW QSNOFRZ QSNOMELT QICE_MELT QSOIL TOPO_COL TG TSA"

/bin/rm -r $scratchdir/s1_vector
mkdir -p $scratchdir/s1_vector

for i in `eval echo {${syear}..${eyear}..1}`; do
    year=$i
    echo "# Processing " $year

    for var in $varlist; do
	echo $var
	ncra -O -v $var,lat,lon,cols1d_ixy,cols1d_jxy,cols1d_itype_lunit,cols1d_itype_col,pfts1d_ixy,pfts1d_jxy,pfts1d_itype_lunit,pfts1d_itype_col  $filedir/${run}.clm2.h2.${year}-*.nc $scratchdir/s1_vector/${run}.clm2.h2.${var}.${year}.nc 
    done
    # get ice sheet mask from end of year
    echo ICE_MODEL_FRACTION,PCT_LANDUNIT,landfrac
    ncks -O -v ICE_MODEL_FRACTION,PCT_LANDUNIT,landfrac $filedir/${run}.clm2.h0.${year}-12.nc $scratchdir/s1_vector/${run}.clm2.h0.mask.${year}.nc 
done
