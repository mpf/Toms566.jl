using Toms566
using Base.Test

@printf("%3s  %-30s %3s %12s\n","No.","Name","n","f(x0)")
for i=1:18
    p = Problem(i)
    @printf("%3i  %-30s %3i %12.2e\n",
            i, p.name, p.n, p.obj(p.x0))
end
