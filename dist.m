function distance = dist(X, mini, maxi)
    mid = (maxi + mini)/2;
    
    R = (maxi - mini)/2;
    
    diff = (X - mid) - R;
    
    distance = max(diff);
end

