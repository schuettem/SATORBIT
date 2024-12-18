# SATORBIT.jl
SATORBIT.jl is a Julia package designed for simulating satellite orbits around Earth. This package provides comprehensive tools for defining initial orbital elements, simulating the orbit over a specified number of orbits, and accounting for various perturbations.

## Features
- **J2 Disturbance**: Account for the J2 perturbation by assuming that the Earth is an ellipsoid.
- **Atmospheric Drag**: Incorporate atmospheric drag in the calculations using the atmospheric data from the NRLMSISE-00 model by the US Naval Research Laboratory (NRL).
- **Space Weather Data**:
  - Historic data: From the GFZ German Research Centre for Geosciences.
  - Forecast data (45-daily): From the Space Weather Prediction Center National Oceanic and Atmospheric Administration (NOAA).
  - Forecast data (monthly): From NASA Marshall Space Flight Center.

- **SPICE Kernels**: SPICE kernels are used for precise ephemeris data and transformations from NASA Navigation and Ancillary Information Facility (NAIF).
- **HWM14**: The Horizontal Wind Model 2014 (HWM14) from the Naval Research Laboratory (NRL) is used to account for atmospheric wind.

Note: This project is not affiliated with NASA, NRL, NAIF, NOAA, or the GFZ in any way.

## Prerequisites
 - The package [HWM14](https://github.com/schuettem/HWM14) has to be added manually.

## Installation
1. Open julia and enter the package manager (Pkg) mode by pressing `]`.
2. Add the SATORBIT package using the following command:
   ```julia
   add <url>
   ```

## Acknowledgements
This package uses the following packages and models:
- NRLMSISE-00:
  - We are using the NRLMSISE-00 atmosphere model from the [SatelliteToolboxAtmosphericModel](https://juliaspace.github.io/SatelliteToolboxAtmosphericModels.jl/stable/man/nrlmsise00/)
   - The NRLMSISE-00 is an empirical, global reference atmospheric model developed by the US Naval Research Laboratory (NRL). It models the temperatures and densities of the Earth's atmosphere from the ground up to space. The model was developed by Mike Picone, Alan Hedin, and Doug Drob.

- SPICE.jl:
  - Used for the SPICE kernel operations.
  - This package is a Julia wrapper for [NASA NAIF's SPICE toolkit](https://naif.jpl.nasa.gov/naif/).
  - Refer to the [documentation](http://juliaastro.org/SPICE.jl/stable/) or the [GitHub page](https://github.com/JuliaAstro/SPICE.jl?tab=readme-ov-file) for more information.

- SPICE kernels:
  - The SPICE kernels used in this project are provided by the NASA Navigation and Ancillary Information Facility (NAIF).
  - Data Source: [NAIF Generic Kernels](https://naif.jpl.nasa.gov/naif/data_generic.html).
  - Earth orientation kernel: High accuracy, historical kernel from 1962-01-01 till 2024-08-27. Downloaded from https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/
  - Leap seconds kernel: Dowloaded from https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/

- Historical space weather data:
  - This data is used as input for the atmospheric model (F10.7, F10.7a, ap).
  - Data source: [Geomagnetic Observatory Niemegk, GFZ German Research Centre for Geosciences](https://www.gfz-potsdam.de/)
  - The file `Kp_ap_Ap_SN_F107_since_1932.txt` will be downloaded from [https://kp.gfz-potsdam.de/app/files/Kp_ap_Ap_SN_F107_since_1932.txt](https://kp.gfz-potsdam.de/app/files/Kp_ap_Ap_SN_F107_since_1932.txt) to ensure it remains up to date.

- Forecast space weather data (45-days):
  - This data is used as input for the atmospheric model (F10.7, no 81 day average, ap).
  - Data source: [https://services.swpc.noaa.gov/text/45-day-ap-forecast.txt](https://services.swpc.noaa.gov/text/45-day-ap-forecast.txt)
  - The file `45-day-ap-forecast.txt` will be downloaded from [https://services.swpc.noaa.gov/text/45-day-ap-forecast.txt](https://services.swpc.noaa.gov/text/45-day-ap-forecast.txt) to ensure it remains up to date.

- Forecast space weather data (monthly forecast):
   - This data is used as input for the atmospheric model (F10.7, no 81 day average, ap).
   - Data source: [https://www.nasa.gov/solar-cycle-progression-and-forecast/archived-forecast/](https://www.nasa.gov/solar-cycle-progression-and-forecast/archived-forecast/)
   - The recent updated file will be downloaded from [https://www.nasa.gov/solar-cycle-progression-and-forecast/archived-forecast/](https://www.nasa.gov/solar-cycle-progression-and-forecast/archived-forecast/).

## References
- Historical space weather:<br>
  Matzka, J., Stolle, C., Yamazaki, Y., Bronkalla, O. and Morschhauser, A., 2021. The geomagnetic Kp index and derived indices of geomagnetic activity. Space Weather, https://doi.org/10.1029/2020SW002641

- NRLMSISE-00:<br>
  Picone, J. M., Hedin, A. E., Drob, D. P., & Aikin, A. C. (2002). NRLMSISE-00 empirical model of the atmosphere: Statistical comparisons and scientific issues. Journal of Geophysical Research: Space Physics, 107(A12), 1468. [doi:10.1029/2002JA009430](https://doi.org/10.1029/2002JA009430)

- SPICE:<br>
  Acton, C.H.; "Ancillary Data Services of NASA's Navigation and Ancillary Information Facility;" Planetary and Space Science, Vol. 44, No. 1, pp. 65-70, 1996.

## License
This code is licensed under the MIT License

## Data License
- Historical space weather data:<br>
  General:<br>
  This project uses data licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license. Data source: [Geomagnetic Observatory Niemegk, GFZ German Research Centre for Geosciences](https://www.gfz-potsdam.de/). <br>
  Sunspot data:<br>
  The sunspot numbers contained in this project are licensed under the Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0) license. Data source: [Geomagnetic Observatory Niemegk, GFZ German Research Centre for Geosciences](https://www.gfz-potsdam.de/).


