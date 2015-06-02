%%{
% IMPORTACAO E PRE-PROCESSAMENTO DOS DADOS
clear all;

%importIris;
%importWine;
importZoo;
%mportSonar;

[m,n] = size(data);
%data = data(randperm(m),:);

% K-FOLD CROSS VALIDATION
k = 10;
kFolds = kFoldCrossValidation(data,k);
%}

% DIVISAO DOS DADOS ANTIGA
%{
% Desordenando a base e criando os conjuntos de treinamento e teste (70% 
% e 30% de toda base importada, respectivamente).
mixedRows = data(randperm(m),:);

trainingSet = mixedRows(1:floor(m*0.7),:);
testSet = mixedRows(ceil(m*0.7):end,:);
%}

% Taxas de acerto em cada iteracao
TETAS = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
TETAResults = zeros(10,10);
BERs = zeros(10,10);
InstanceReductions = zeros(10,10);

% Para todas as K configurações de conjuntos
folds = 1:k;
for i = folds
    % Conjunto de treinamento será formado por todos os folds restantes
    trainingSet = [];
    for j = folds(folds~=i)
        trainingSet = [trainingSet ; kFolds(j).fold];
    end
    % Desordenando o conjunto de treinamento 
    trainingSet = trainingSet(randperm(size(trainingSet,1)),:);
    
        % calcula o range pra cada coluna
    ranges = [];
    for j = 1:(size(trainingSet,2)-1)
        Maxi = max(trainingSet(:,j));
        Mini = min(trainingSet(:,j));
        ranges = [ranges ; [(Maxi - Mini), Mini] ];
    end

    for j = 1:size(trainingSet,2)-1
        trainingSet(:,j) = (trainingSet(:,j) - ranges(j,2))/ranges(j,1);
    end
    
    % Conjunto de teste será o k-esimo fold
    testSet = kFolds(i).fold;
    
    for j = 1:size(testSet,2)-1
        testSet(:,j) = (testSet(:,j) - ranges(j,2))/ranges(j,1);
    end
    
    % ALGORITMO PROPOSTO
    % Gerado um conjunto de protótipos pelo IRAHC
    for TETA = TETAS
    
        S = IRAHC(trainingSet,TETA);
        %S = ENN(trainingSet);

        % TESTE DO KNN SOBRE S
        [result,BER] = TestKNN(S,testSet);
        
        TETAResults(i,TETA == TETAS) =  result;
       
        reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
        InstanceReductions(i,TETA == TETAS) = reduction;
        
        BERs(i,TETA == TETAS) = BER;

    end
end

% Mostra a taxa de acerto media considerando as k iteracoes
accuracy = mean(TETAResults);

disp('Error Rate');
Errs = 100 - accuracy;
disp('    TETA     ERR');
disp([TETAS',Errs']);

IR = mean(InstanceReductions)';
disp('Reduction Percentage');
disp('    TETA     IR');
disp([TETAS',IR]);

ber = mean(BERs)';
disp('Balance Error Rate');
disp('    TETA      BER');
disp([TETAS',ber]);


