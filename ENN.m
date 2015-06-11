function S = ENN(trainingSet)
    % Ao invés de iniciar S = T, estou
    % iniciando ele vazio, e marcando os vetores de T que deveriam ser
    % removidos de S, para que não sejam considerados no FOR abaixo. 
    % No final, S será formado pelos vetores de T não marcados, ou seja, 
    % "nao removidos".
    
    S = [];
    % declarando array que marca as instâncias removidas
    marked = zeros(size(trainingSet,1),1);
    
    for j = 1:size(trainingSet,1)
        % Se a instância atual não estiver marcada
        if (~marked(j))
          % Pega o vizinho mais próximo da instância, sobre o conjunto de
          % treinamento.
          [~,~,class_max] = KNN(trainingSet(j,1:end-1),trainingSet,1);
          % Marca-o, caso sua classe seja diferente da instância atual
          if(trainingSet(j,end) ~= class_max)
              marked(j) = 1;
          end
        end
    end
    
    % S será formado por todas as entradas do conjunto de treinamento
    % não marcadas
    for j = 1:size(marked)
       if ~marked(j)
           S = [S; trainingSet(j,:)];
       end
    end
    
end
