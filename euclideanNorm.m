function y = euclideanNorm(X,Y,ranges)
	som = 0;
	% Para todos os atributos numéricos
	for i = 1:size(X,2)
        % Se o range n�o for igual a 0
        if (ranges(i) ~= 0)
        	% distância normalizada
            resp = ((X(i) - Y(i))/ranges(i))^2;
            som = som + resp;
        end
	end
	y = sqrt(som);
end
