function [image, RallStatistics, points] = OurStatistics (resultImgs, maskImgs, labelImgs)
statistics=zeros(4, 1);
label=labelImgs;
label=label>0;
ourResult=resultImgs;
%ourResult1=ourResult>0;
ourResultRGB=im2uint8(ourResult);
currMask = maskImgs;
currMask = currMask > 0;
if size(currMask, 3) == 3
    currMask = rgb2gray(currMask);
end
%ourResult3(~currMask(:))=0; 
TP=sum(label(currMask(:))==1 & ourResult(currMask(:))==1);
FP=sum(label(currMask(:))==0 & ourResult(currMask(:))==1);
FN=sum(label(currMask(:))==1 & ourResult(currMask(:))==0);
TN=sum(label(currMask(:))==0 & ourResult(currMask(:))==0);
% TP=sum(label()==1 & ourResult()==1);
% FP=sum(label()==0 & ourResult()==1);
% FN=sum(label()==1 & ourResult()==0);
% TN=sum(label()==0 & ourResult()==0);
statistics(1)=TP;
statistics(2)=FP;
statistics(3)=FN;
statistics(4)=TN;
%false positive -> red
[i1,j1] = find(ourResult);
for n=1:length(i1)
    i=i1(n);
    j=j1(n);
    if(label(i,j)==0)
        ourResultRGB(i,j,1)=255;
        ourResultRGB(i,j,2)=0;
        ourResultRGB(i,j,3)=0;
    end
end
%true positive -> white
for n=1:length(i1)
    i=i1(n);
    j=j1(n);
    if(label(i,j)==1)
        ourResultRGB(i,j,1)=255;
        ourResultRGB(i,j,2)=255;
        ourResultRGB(i,j,3)=255;
    end
end
%false negative -> blue
[i1,j1] = find(label);
for n=1:length(i1)
    i=i1(n);
    j=j1(n);
    if(ourResult(i,j)==0)
        ourResultRGB(i,j,1)=0;
        ourResultRGB(i,j,2)=0;
        ourResultRGB(i,j,3)=255;
    end
end
%figure, imshow(ourResultRGB);

%     imwrite(ourResultRGB, 'result2_21_colored.png');
%Sensitivity=TP/(TP+FN) ;
%Specificity=TN/( TN+FP);
%PPV=TP/(TP+FP);
%  F=2*Sensitivity*PPV/(Sensitivity+PPV)
% Accuracy=(TP+TN)/(TP+TN+FP+FN);


% totalValues=sum(statistics); 
totalValues=statistics;
Sens=totalValues(1)/(totalValues(1)+totalValues(3)); %truepositive/(truepositive + falsenegative)
Spec=totalValues(4)/(totalValues(4)+totalValues(2)); %truenegative/(truenegative + falsepositive)
PPV=totalValues(1)/(totalValues(1)+totalValues(2)); %truepositive/(truepositive + falsepositive)
F=2*Sens*PPV/(Sens+PPV);
Acc=(totalValues(1)+totalValues(4))/sum(totalValues(:));
allStatistics = zeros(5, 1);
allStatistics(1) = Sens;
allStatistics(2) = Spec;
allStatistics(3) = PPV;
allStatistics(4) = F;
allStatistics(5) = Acc;
image = ourResultRGB;
RallStatistics = allStatistics;
points = zeros(4, 1);
allpoints = sum(statistics);
points(1) = statistics(1);
points(2) = statistics(2);
points(3) = statistics(3);
points(4) = statistics(4);
for i=1:size(RallStatistics)
    RallStatistics(i) = RallStatistics(i)*100;
end
end




