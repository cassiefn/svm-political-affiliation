%% authors: cnoble and dkelly
%% use svm to predict political affiliation and analyze efficacy of model

% Load file as table
survey = importfile('data/survey2.csv',[2, Inf]);

% Drop all political affiliations that are not Democrat or Republican
conds = survey.y ~= 'Democrat' & survey.y ~='Republican';
survey(conds, :) = [];

% Response
Y = survey.y;

% Prediction Matrix
X = survey(:,2:end);

ds = table2dataset(survey);
[nrows, ncols] = size(ds);
names = ds.Properties.VarNames;

category = false(1,ncols);
for i = 1:ncols
    if isa(ds.(names{i}),'categorical')
        category(i) = true;
        ds.(names{i}) = nominal(ds.(names{i}));
    end
end
% Logical array keeping track of categorical attributes
catPred = category(2:end);
% Set the random number seed to make the results repeatable in this script
rng('default');

% summary statistics for entire data set
summary(ds)

% summary stats by political affilition
%summary(ds(ds.y=='Democrat',:))
%summary(ds(ds.y=='Republican',:))

%gscatter(ds.books,ds.transformers_movies,ds.y)
% Label the plot
%xlabel('Books Read')
%ylabel('Movies')
%title('Outcome')

% split into training and test sets
cv = cvpartition(size(ds,1),'HoldOut', 0.2);
trainX = X(cv.training,:);
testX = X(cv.test,:);
trainY = Y(cv.training,:);
testY = Y(cv.test,:);

% train svm
svm = fitcsvm(trainX, trainY, 'Standardize', true);
trainPredicted = predict(svm, trainX);
trainAccuracy = sum(trainPredicted == trainY)/size(trainY, 1)

% test svm
[testPredicted, probClass] = predict(svm, testX);
correct = ds(testPredicted == testY,:);
incorrect = ds(testPredicted ~= testY,:);
testAccuracy = sum(testPredicted == testY)/size(testY, 1)

% which data points are most important? all are weighted fairly equally
ws = categorical(svm.W);
summary(ws)

% most extremely predicted democrat
[maxDem, maxDemInd] = max(probClass(:,1));
% correctly classified
actualClassMostExtremeDem = testY(maxDemInd,:)
mostExtremePredDem = testX(maxDemInd,:)

% most extremely predicted republican
[maxRep, maxRepInd] = max(probClass(:,2));
% correctly classified
actualClassMostExtremeRep = testY(maxRepInd,:)
mostExtremePredRep = testX(maxRepInd,:)

% most conservatively predicted democrat
[minDem, minDemInd] = min(abs(probClass(:,1)));
% incorrectly classified
actualClassLeastExtremeDem = testY(minDemInd,:)
leastExtremePredDem = testX(minDemInd,:)

% most conservatively predicted republican
[minRep, minRepInd] = min(abs(probClass(:,2)));
% correctly classified
actualClassLeastExtremeRep = testY(minRepInd,:)
leastExtremePredRep = testX(minRepInd,:)

% summary stats by correctly vs. incorrectly classifed
%summary(correct)
%summary(incorrect)

% summary stats for incorrectly classifed political affilitions
%summary(incorrect(incorrect.y=='Democrat',:))
%summary(incorrect(incorrect.y=='Republican',:))

% summary stats for incorrectly classifed political affilitions
%summary(correct(correct.y=='Democrat',:))
%summary(correct(correct.y=='Republican',:))
