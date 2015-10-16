# Toms566

[![Build Status](https://travis-ci.org/mpf/Toms566.jl.svg?branch=master)](https://travis-ci.org/dpo/AMD.jl)


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

# Summary
```
julia> Pkg.test("Toms566")
INFO: Testing Toms566
No.  Name                             n        f(x0)     |∇f(x0)| cond(∇²f(x0))
  1  Hellical valley                  3     2.50e+03     1.88e+03     9.82e+00
  2  Bigg's EXP6                      6     7.79e-01     2.55e+00     1.30e+01
  3  Gaussian                         3     3.89e-06     7.45e-03     5.10e+01
  4  Powell                           2     1.14e+00     2.00e+04     1.37e+08
  5  Box 3-dim                        3     1.03e+03     1.49e+02     1.19e+02
  6  Variably dimensioned            40     9.39e+10     1.01e+11     1.65e+04
  7  Watson                           9     3.00e+01     1.78e+02     1.63e+02
  8  Penalty I                       60     5.45e+09     8.02e+07     4.24e+00
  9  Penalty II                      65     2.87e+05     3.28e+05     9.84e+01
 10  Brown badly scaled               2     1.00e+12     2.00e+06     1.00e+00
 11  Brown and Denis                  4     7.93e+06     2.14e+06     6.93e+02
 12  Gulf research and development    3     1.21e+01     3.97e+01     4.65e+04
 13  Trigonometric                   40     2.01e-03     5.30e-02     1.57e+02
 14  Extended rosenbrock             40     4.84e+02     1.04e+03     9.90e+01
 15  Extended Powell singular        60     3.23e+03     1.78e+03     2.27e+01
 16  Beale                            2     1.42e+01     2.78e+01     7.97e+00
 17  Wood                             4     1.92e+04     1.64e+04     1.69e+02
 18  Chebyquad                       50     1.39e-02     2.65e+00     6.30e+02
 INFO: Toms566 tests passed
```
