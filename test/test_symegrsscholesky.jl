include("spline_kernel.jl")

# Removing t = 0, such that Σ is invertible
t = Vector(0.1:0.1:1)
n = length(t);

# Defining relevant parameters
p = 2;
U, V = spline_kernel(t, p);
Σ    = spline_kernel_matrix(U, V);
chol = cholesky(Σ)

K  = SymEGRSSMatrix(U,V)
Km = SymEGRSSCholesky(K)

xt = randn(n,1);
@test isapprox(Km'\(Km\xt), chol.U\(chol.L\xt), atol=1e-6)
@test isapprox(inv(Km), chol.U\(chol.L\Diagonal(ones(K.n))), atol=1e-6)
@test isapprox(inv(Km,xt),  chol.U\(chol.L\xt), atol=1e-6)
@test isapprox(Km*xt, chol.L*xt, atol=1e-6)
@test isapprox(Km'*xt, chol.U*xt, atol=1e-6)

# Testing logdet
@test isapprox(logdet(Km), logdet(chol.L), atol=1e-10)
@test isapprox(logdet(Km'), logdet(chol.U), atol=1e-10)
