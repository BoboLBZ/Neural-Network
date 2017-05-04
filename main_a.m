%(a)
%use multi-class linear discriminant functions to find the discriminant functions, the
%linear decision boundaries, and regions¡£
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
                 weight(:,c)=weight(:,c)+alpha.*y';
                 error=error+1;%
             end
         end
     end 
     hold on 
     plot(iteration,error,'r.');
end
% hold off
% figure(2)
% hold on
% plot(data(:,1,1),data(:,2,1),'rx')%class1
% plot(data(:,1,2),data(:,2,2),'g+')%class2
% plot(data(:,1,3),data(:,2,3),'b.')%class3
% plot(data(:,1,4),data(:,2,4),'m*')%class4
% for m=1:4
%     fh=@(x,y) weight(1,m)*x+weight(2,m)*y+weight(3,m);
%     ezplot(fh,[-2,3]) 
%     hold on
% end
% hold off
figure(3)
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
legend('class1','class2','class3','class4','1-2','1-3','1-4','2-3','2-4','3-4')

%----------test-----------%
figure(4)
for x=-1:0.03:2
    for y=-1:0.03:2
        out=[x y 1]*weight;
        class=1;
        temp=out(1,1);
        for c=2:4
            if out(1,c)>temp
                class=c;
                temp=out(1,c);
            end
        end
        hold on
        if class==1
            plot(x,y,'rx');
        elseif class==2
            plot(x,y,'g+');
        elseif class==3
            plot(x,y,'b.');
        else
            plot(x,y,'m*');
        end
    end
end
axis on




