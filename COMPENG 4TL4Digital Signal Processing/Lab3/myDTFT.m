function output_dtft = myDTFT(x, qw)
    n = -ceil((length(x)-1)/2):floor((length(x)-1)/2);
    output_dtft = zeros(size(qw));
    for k = 1:length(qw)
        output_dtft(k) = sum(x .* exp(-1i * qw(k) * n));
    end
end