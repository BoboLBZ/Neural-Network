clear
%read training image
trainNum=6000;
testNum=1000;
imagefile=fopen('train-images.idx3-ubyte','r','b');
header=fread(imagefile,1,'int32');
if header ~= 2051
    error('image file error');
end
numsofimage=fread(imagefile,1,'int32');
rows=fread(imagefile,1,'int32');
cols=fread(imagefile,1,'int32');
if trainNum>numsofimage
    error('too much train samples')
end
imgs=zeros([rows cols trainNum]);
for t=1:trainNum
    for r=1:rows
        imgs(r,:,t)=fread(imagefile,cols,'uint8');
    end
end
imgs=double(imgs)/255;
fclose(imagefile);
%read training label
labelfile=fopen('train-labels.idx1-ubyte','r','b');
header=fread(labelfile,1,'int32');
if header ~= 2049
    error('image file error');
end   
numsoflabel=fread(labelfile,1,'int32');
if trainNum>numsoflabel
    error('too much train samples')
end
labels=fread(labelfile,trainNum,'uint8');
fclose(labelfile);

%training
nb=cols*rows;
ni=400;
nj=50;
nk=10;
wkj=randn(nk,nj+1);
wkj_tmp=wkj;
wji=randn(nj,ni+1);
wji_tmp=wji;
wib=randn(ni,nb+1);

ob=zeros(nb+1,1);
si=zeros(ni,1);
oi=zeros(ni+1,1);
sj=zeros(nj,1);
oj=zeros(nj+1,1);
sk=zeros(nk,1);
ok=sk;
dk=sk;

lowerlimit=0.01;
itermax=400;
eta=0.25;

iter=0;
error_avg=10;

deltak=zeros(1,nk);
deltaj=zeros(1,nj);
deltai=zeros(1,ni);
sumbackkj =zeros(1,nj);
sumbackji =zeros(1,ni);

while (error_avg >lowerlimit ) && (iter<itermax)
    errorn=0;
    iter=iter+1;
    for n=1:trainNum        
        %forward computation
        for r=1:rows
            for c=1:cols
                ob((r-1)*cols+c)=imgs(r,c,n);
            end
        end
        ob(nb+1)=1;
        dk=zeros(nk,1);
        dk(labels(n)+1)=1;
        for i=1:ni
           si(i)=wib(i,:)*ob;
           oi(i)=1/(1+exp(-si(i)));
        end
        oi(ni+1)=1;
        for j=1:nj 
            sj(j)=wji(j,:)*oi;
            oj(j)=1/(1+exp(-sj(j)));
        end
        oj(nj+1)=1;
        for k=1:nk 
            sk(k)=wkj(k,:)*oj;
            ok(k)=1/(1+exp(-sk(k)));
        end                   
        errorn=errorn+sum(abs(dk-ok));
        %error=error+(dk-ok)'*(dk-ok)/2;
        %backward learning
        for k=1:nk
            deltak(k)=(dk(k)-ok(k))*ok(k)*(1-ok(k));
        end
        for j=1:nj+1
            for k=1:nk
                wkj_tmp(k,j)=wkj(k,j)+eta*deltak(k)*oj(j);
            end
        end
        for j=1:nj
            sumbackkj(j)=0.0;
            for k=1:nk
                sumbackkj(j)=sumbackkj(j)+deltak(k)*wkj(k,j);
            end
            deltaj(j)=sumbackkj(j)*oj(j)*(1-oj(j));
        end
        for i=1:ni+1
            for j=1:nj
                wji_tmp(j,i)=wji(j,i)+eta*deltaj(j)*oi(i);
            end
        end 
        for i=1:ni
            sumbackji(i)=0.0;
            for j=1:nj
                sumbackji(i)=sumbackji(i)+deltaj(j)*wji(j,i);
            end
            deltai(i)=sumbackji(i)*oi(i)*(1-oi(i));
        end
        for b=1:nb+1
            for i=1:ni
                wib(i,b)= wib(i,b)+eta*deltai(i)*ob(b);
            end
        end
        wkj=wkj_tmp;
        wji=wji_tmp;
    end
    ite(iter)=iter;
    error_avg=errorn/trainNum;
    error_r(iter)=error_avg; 
end
figure(2)
hold on
plot(ite,error_r);
hold off
%read test data
imagefile=fopen('t10k-images.idx3-ubyte','r','b');
header=fread(imagefile,1,'int32');
if header ~= 2051
    error('image file error');
end
numsofimage=fread(imagefile,1,'int32');
rows=fread(imagefile,1,'int32');
cols=fread(imagefile,1,'int32');
if testNum>numsofimage
    error('too much train samples');
end
testimgs=zeros([rows cols testNum]);
for t=1:testNum
    for r=1:rows
        testimgs(r,:,t)=fread(imagefile,cols,'uint8');
    end
end
for y=1:10
    for x=1:10
        temp((x-1)*rows+1:x*rows,(y-1)*cols+1:y*cols)=imgs(:,:,(x-1)*10+y);
    end
end
figure(3)
imshow(temp);
testimgs=double(testimgs)/255;
fclose(imagefile);
%read test label
labelfile=fopen('t10k-labels.idx1-ubyte','r','b');
header=fread(labelfile,1,'int32');
if header ~= 2049
    error('image file error');
end   
numsoflabel=fread(labelfile,1,'int32');
if testNum>numsoflabel
    error('too much train samples')
end
testlabels=fread(labelfile,testNum,'uint8');
fclose(labelfile);

rightNums=0;
results=zeros([testNum,1]);
cm=zeros([10 10]);
for n=1:testNum        
    %forward computation
    for r=1:rows
        for c=1:cols
            ob((r-1)*cols+c)=testimgs(r,c,n);
        end
    end
    ob(nb+1)=1;
    for i=1:ni
       si(i)=wib(i,:)*ob;
       oi(i)=1/(1+exp(-si(i)));
    end
    oi(ni+1)=1;
    for j=1:nj 
        sj(j)=wji(j,:)*oi;
        oj(j)=1/(1+exp(-sj(j)));
    end
    oj(nj+1)=1;
    for k=1:nk 
        sk(k)=wkj(k,:)*oj;
        ok(k)=1/(1+exp(-sk(k)));
    end 
    if ok(testlabels(n)+1) > 0.5
        rightNums=rightNums+1;
    end
    label=0;
    min=-100;
    for index=1:10
        if(ok(index)>min)
            min=ok(index);
            label=index-1;
        end
    end
    results(n)=label;
end
rate=rightNums/testNum;
for n=1:testNum 
    cm(testlabels(n)+1,results(n)+1)=cm(testlabels(n)+1,results(n)+1)+1;
end
