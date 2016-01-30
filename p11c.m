clear;
[a, b, c, data] = arffread('./spambase.arff');
rng(1);
randindex = randperm(size(data, 1));
traindata = data(randindex(1:floor(size(data,1)/2)), :);
testdata = data(randindex(floor(size(data,1)/2):size(data,1)), :);
Cond1 = traindata(:,end) == 1;
Cond2 = traindata(:,end) == 0;
trspam = traindata(Cond1, 1:end-1);
trnonspam = traindata(Cond2, 1:end-1);
pspam = size(trspam, 1) / size(traindata, 1);
pnonspam = size(trnonspam, 1) / size(traindata, 1);
uspam = mean(trspam);
varspam = var(trspam);
unonspam = mean(trnonspam);
varnonspam = var(trnonspam);
threshold = 0;
precision = zeros(1, 50);
recall = zeros(1, 50);
for i = 1 : 50
    tp = 0;
    tn = 0;
    fp = 0;
    fn = 0;
    for j = 1 : size(testdata, 1);
        ppositive = 1;
        pnegative = 1;
        for k = 1 : size(testdata, 2)-1
            ppositive = ppositive * 1/sqrt(2*pi*varspam(k))*exp(-(testdata(j,k)-uspam(k))^2/(2*varspam(k)));
            pnegative = pnegative * 1/sqrt(2*pi*varnonspam(k))*exp(-(testdata(j,k)-unonspam(k))^2/(2*varnonspam(k)));
        end
        pinfer = ppositive * pspam / (ppositive*pspam + pnegative*pnonspam);
        if pinfer > threshold % identified as positive, spam
            if testdata(j, end) == 1 % tp
                tp = tp + 1;
            else % fp
                fp = fp + 1;
            end
        else 
            if testdata(j, end) == 1 % fn
                fn = fn + 1;
            else % tn
                tn = tn + 1;
            end
        end
    end
    precision(i) = tp / (tp + fp);
    recall(i) = tp / (tp + fn);
    threshold = threshold + 0.02;
end
plot(precision, recall);