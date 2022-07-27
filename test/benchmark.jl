using EconomicScenarioGenerators
using Random
using BenchmarkTools
using ThreadsX

m = BlackScholesMerton(0.01,0.02,.15,100.)
s = ScenarioGenerator(1/252,1.,m,Random.Xoshiro(123))
n = 10_000

function f(s)
    [collect(s) for _ in 1:n]
end

function f_threaded(s)
    ThreadsX.map(1:n) do _
        collect(s)
    end
end

function f_pre_allocated!(z,s)
    for v in z
        copyto!(v,s)
    end
end

function f_pre_allocated_threaded!(z,s)
    Threads.@threads for v in z
        copyto!(v,s)
    end
end

@btime f($s)
@btime f_threaded($s)
@btime f_pre_allocated!(zc,$s) setup=(zc = [zeros(253) for _ in 1:n])
@btime f_pre_allocated_threaded!(zc,$s) setup=(zc = [zeros(253) for _ in 1:n])