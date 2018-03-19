using ModelingToolkit
using ModelingToolkitDeriv

@IVar t;
D(x -> x^2)(t)

D(D(x -> x^2))(t)

D(x -> log(x)^2)(t)


D(t -> 1/t)(t)

Pkg.update()
