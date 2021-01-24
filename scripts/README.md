## Process scripts

### Run in this order  

### activate python environment!
source ~/miniconda3/bin/activate base

setup.sh <br>
extract_variables.sh <br>
process_raw_vector.py <br>
convert_grid.sh <br>
apply_vertical_interpolation.py <br>
calc_SMB.sh <br>
make_forcing_timeseries.sh <br>

### Or run setup and then as batch file run_batch.sh
./setup/sh <br>
./run_batch.sh <br>


### Set up parameters, input data and path environment
./setup.sh

### Extract 3d elevation class information (level,lat,lon) from column files 
./extract_variables.sh

### Make 3-dimensional variables 
./process_raw_vector.py

### Conversion to regional grid
./convert_grid.sh

### Run vertical interpolation
./apply_vertical_interpolation.py

### Combine components to get SMB
./calc_SMB.sh

### Make SMB time series forcing record
./make_forcing_timeseries.sh
