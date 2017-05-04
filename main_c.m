    %multi-class linear perceptrons to find the ¡°decision regions¡±¡£
%Activation functions žé sigmoidal function¡£
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
iteration=0;
error=1;
alpha=0.5;
%f(s)=1/(1+e^(-s)),f'(s)=f(s)(1-f(s))=1/(1+e^(-s))*(1-1/(1+e^(-s)))
while error>0.02 && iteration<5000
    error=0;
    iteration=iteration+1;
    %class1
    for c=1:4
        d=[0 0 0 0];
        d(c)=1;%desired output
        for n=1:100
            y=[data(n,1,c) data(n,2,c) 1];%1x3
            s=y*weight;%1x4
            o=1./(1+exp(-s));
            error=error+sum((d-o).*(d-o)/2);
%           error=error+sum(abs(d-o));
%             weight(:,c)=weight(:,c)+alpha .* (d(c)-o(c)).*(1/(1+exp(-s(c))) ) .*(1-1/(1+exp(-s(c)))).*y';
            for w=1:4
                weight(:,w)=weight(:,w)+alpha .* (d(w)-o(w)).*(1/(1+exp(-s(w))) ) .*(1-1/(1+exp(-s(w)))).*y';
            end
         end
    end 
     error=error/4;
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
