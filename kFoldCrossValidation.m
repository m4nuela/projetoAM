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
        maxFold = max(1,floor(qnt/k));
        % Resto da divisao
        modi = mod(qnt,k);
        % Instancias do banco de dados da classe i
        iSamples = data(map == i,:);
        % Sera o indice do primeiro elemento de iSamples a ser inserido em
        % cada fold
        first = 1;
        
        % Para todas as particoes
        for j = 1:k
            if (j < k && j < qnt)
                % Insere maxFold padroes no fold atual, a partir de first
                kFolds(j).fold = [kFolds(j).fold ; iSamples(first:(first+maxFold-1),:)];
                % O proximo inicio sera a proxima instancia da classe i nao
                % utilizada, garantindo que os conjuntos serão disjuntos
                first = first + maxFold;
            else
                % Chegando ao ultimo fold possivel
                kFolds(j).fold = [kFolds(j).fold ; iSamples(first:(first+maxFold-1),:)]; 
                first = first + maxFold;
                % Se chegou ao fim, e sobraram instancias
                if (j == k && modi > 0)
                    % Distribui sobre os outros folds
                    for l = 1:modi
                       kFolds(l).fold = [kFolds(l).fold ; iSamples(first,:)]; 
                       first = first + 1;
                    end
                end
                break;
            end
        end
    end
end

