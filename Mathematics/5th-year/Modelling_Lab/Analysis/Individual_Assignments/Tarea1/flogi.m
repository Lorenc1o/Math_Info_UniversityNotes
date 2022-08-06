function logi = flogi(x,r,K)
    logi = (-exp(r*(x-1817))*K*29981336)/(((1-exp(r*(x-1817)))*29981336-K));
end