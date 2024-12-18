function get_he_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[1] * 1e6
end

function get_o_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[2] * 1e6
end

function get_n2_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[3] * 1e6
end

function get_o2_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[4] * 1e6
end

function get_ar_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[5] * 1e6
end

function get_total_mass_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[6] * 1e3
end

function get_h_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[7] * 1e6
end

function get_n_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[8] * 1e6
end

function get_anomalous_o_density(atmosphere_data::Vector{Float64})
    return atmosphere_data[9] * 1e6
end

function get_exo_temperature(atmosphere_data::Vector{Float64})
    return atmosphere_data[10]
end

function get_temperature(atmosphere_data::Vector{Float64})
    return atmosphere_data[11]
end