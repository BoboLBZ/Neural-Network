%Two spiral problem
clear
i=0:1:96;
r=6.5.*(104.-i)./104;
theta=pi.*i./16; 
data(:,1,1)=r.*sin(theta);
data(:,2,1)=r.*cos(theta);
data(:,1,2)=-r.*sin(theta);
data(:,2,2)=-r.*cos(theta);

ni=30;
nj=15;
nk=2;
wkj=randn(nk,nj+1);
wkj_tmp=wkj;
wji=randn(nj,ni+1);
wji_tmp=wji;
wib=randn(ni,3);
wkj_low=wkj;
wji_low=wji;
wib_low=wib;
ob=[0 0 1]';
si=zeros(ni,1);
oi=zeros(ni+1,1);
sj=zeros(nj,1);
oj=zeros(nj+1,1);
sk=zeros(nk,1);
ok=sk;
dk=sk;

lowerlimit=0.1;
itermax=20000;
eta=0.2;
beta=0;

iter=0;
error_avg=10;

deltak=zeros(1,nk);
deltaj=zeros(1,nj);
deltai=zeros(1,ni);
sumbackkj =zeros(1,nj);
sumbackji =zeros(1,ni);

while (error_avg >lowerlimit ) && (iter<itermax)
    error=0;
    iter=iter+1;
    for n=1:97
        for class=1:2
            if class==1
                dk=[1 0]';
            else 
                dk=[0 1]';
            end
            %forward computation
            ob=[data(n,1,class) data(n,2,class) 1]';
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
            error=error+sum(abs(dk-ok));
            %error=error+(dk-ok)'*(dk-ok)/2;
            %backward learning
            for k=1:nk
                deltak(k)=(dk(k)-ok(k))*ok(k)*(1-ok(k));
            end
            for j=1:nj
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
            for i=1:ni
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
            for b=1:3
                for i=1:ni
                    wib(i,b)= wib(i,b)+eta*deltai(i)*ob(b);
                end
            end
            wkj=wkj_tmp;
            wji=wji_tmp;
        end
    end
    ite(iter)=iter;
    error_avg=error/194;
    error_r(iter)=error_avg; 
end
figure(2)
hold on
plot(ite,error_r);
    
figure(3)
hold on
plot(data(:,1,1),data(:,2,1),'r+');
plot(data(:,1,2),data(:,2,2),'ro');
for x=-6.5:0.2:6.5
    for y=-6.5:0.2:6.5
        ob=[x y 1]';
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
        if ok(1,1)> 0.5
            plot(x,y,'b.');
        elseif ok(1,1)<0.5
            plot(x,y,'g.');
        end
    end
end