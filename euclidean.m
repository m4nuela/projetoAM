function y = euclidean(X,Y)
	som = 0;
	% Para todos os atributos numericos
	for i = 1:size(X,2)
        % distancia entre X e Y
        resp = (X(i) - Y(i))^2;
        som = som + resp;
	end
	y = sqrt(som);
end
