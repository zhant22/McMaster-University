%a
function X = myDFT(x)
    N = length(x);
    k = 0:N-1;
    n = k';
    W = exp(-1i * 2 * pi * n * k / N);
    X = W * x(:);
end