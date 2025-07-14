using OrdinaryDiffEq

const G = 9.81      # acceleration due to gravity, in m/s^2
const L1 = 1.0     # length of pendulum 1 in m
const L2 = 1.0     # length of pendulum 2 in m
const L = L1 + L2  # maximal length of the combined pendulum
const M1 = 1.0     # mass of pendulum 1 in kg
const M2 = 1.0     # mass of pendulum 2 in kg
const t_stop = 10   # how many seconds to simulate
const dt = 0.01

function pendulum!(du, u, p, t)
    (; M1, M2, L1, L2, G) = p

    du[1] = u[2]

    delta = u[3] - u[1]
    den1 = (M1 + M2) * L1 - M2 * L1 * cos(delta) * cos(delta)
    du[2] = (
        (
            M2 * L1 * u[2] * u[2] * sin(delta) * cos(delta) +
                M2 * G * sin(u[3]) * cos(delta) +
                M2 * L2 * u[4] * u[4] * sin(delta) - (M1 + M2) * G * sin(u[1])
        ) / den1
    )

    du[3] = u[4]

    den2 = (L2 / L1) * den1
    du[4] = (
        (
            -M2 * L2 * u[4] * u[4] * sin(delta) * cos(delta) +
                (M1 + M2) * G * sin(u[1]) * cos(delta) -
                (M1 + M2) * L1 * u[2] * u[2] * sin(delta) - (M1 + M2) * G * sin(u[3])
        ) / den2
    )
    return nothing
end

function trajectory(t1::Float64, t2::Float64)
    p = (; M1, M2, L1, L2, G)
    u0 = [t1, 0, t2, 0]
    prob = ODEProblem(pendulum!, u0, (0.0, t_stop), p)
    return solve(prob, Tsit5(), adaptive = false, dt = dt)
end

using IterTools
gridsize = 75
initial_angles = IterTools.product(LinRange(-π, π, gridsize), LinRange(-π, π, gridsize)) |> collect |> Base.Fix2(getindex, Colon())

data = zeros(length(initial_angles), length(0:dt:t_stop), 2)

for i in eachindex(initial_angles)
    if (i % 100 == 0)
        @show i
    end
    t1, t2 = initial_angles[i]
    sol = trajectory(t1, t2)
    data[i, :, 1] = hcat(sol.u...)[1, :]  # θ₁
    data[i, :, 2] = hcat(sol.u...)[3, :]  # θ₂
end

using JLD2
jldsave("double_pendulum_data.jld2"; data)
