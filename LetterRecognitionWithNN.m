p = [];
cd('C:/MatlabFontTrainingData');
D = dir('*.png');
NumberOfDimentionOfLetterPic = 10;
for i = 1:numel(D)
    image= imread(D(i).name);
    image = imresize(image, [NumberOfDimentionOfLetterPic NumberOfDimentionOfLetterPic]);
    gray = rgb2gray(image);
    binary = im2bw(gray,graythresh(gray));
    binary = reshape(binary,[],1);
    p = [p binary];
end
% Perceptron Network

numberOfLettersWeLearn = 2;
numberOfTrainDataForEeachLetter = 1;

t = zeros(ceil(numberOfLettersWeLearn/2),numberOfLettersWeLearn*numberOfTrainDataForEeachLetter);
temp = 0:(numberOfLettersWeLearn-1);
temp = fliplr(de2bi(temp))';
for i=0:numberOfLettersWeLearn-1 
    t(:,(i*numberOfTrainDataForEeachLetter)+1:(i*numberOfTrainDataForEeachLetter)+numberOfTrainDataForEeachLetter) = repmat(temp(:,i+1),1,numberOfTrainDataForEeachLetter);
end

%(ceil(numberOfLettersWeLearn/2)) * (numberOfLettersWeLearn*numberOfTrainDataForEeachLetter)
W = zeros(ceil(numberOfLettersWeLearn/2),NumberOfDimentionOfLetterPic^2);
b = zeros(ceil(numberOfLettersWeLearn/2),1);
% 1.Training
[r, column]=size(p);
correctAnswerCounter = 0;
%for i=0:c %should be While
i = 0;
while(correctAnswerCounter ~= column)
    %if(correctAnswerCounter ~= c)
        a = hardlim(W*p(:,i+1) + b);
        e = t(:,i+1) - a;
        
        if(e == 0)
            correctAnswerCounter = correctAnswerCounter + 1;
        else
            correctAnswerCounter = 0;
        end
        
        W = W + e*p(:,i+1)';
        b = b + e;
        
        i = i + 1;
        i = rem(i,column);
    %end
end
% 1.Testing
cd('C:/MatlabFontTestData');
D = dir('*.png');
pTest = [];
for i = 1:numel(D)
    image= imread(D(i).name);
    image = imresize(image, [NumberOfDimentionOfLetterPic NumberOfDimentionOfLetterPic]);
    gray = rgb2gray(image);
    binary = im2bw(gray,graythresh(gray));
    binary = reshape(binary,[],1);
    pTest = [pTest binary];
end
b = repmat(b,1,numel(D));
a = hardlim(W*pTest + b);
