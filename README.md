# Toms566

A Julia interface to [TOMS Algorithm 566](https://dl.acm.org/citation.cfm?doid=355934.355943), which provides a suite of 18 nonlinear functions useful for testing algorithms for unconstrained optimization.

- J. J. Moré, Burton S. Garbow, and Kenneth E. Hillstrom. 1981. _Algorithm 566: FORTRAN Subroutines for Testing Unconstrained Optimization Software_. ACM Trans. Math. Softw. 7(1), March 1981, pp. 136-140

# Install
```
Pkg.add(https://github.com/mpf/Toms566.jl.git)
```

# Usage

```
using Toms566

p = Problem(1) # Hellical Valley
x = p.x0       # standard starting point
f = p.obj(x)   # objective value at x
g = p.grd(x)   # gradient at x
H = p.hes(x)   # Hessian at x
```

There are also in-place versions of the gradient and Hessian routines:

```
g = zeros(p.n)
H = zeros(p.n, p.n)
p.grd!(x, g)   # gives g = p.grd(x)
p.hes!(x, H)   # gives H = p.hes(x)
```
