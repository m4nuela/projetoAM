
clear all;

importIris;

% Desordenando a base e criando os conjuntos de treinamento e teste (70% e
% 30% de toda base importada, respectivamente).
[m,n] = size(data);
mixedRows = data(randperm(m),:);
trainingSet = mixedRows(1:floor(m*0.7),:);
testSet = mixedRows(ceil(m*0.7):end,:);

% Calcula o range pra cada coluna do conjunto de treinamento
ranges = zeros((size(trainingSet,2)-1),2);
for j = 1:(size(trainingSet,2)-1)
    Maxi = max(trainingSet(:,j));
    Mini = min(trainingSet(:,j));
    ranges(j,:) = [(Maxi - Mini), Mini];
end

% Normaliza o conjunto de treinamento
for j = 1:size(trainingSet,2)-1
    trainingSet(:,j) = (trainingSet(:,j) - ranges(j,2))/ranges(j,1);
end

% Normaliza o conjunto de teste
for j = 1:size(testSet,2)-1
    testSet(:,j) = (testSet(:,j) - ranges(j,2))/ranges(j,1);
end

disp('Seleção de protótipos: ATISA2');
S = ATISA2(trainingSet);
disp('Quantidade de protótipos: ');
disp(size(S,1));

disp('Teste do KNN');
[result, ~] = TestKNN(S,testSet);
disp('Precisão')
disp(result);




  