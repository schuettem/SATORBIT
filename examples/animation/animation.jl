using SATORBIT
using GLMakie
using GeometryBasics
using LinearAlgebra
using Dates
using GLFW
using FileIO

include("gui.jl")

GLMakie.activate!()

# Satellite Parameters
c_d = 2.2 # Drag Coefficient
area = 1.0 # Cross-sectional area (m^2)
mass = 1.0 # Mass (kg)

satellite = SATORBIT.Satellite(c_d, area, mass)

# Orbit Parameters
central_body = SATORBIT.Earth()

alt_perigee = 300e3
radius_perigee = central_body.radius + alt_perigee
alt_apogee = 400e3
radius_apogee = central_body.radius + alt_apogee

e = (radius_apogee - radius_perigee) / (radius_apogee + radius_perigee) # Eccentricity
a = (radius_perigee + radius_apogee) / 2.0 # Semi-major axis

i = 52.0 # Inclination (degrees)
f = 40.0 # True Anomaly (degrees)
Ω = 106.0 # Right Ascension of the Ascending Node (degrees)
ω = 234.0 # Argument of Periapsis (degrees)

init_orbit = SATORBIT.COES(a, e, i, Ω, ω, f)

start_date = SATORBIT.DateTime(2020, 5, 10, 12, 0, 0)

J2 = false
aero = true
disturbances = SATORBIT.Pertubations(J2, aero)

# inital eci position
r_0, v_0 = SATORBIT.coes2eci(init_orbit, central_body.μ)
r_0_mag = norm(r_0)

orbit = Observable(SATORBIT.Orbit(satellite, central_body, init_orbit, start_date))

# Observables:
satellite_position = Observable(r_0)
date_label = Observable(Dates.format(start_date, "yyyy-mm-dd HH:MM:SS"))
altitude = round((r_0_mag - central_body.radius) / 1e3, digits=2)
altitude_label = Observable("")
altitude_label[] = "$(round(altitude, digits=2)) km"

# COES labels
coes = Observable(init_orbit)

crash_label = Observable("")
crash_label[] = ""

# Fig:
fig, ax = create_gui()

is_running = Observable(false)

# plot the satellite
scatter!(ax, lift(x -> Point3f0(x...), satellite_position), markersize = 10, color = :red)

# Earth:
earth = plot_earth(ax)
rotate_earth(earth, start_date)

# plot ECI frame
plot_eci_frame(ax)

# plot ECEF frame
x_ecef, y_ecef, z_ecef = plot_ecef_frame(ax)
rotate_ecef_frame(x_ecef, y_ecef, z_ecef, start_date)

function animation(orbit, disturbances)
    while isopen(fig.scene)
        if is_running[]
            orbit_part = 1 / 200
            for i in 1:200
                if !is_running[]
                    break
                end

                SATORBIT.simulate_orbit!(orbit[], disturbances, orbit_part, 2)

                r = orbit[].eci[end].r
                v = orbit[].eci[end].v

                satellite_position[] = r

                altitude = round((norm(r) - orbit[].central_body.radius) / 1e3 , digits=2)
                altitude_label[] = "$(round(altitude, digits=2)) km"
                date_label[] = Dates.format(orbit[].time_utc[end], "yyyy-mm-dd HH:MM:SS")

                a, e, i, Ω, ω, f = SATORBIT.eci2coes(r, v, central_body.μ)
                coes[] = SATORBIT.COES(a, e, i, Ω, ω, f)

                if altitude < 100 # stop the simulation if the satellite is below 100 km
                    is_running[] = false
                    crash_label[] = "Altitude below 100 km Simulation stopped"
                end

                # Rotate the Earth
                rotate_earth(earth, orbit[].time_utc[end])
                rotate_ecef_frame(x_ecef, y_ecef, z_ecef, orbit[].time_utc[end])

                sleep(1/120) # for visibility of the animation (120 fps)
            end
        end
        sleep(1/120)
    end
end

display(fig)

animation(orbit, disturbances)
