using ModelingToolkit
using ModelingToolkitDeriv

@IVar t;
D(x -> x^2)(t)

D(D(x -> x^2))(t)

D(D(x -> log(x)))(t)


D(t -> 1/t)(t)

