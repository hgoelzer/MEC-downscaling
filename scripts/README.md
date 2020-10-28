# Process scripts

Run in this order  

setup.sh
extract_variables.sh
process_raw_vector.py
convert_grid.sh
apply_vertical_interpolation.py
calc_SMB.sh

Or run setup and then as batch file run_batch.sh
./setup/sh
./run_batch.sh

# Set up parameters, input data and path environment
./setup.sh

# Extract 3d elevation class information (level,lat,lon) from column files 
./extract_variables.sh

# Make 3-dimensional variables 
./process_raw_vector.py

# Conversion to regional grid
./convert_grid.sh

# Run vertical interpolation
./apply_vertical_interpolation.py

# Combine components to get SMB
./calc_SMB.sh
