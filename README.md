# ModellingToolkitDeriv
Package for taking derivatives on ModellingToolkit Operations using automatic differentiation in the expression tree

## Examples:
```julia
julia> using ModelingToolkit, ModelingToolkitDeriv

julia> @IVar t; 

julia> f(t) = t^2;
```
To take the derivative of `f` with repsect to `t`, we simply call the `D` operator on `f` and evaluate the resulting function at a `t` of our choosing
```julia
julia> D(f)(t)
0 + (2 * (t + 0) ^ 1) * 1
```
which after some simplification is equivalent to `2*t`.

This system has the product rule and chain rule built in

```julia
julia> D(t -> f(t) + t)(t)
(0 + (2 * (t + 0) ^ 1) * 1) + 1

julia> D(t -> f(t)*t)(t)
((0 + ((t + 0) ^ 2 + 0) * 1) + (0 + (2 * (t + 0) ^ 1) * 1) * (t + 0)) + 0

julia> D(t -> log(t)^2)(t)
0 + (2 * (log(t + 0) + 0) ^ 1) * (0 + (1 / (t + 0)) * 1)
```

and avoids perturbation confusion (allowing it to take higher derivatives)
```julia
julia> D(D(f))(t)
0 + (0 + (2 * (0 + (1 * ((t + 0) + 0) ^ 0) * 1)) * 1)

julia> D(D(x -> log(x)))(t)
0 + (0 + (0 + (-1 / ((t + 0) + 0) ^ 2) * 1) * 1)
```

Adding new functions to take derivatives of is simple. For instance, currently trig functions are not supported. To support them, simply define methods so they know how to accept `Differential` arguments using the `unaryOp` or `binaryOp` functions respectively

```julia
julia> D(x-> sin(x))(t)
ERROR: MethodError: no method matching sin(::ModelingToolkitDeriv.Differential)

julia> Base.sin(x::Differential) = unaryOp(sin, cos)(x)

julia> D(x-> sin(x))(t)
0 + cos(t + 0) * 1)(x)
```

