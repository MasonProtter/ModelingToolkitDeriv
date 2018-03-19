# ModellingToolkitDeriv
Package for taking derivatives on ModellingToolkit Operations using automatic differentiation in the expression tree

## Examples:
```julia
julia> using ModelingToolkit, ModelingToolkitDeriv

julia> @IVar t; 

julia> f(t) = t^2;

julia> g(t) = log(t);
```
To take the derivative of `f` with repsect to `t`, we simply call the `D` operator on `f` and evaluate the resulting function at a `t` of our choosing
```julia
julia> D(f)(t)
0 + (2 * (t + 0) ^ 1) * 1

julia> ans |> simplify_constants
2 * t ^ 1
```
This system has the product rule and chain rule built in

```julia
julia> D(t -> f(t)*g(t))(t) |> simplify_constants
t ^ 2 * (1 / t) + (2 * t ^ 1) * log(t)

julia> D(t -> g(t)^2)(t) |> simplify_constants
(2 * log(t) ^ 1) * (1 / t)
```

and avoids perturbation confusion (allowing it to take higher derivatives)
```julia
julia> D(D(f))(t) |> simplify_constants
2 * t ^ 0

julia> D(D(g))(t) |> simplify_constants
-1 / t ^ 2
```
One can also take expoentials of the derivative operator to specify $n^\mathrm{th}$ order derivatives
```julia
julia> (D^2)(f)(t) |> simplify_constants
2 * t ^ 0

julia> (D^3)(g)(t) |> simplify_constants
(-1 / (t ^ 2) ^ 2) * (2 * t ^ 1)
```
Note: Currently due to a bug I don't understand, D^4 or higher powers seems to hang indefinitely. 


Adding new functions to take derivatives of is simple. For instance, currently trig functions are not supported. To support them, simply define methods so they know how to accept `Differential` arguments using the `unaryOp(f, dfdx)` or `binaryOp(f,dfdx,dfdy)` functions depending on the arity of the function you wish to take derivatives of.

```julia
julia> D(x-> sin(x))(t)
ERROR: MethodError: no method matching sin(::ModelingToolkitDeriv.Differential)

julia> Base.sin(x::Differential) = unaryOp(sin, cos)(x)

julia> D(x-> sin(x))(t) |> simplify_constants
cos(t)
```



