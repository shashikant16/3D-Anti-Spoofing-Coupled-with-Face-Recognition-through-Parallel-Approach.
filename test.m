load dbs
db=dir('*.png');
n= ceil(sqrt(length(db)));
F=[];
for(i=1:length(db))
    im=imread(db(i).name);
     im=imresize(im,[256 256]);
    f=lbp_sir(rgb2gray(im));
    F=[F;f];
    title(num2str(classes(i)));
end
Im2=imresize(Im2,[256 256]);
ftest=lbp_sir(Im2);
D=abs(F-ftest);
score=Inf;
match=-1;
for(i=1:length(db))
    s=sum(D(i,:));
    if(s<score)
        match=i;
        score=s;
    end
end
detected=class(match);
fname=db(detected).name;
axes(handles.axes3);
imshow(imread(fname));
title(strcat('detected class is:',num2str(detected)));