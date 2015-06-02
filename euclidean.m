function y = euclidean(X,Y)
	som = 0;
	% Para todos os atributos numéricos
	for i = 1:size(X,2)
        % distância
        resp = (X(i) - Y(i))^2;
        som = som + resp;
	end
	y = sqrt(som);
end
