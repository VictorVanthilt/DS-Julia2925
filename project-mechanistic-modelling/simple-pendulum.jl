using OrdinaryDiffEq, ModelingToolkit, Symbolics
using ModelingToolkit: t_nounits as t, D_nounits as D
# Double pendulum code stolen from the repo
@parameters m l g
@variables θ₁(t) θ₂(t) ω₁(t) ω₂(t) x₁(t) y₁(t) x₂(t) y₂(t)
l1, l2 = l, l
m1, m2 = m, m

x1 = -l1 * sin(θ₁)
y1 = -l1 * cos(θ₁)
x2 = x1 - l2 * sin(θ₂)
y2 = y1 - l2 * cos(θ₂)

T1 = 1 // 2 * m1 * (D(x1)^2 + D(y1)^2) # Kinetic energy of first mass
T2 = 1 // 2 * m2 * (D(x2)^2 + D(y2)^2) # Kinetic energy of second mass

kin_dp = T1 + T2 |> expand_derivatives |> simplify
pot_dp = m1 * g * y1 + m2 * g * y2
Ldp = kin_dp - pot_dp  # Lagrangian

# E-L equations of motion
Dω₂ = Differential(ω₂)
Dθ1 = Differential(θ₁)
Dθ̇1 = Differential(D(θ₁))
Dθ2 = Differential(θ₂)
Dθ̇2 = Differential(D(θ₂))

sys_dp = [expand_derivatives(D(Dθ̇1(Ldp)) - Dθ1(Ldp)) ~ 0, expand_derivatives(D(Dθ̇2(Ldp)) - Dθ2(Ldp)) ~ 0]
E1, E2 = symbolic_linear_solve(sys_dp, [D(D(θ₁)), D(D(θ₂))]) .|> simplify

# build the system
@mtkbuild double_pend = ODESystem(
    [
        D(D(θ₁)) ~ E1,
        D(D(θ₂)) ~ E2,
        x₁ ~ x1, y₁ ~ y1, x₂ ~ x2, y₂ ~ y2,
    ], t
)

θ1′_0 = 0
θ2′_0 = 0
θ1_0 = π / 4
θ2_0 = π / 4

tsteps = 0:0.01:1.0
@elapsed pend_dp = ODEProblem(double_pend, [θ₁ => θ1_0, D(θ₁) => θ1′_0, θ₂ => θ2_0, D(θ₂) => θ2′_0], extrema(tsteps), [g => 9.81, l => 0.5, m => 0.1])

function trajectory(t1::Float64, t2::Float64)
    pend_dp = ODEProblem(double_pend, [θ₁ => t1, D(θ₁) => θ1′_0, θ₂ => t2, D(θ₂) => θ2′_0], extrema(tsteps), [g => 9.81, l => 0.5, m => 0.1])
    return solve(pend_dp, adaptive = false, dt = 0.01)
end
trajectory(0.0, 0.2)

using IterTools
gridsize = 25
initial_angles = IterTools.product(LinRange(0.0, π, gridsize), LinRange(0.0, π, gridsize)) |> collect |> Base.Fix2(getindex, Colon())

data = zeros(length(initial_angles), length(0:0.01:1), 2)

for i in eachindex(initial_angles)
    t1, t2 = initial_angles[i]
    sol = trajectory(t1, t2)
    data[i, :, 1] = hcat(sol.u...)[1, :]
    data[i, :, 2] = hcat(sol.u...)[2, :]
end

data
