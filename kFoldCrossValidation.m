function kFolds = kFoldCrossValidation(data, k)
    % Separa as classes unicas das instancias e seus indices no dataSet
    [classes,~,map] = unique(data(:,end));
    
    % Criando k folds/matrizes
    kFolds(1:k) = struct('fold', []);
    % Para cada classe, dividir em mesma proporcao os padroes para os folds
    for i = 1:size(classes,1)
        % Quantidade de padroes da classe i
        qnt = sum(map == classes(i));
        % Numero maximo de padroes desta classe em cada fold
        maxFold = round(qnt/k);
        % Instancias do banco de dados da classe i
        iSamples = data(map == i,:);
        % Sera o indice do primeiro elemento de iSamples a ser inserido em
        % cada fold
        first = 1;
        
        % Para todas as particoes
        for j = 1:k
            if(j ~= k)
                % Insere maxFold padroes no fold atual, a partir de first
                kFolds(j).fold = [kFolds(j).fold ; iSamples(first:(first+maxFold-1),:)];
                % O proximo inicio sera a proxima instancia da classe i nao
                % utilizada, garantindo que os conjuntos serão disjuntos
                first = first + maxFold;
            else
                % O ultimo fold fica com o restante dos padroes
                kFolds(j).fold = [kFolds(j).fold ; iSamples(first:end,:)];
                break;
            end
            
        end
    end
end

