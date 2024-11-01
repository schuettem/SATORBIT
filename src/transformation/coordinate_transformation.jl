"""
    transform coes (classical orbital elements) to rv (position and velocity) in the inertial frame
"""
function coes2eci(orbit::COES, μ::Float64)
    a = orbit.a # semi-major axis
    e = orbit.e # eccentricity
    i = deg2rad(orbit.i) # inclination
    Ω = deg2rad(orbit.Ω) # right ascension of the ascending node
    ω = deg2rad(orbit.ω) # argument of periapsis
    f = deg2rad(orbit.f) # true anomaly

    p = a * (1 - e^2) # semi-latus rectum
    r = p / (1 + e * cos(f)) # distance from the central body
    v = sqrt(μ * (2/r - 1/a))

    r_pqw = [r * cos(f), r * sin(f), 0.0] # position in the perifocal frame
    v_pqw = [-v * sin(f), v * (e + cos(f)), 0.0] # velocity in the perifocal frame

    R_3_Ω = [cos(Ω) -sin(Ω) 0.0; sin(Ω) cos(Ω) 0.0; 0.0 0.0 1.0]
    R_1_i = [1.0 0.0 0.0; 0.0 cos(i) -sin(i); 0.0 sin(i) cos(i)]
    R_3_ω = [cos(ω) -sin(ω) 0.0; sin(ω) cos(ω) 0.0; 0.0 0.0 1.0]

    R_pqw_eci = R_3_Ω * R_1_i * R_3_ω

    r_eci = R_pqw_eci * r_pqw
    v_eci = R_pqw_eci * v_pqw

    return r_eci, v_eci
end

function eci2coes(r::Vector{Float64}, v::Vector{Float64}, μ::Float64)
    r_mag = norm(r)

    # specific angular momentum vector
    h = cross(r, v)
    h_mag = norm(h)

    # inclination
    i = acos(h[3] / h_mag)

    # eccentricity
    e_vec = ((norm(v)^2 - μ / r_mag) * r - dot(r, v) * v) / μ
    e = norm(e_vec)

    # pointing vector
    n = cross([0.0, 0.0, 1.0], h)
    n_mag = norm(n)

    # right ascension of the ascending node
    Ω = acos(n[1] / n_mag)
    if n[2] < 0
        Ω = 2 * π - Ω
    end

    # argument of periapsis
    ω = acos(dot(n, e_vec) / (n_mag * e))
    if e_vec[3] < 0
        ω = 2 * π - ω
    end

    # true anomaly
    f = acos(dot(e_vec, r) / (e * r_mag))
    if dot(r, v) < 0
        f = 2 * π - f
    end

    # semi-major axis
    a = r_mag * (1 + e * cos(f)) / (1 - e^2)

    return (a, e, rad2deg(i), rad2deg(Ω), rad2deg(ω), rad2deg(f))
end

"""
    transform ecef (earth-centered, earth-fixed) to geodetic coordinates
"""
function ecef2geo(r::Vector{Float64})
    r_mag, lon, lat = reclat(r)
    return rad2deg(lat), rad2deg(lon)
end

"""
    transform eci (earth-centered inertial) to ecef (earth-centered, earth-fixed)
"""
function eci2ecef(r::Vector{Float64}, time_utc::DateTime)
    R_eci_ecef = pxform("J2000", "ITRF93", utc2et(time_utc))
    r_ecef = R_eci_ecef * r
    return r_ecef
end

"""
    transform ecef (earth-centered, earth-fixed) to eci (earth-centered inertial)
"""
function ecef2eci(r::Vector{Float64}, time_utc::DateTime)
    R_ecef_eci = pxform("ITRF93", "J2000", utc2et(time_utc))
    r_eci = R_ecef_eci * r
    return r_eci
end

"""
    transform meridonal wind and zonal wind to the eci frame
    w[1]: meridional wind
    w[2]: zonal wind
"""
function wind2eci(w::Vector{Float64}, lat::Float64, lon::Float64, time_utc::DateTime)
    # Wind velocity vector in ECEF coordinates (assuming flat Earth approximation)
    w_ecef = [
        -w[2] * sin(lon) - w[1] * sin(lat) * cos(lon);
         w[2] * cos(lon) - w[1] * sin(lat) * sin(lon);
         w[1] * cos(lat)
    ]
    # Rotation matrix from ECEF to ECI
    R_ecef_eci = pxform("ITRF93", "J2000", utc2et(time_utc))
    # Transform the wind velocity vector to ECI
    w_eci = R_ecef_eci * w_ecef
    return w_eci
end
