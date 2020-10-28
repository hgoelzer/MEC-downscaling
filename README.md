### MEC-downscaling, Heiko Goelzer, 2020 (heig@norceresearch.no)
Collection of scripts to downscale CLM MEC output to a high-resolution regional grid

Based on MEC-downscaling-example by Leo van Kampenhout
https://github.com/lvankampenhout/MEC-downscaling-example

Uses package libvector by Leo van Kampenhout
https://github.com/lvankampenhout/libvector

For step vertical_interpolation an optimized fortran code provided by Raymond Sellevold is used instead of the memory intensive python version.

SMB components are downscaled offline to a target grid. The offline downscaling follows a procedure, similar to the online downscaling used in CESM/NorESM to get SMB on the ice sheet scale. 
1. EC information is extracted from clm history output (requires specific namelist settings)
2. EC topography and variables of interest are bilinearly interpolated to the target grid. 
3. The variables of interest are vertically downscaled toward the target elevation by using the 3‐D fields from the previous steps. 
4. SMB is recombined from the downscaled components
SMB = SNOW + QSNOFRZ - QSNOMELT - QICE_MELT – QSOIL
All components in [mm/s] except QSNOFRZ [kg/m2/s], which boils down to mm/s

A version of these scripts has been used in the paper [Present‐Day Greenland Ice Sheet Climate and Surface Mass Balance in CESM2](doi.org/10.1029/2019JF005318) where it is called it "offline downscaling": 

This setup is prepared for use on fram or other SIGMA2 machines for NorESM

## Workflow in ./scripts

setup.sh
extract_variables.sh
process_raw_vector.py
convert_grid.sh
apply_vertical_interpolation.py
calc_SMB.sh


## Python environment

# Conda setup following (https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html)

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
source /cluster/home/heig/miniconda3/bin/activate base
conda config --set auto_activate_base false

# Setting up miniconda
conda install numpy
conda install netCDF4
conda install scipy
conda install xarray


## Setup fortran program for vertical interpolation 
cd scripts
f2py -c -m elevationclasses elevationclasses.F90
 

## Shell environment

module load CDO/1.9.5-intel-2018b
module load NCO/4.7.9-intel-2018b
module load ncview/2.1.7-intel-2018b


## Interactive usage
# Consider working in an interactive shell
srun --nodes=1 --time=00:30:00 --qos=devel --account=nn9252k --pty bash -i

# Load Python environment
source /cluster/home/heig/miniconda3/bin/activate base


