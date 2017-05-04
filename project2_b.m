%multi-class linear perceptrons to find the linear decision boundaries and
%regions¡£Activation functions žé hardlimiter function¡£
clear
%--------generate training data-----------%
mu=[0 0]';
sigma=[0.01 0;0 0.01];
data(:,:,1)=mvnrnd(mu,sigma,100);
mu=[1 0]';
sigma=[0.01 0;0 0.01];
data(:,:,2)=mvnrnd(mu,sigma,100);
mu=[1 1]';
sigma=[0.01 0;0 0.01];
data(:,:,3)=mvnrnd(mu,sigma,100);
mu=[0 1]';
sigma=[0.01 0;0 0.01];
data(:,:,4)=mvnrnd(mu,sigma,100);
%---------training------------------%
weight=[0 0 0 0;0 0 0 0;0 0 0 0];%3x4
iteration=0;%max=5000
error=1;%max=100,min=0.0
alpha=1.0;
while error>0 && iteration<5000
    error=0;
    iteration=iteration+1;
    %class1
    for c=1:4
        for n=1:100
            y=[data(n,1,c) data(n,2,c) 1];%1x3
            out=y*weight;%1x4
            for m=1:4 %hardlimiter
                if out(1,m)>0
                    out(1,m)=1;
                elseif out(1,m)<0
                    out(1,m)=-1;
                else
                    out(1,m)=0;
                end
            end
            flag=0;
            for m=1:4 % adjust 
                if m==c
                    if out(1,m) ~= 1 
                        weight(:,m)=weight(:,m)+alpha.*y';
                        flag=1;
                    end
                else
                    if out(1,m) ~= -1
                        weight(:,m)=weight(:,m)-alpha.*y';
                        flag=1;
                    end
                end
            end
            if flag
                error=error+1;
            end
         end
     end 
     hold on 
     plot(iteration,error,'r.','MarkerSize',10);
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
fh=@(x,y) w(1,1).*x+w(2,1).*y+w(3,1)';
set(ezplot(fh,[-0.5,1.5]),'Color','r');
hold on
%1-3
w=weight(:,1)-weight(:,3);
fh=@(x,y) w(1,1).*x+w(2,1).*y+w(3,1)';
set(ezplot(fh,[-0.5,1.5]),'Color','g');
hold on
%1-4
w=weight(:,1)-weight(:,4);
fh=@(x,y) w(1,1).*x+w(2,1).*y+w(3,1)';
set(ezplot(fh,[-0.5,1.5]),'Color','b');
hold on
%2-3
w=weight(:,2)-weight(:,3);
fh=@(x,y) w(1,1).*x+w(2,1).*y+w(3,1)';
set(ezplot(fh,[-0.5,1.5]),'Color','k');
hold on
%2-4
w=weight(:,2)-weight(:,4);
fh=@(x,y) w(1,1).*x+w(2,1).*y+w(3,1)';
set(ezplot(fh,[-0.5,1.5]),'Color','m');
hold on
%3-4
w=weight(:,3)-weight(:,4);
fh=@(x,y) w(1,1).*x+w(2,1).*y+w(3,1)';
set(ezplot(fh,[-0.5,1.5]),'Color','y');
hold off
grid on
axis on
legend('class1','class2','class3','class4','1-2','1-3','1-4','2-3','2-4','3-4')
