function distance = dist(X, mini, maxi)
    % Ponto medio
    mid = (maxi + mini)/2;
    % Raio
    R = (maxi - mini)/2;
   
    diff = abs(X - mid) - R;
    % Atributo com maior valor
    distance = max(diff);
end

