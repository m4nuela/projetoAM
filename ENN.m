function S = ENN(trainingSet)
    % Ao inv�s de iniciar S = T, estou
    % iniciando ele vazio, e marcando os vetores de T que deveriam ser
    % removidos de S, para que n�o sejam considerados no FOR abaixo. 
    % No final, S ser� formado pelos vetores de T n�o marcados, ou seja, 
    % "nao removidos".
    
    S = [];
    % declarando array que marca as inst�ncias removidas
    marked = zeros(size(trainingSet,1),1);
    
    for j = 1:size(trainingSet,1)
        % Se a inst�ncia atual n�o estiver marcada
        if (~marked(j))
          % Pega o vizinho mais pr�ximo da inst�ncia, sobre o conjunto de
          % treinamento.
          [~,~,class_max] = KNN(trainingSet(j,1:end-1),trainingSet,1);
          % Marca-o, caso sua classe seja diferente da inst�ncia atual
          if(trainingSet(j,end) ~= class_max)
              marked(j) = 1;
          end
        end
    end
    
    % S ser� formado por todas as entradas do conjunto de treinamento
    % n�o marcadas
    for j = 1:size(marked)
       if ~marked(j)
           S = [S; trainingSet(j,:)];
       end
    end
    
end
