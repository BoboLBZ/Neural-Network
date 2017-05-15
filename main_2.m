%Two spiral problem
clear
N=200;
theta1 = linspace(-180,180, N)*pi/360;
r = 8;
x1 = -5 + r*sin(theta1)+randn(1,N);
y1 = r*cos(theta1)+randn(1,N);
x2 = 5 + r*sin(theta1)+randn(1,N);
y2 = -r*cos(theta1)+randn(1,N);
data(:,1,1)=x1';
data(:,2,1)=y1';
data(:,1,2)=x2';
data(:,2,2)=y2';

nj=34;
nk=2;
wkj=randn(nk,nj+1);
wkj_tmp=wkj;
wji=randn(nj,3);
wkj_low=wkj;
wji_low=wji;
olddelwkj=zeros(size(wkj));
olddelwji=zeros(size(wji));
oi=[0 0 1]';
sj=zeros(nj,1);
oj=zeros(nj+1,1);
sk=zeros(nk,1);
ok=zeros(nk,1);
dk=zeros(nk,1);

lowerlimit=0.03;
itermax=5000;
eta=0.7;
beta=0.3;

iter=0;
error_avg=10;
count=0;
minerror=10000;

deltak=zeros(1,nk);
sumback =zeros(1,nj);
deltaj=zeros(1,nj);

while (error_avg >lowerlimit ) && (iter<itermax)
    error=0;
    iter=iter+1;
    count=count+1;
    for i=1:N
        for class=1:2
            if class==1
                dk=[1 0]';
            else 
                dk=[0 1]';
            end
            %forward computation
            oi=[data(i,1,class) data(i,2,class) 1]';
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
                deltak(k)=(dk(k)-ok(k))*ok(k)*(1.0-ok(k));
            end
            for j=1:nj
                for k=1:nk
                    wkj_tmp(k,j)=wkj(k,j)+eta*deltak(k)*oj(j)+beta*olddelwkj(k,j); 
                    olddelwkj(k,j)=eta*deltak(k)*oj(j)+beta*olddelwkj(k,j);
                end
            end
            for j=1:nj
                sumback(j)=0.0;
                for k=1:nk
                    sumback(j)=sumback(j)+deltak(k)*wkj(k,j);
                end
                deltaj(j)=sumback(j)*oj(j)*(1-oj(j));
            end
            for ii=1:2
                for j=1:nj
                    wji(j,ii)=wji(j,ii)+eta*deltaj(j)*oi(ii)+beta*olddelwji(j,ii);
                    olddelwji(j,ii)=eta*deltaj(j)*oi(ii)+beta*olddelwji(j,ii);
                end
            end 
            wkj=wkj_tmp;
        end
    end
    ite(iter)=iter;
    error_avg=error/(2*N);
    error_r(iter)=error_avg; 
    if error_avg<minerror
        count=0;
        minerror=error_avg;
        wkj_low=wkj;
        wji_low=wji;
    elseif count>20
        wkj=wkj_low;
        wji=wji_low;
        break;
    end
end

figure(2)
hold on
plot(ite,error_r);
    
figure(3)
 plot(data(:,1,1),data(:,2,1),'r+');
 hold on
 plot(data(:,1,2),data(:,2,2),'g.');
for x=-20:0.5:20
    for y=-15:0.5:15
        oi=[x y 1]';
        for j=1:nj 
            sj(j)=wji(j,:)*oi;
            oj(j)=1/(1+exp(-sj(j)));
        end
            oj(nj+1)=1.0;
        for k=1:nk 
            sk(k)=wkj(k,:)*oj;
            ok(k)=1/(1+exp(-sk(k)));
        end   
        if ok(1,1)> 0.5
            plot(x,y,'b.');
        elseif ok(1,1)<0.5
            plot(x,y,'r.');
        end
    end
end
axis equal