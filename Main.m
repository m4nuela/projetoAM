%%{
% IMPORTACAO E PRE-PROCESSAMENTO DOS DADOS
clear all;

importIris;
%importWine;
%importZoo;
%importSonar;

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
Results = [];
BERs = [];
InstanceReductions = [];

% Para todas as K configurações de conjuntos
folds = 1:k;
for i = folds
    % Conjunto de teste será o k-esimo fold
    testSet = kFolds(i).fold;
    
    % Conjunto de treinamento será formado por todos os folds restantes
    trainingSet = [];
    for j = folds(folds~=i)
        trainingSet = [trainingSet ; kFolds(j).fold];
    end
    % Desordenando o conjunto de treinamento 
    trainingSet = trainingSet(randperm(size(trainingSet,1)),:);
    
    % ALGORITMO PROPOSTO
    % Gerado um conjunto de protótipos pelo IRAHC
    
    S = IRAHC(trainingSet);
    %S = ENN(trainingSet);
    
    % TESTE DO KNN SOBRE S
    [result,BER] = TestKNN(S,testSet);
    disp('K-Fold:');
    disp(i);
    disp('   Precisão');
    disp(result);
    
    Results = [Results ; result];
    BERs = [BERs; BER];
    
    reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
    InstanceReductions = [InstanceReductions; reduction];
    
end

% Mostra a taxa de acerto media considerando as k iteracoes
accuracy = mean(Results);
disp('Accuraty Rate');
disp(accuracy);

disp('Error Rate - Err');
disp(100 - accuracy);

IR = mean(InstanceReductions);
disp('Reduction Percentage - IR');
disp(IR);


IR = mean(BERs);
disp('Balance Error Rate  - BER');
disp(IR);


