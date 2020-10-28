#!/bin/bash
# Extract column variables from archive
# Here, yearly averages over monthly files

#module load nco
#module load cdo

run=N1850frc2_SMB1
filedir=/cluster/work/users/heig/archive/$run/lnd/hist
scratchdir=/cluster/work/users/heig/archive/N1850frc2_SMB1/lnd/hist/vector1
outrun=${run}

#varlist="QICE"
#varlist="QSNOMELT"
#varlist="TOPO_COL"

# We need one TOPO_COL to extract EC surface elevations
#varlist="TOPO_COL"
varlist="QICE SNOW QSNOFRZ QSNOMELT QICE_MELT QSOIL"
mkdir -p $scratchdir

for i in {01..12..1}; do
    mn=$i
    echo "# Processing " $year

    for var in $varlist; do
	echo $var
	ncra -O -v $var,lat,lon,cols1d_ixy,cols1d_jxy,cols1d_itype_lunit,cols1d_itype_col,pfts1d_ixy,pfts1d_jxy,pfts1d_itype_lunit,pfts1d_itype_col  $filedir/${run}.clm2.h2.0001-${mn}.nc $scratchdir/${outrun}.clm2.h2.${var}.${mn}.nc 
    done
done
