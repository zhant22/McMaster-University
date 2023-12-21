% Define the calculate_dtft function
function output_dtft = calculate_dtft(x, w)
    n = -ceil((length(x)-1)/2):floor((length(x)-1)/2);
    output_dtft = zeros(size(w)); % init the output 
    for k = 1:length(w)
        output_dtft(k) = sum(x .* exp(-1i * w(k) * n));
    end
end
