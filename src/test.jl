using ModelingToolkit
using ModelingToolkitDeriv

@IVar t;
D(x -> x^2)(t)

D(D(x -> x^2))(t)

D(D(x -> log(x)))(t)


D(t -> 1/t)(t)

D(x-> sin(x))(t)

Base.sin(x::ModelingToolkitDeriv.Differential) = ModelingToolkitDeriv.unaryOp(sin, cos)(x)

