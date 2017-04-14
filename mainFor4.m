clear
%--------generate test data-----------%
mu1=[0 0]';
sigma1=[1 0;0 1];
data(:,:,1)=mvnrnd(mu1,sigma1,100);
mu2=[14 0]';
sigma2=[1 0;0 4];
data(:,:,2)=mvnrnd(mu2,sigma2,100);
mu3=[7 14]';
sigma3=[4 0;0 1];
data(:,:,3)=mvnrnd(mu3,sigma3,100);
mu4=[7 7]';
sigma4=[1 0;0 1];
data(:,:,4)=mvnrnd(mu4,sigma4,100);
%---------------------------------%
weight=[0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0 ;0 0 0 0;0 0 0 0];%6x4
iteration=0;%max=5000
error=1;%max=100,min=0.0
alpha=1.0;
while error>0 && iteration<5000
    error=0;
    iteration=iteration+1;
    %class1
    for c=1:4
        for n=1:100
            y=[data(n,1,c)^2  data(n,2,c)^2  data(n,1,c)*data(n,2,c) data(n,1,c) data(n,2,c) 1];%1x6
            out=y*weight;%1x4
            flag=0;
            for t=1:4
                if c==t
                   continue;
                elseif out(1,c)<=out(1,t)
                    flag=1;
                    weight(:,t)=weight(:,t)-alpha.*y';
                end
             end
             if(flag==1)
                 error=error+1;%
             end
         end
     end 
     hold on 
     plot(iteration,error,'r.');
end
hold off

figure(2)
hold on
plot(data(:,1,1),data(:,2,1),'rx')%class1
plot(data(:,1,2),data(:,2,2),'g+')%class2
plot(data(:,1,3),data(:,2,3),'b.')%class3
plot(data(:,1,4),data(:,2,4),'m*')%class4
%1-2
w=weight(:,1)-weight(:,2);
fh1=@(x,y) w(1,1).*x.^2+w(2,1).*y.^2+w(3,1).*x.*y+w(4,1).*x+w(5,1).*y+w(6,1)';
fimplicit(fh1,[-5,20],'LineWidth',2);
%1-3
w=weight(:,1)-weight(:,3);
fh2=@(x,y) w(1,1)*x^2+w(2,1)*y^2+w(3,1)*x*y+w(4,1)*x+w(5,1)*y+w(6,1);
fimplicit(fh2,[-5,20],'LineWidth',2);
%1-4
w=weight(:,1)-weight(:,4);
fh3=@(x,y) w(1,1)*x^2+w(2,1)*y^2+w(3,1)*x*y+w(4,1)*x+w(5,1)*y+w(6,1);
fimplicit(fh3,[-5,20],'LineWidth',2);
%2-3
w=weight(:,2)-weight(:,3);
fh4=@(x,y) w(1,1)*x^2+w(2,1)*y^2+w(3,1)*x*y+w(4,1)*x+w(5,1)*y+w(6,1);
fimplicit(fh4,[-5,20],'LineWidth',2);
%2-4
w=weight(:,2)-weight(:,4);
fh5=@(x,y) w(1,1)*x^2+w(2,1)*y^2+w(3,1)*x*y+w(4,1)*x+w(5,1)*y+w(6,1);
fimplicit(fh5,[-5,20],'LineWidth',2);
%3-4
w=weight(:,3)-weight(:,4);
fh6=@(x,y) w(1,1)*x^2+w(2,1)*y^2+w(3,1)*x*y+w(4,1)*x+w(5,1)*y+w(6,1);
fimplicit(fh6,[-5,20],'LineWidth',2);
hold off
grid on
legend('class1','class2','class3','class4','1-2','1-3','1-4','2-3','2-4','3-4')