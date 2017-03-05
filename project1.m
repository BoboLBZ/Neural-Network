%劉波洲
% (1)Given 1-d Gaussian function, draw it. (Mean 與 variance 自訂)
%clear
%mean=3;
% sigma=2;
% x=-6:0.0001:12;
% y=(1/(sqrt(2*pi)*sigma))*exp(-((x-mean).^2)/(2*sigma.^2));
% plot(x,y,'-g','linewidth',1.5);

% (2) Given 2-d Gaussian function, draw it. (Mean 與 covariance matrix 自訂)
%clear
% mean=[1 2];
% sigma=[1 0;0 1];
% [X,Y]=meshgrid(-2:0.1:4,-2:0.1:4);
% Z=mvnpdf([X(:) Y(:)],mean,sigma);
% Z=reshape(Z,length(X),length(Y));
% surf(X,Y,Z);

%(3) Call 1-d Gaussian random data and plot 1-d histogram.
%clear
% mean=0;
% sigma=1;
% h=histogram(randn(10000,1)*sqrt(sigma)+mean);

%(4) Call 2-d Gaussian random data. 點在2-d space 上。 Plot 2-d histogram.
clear
mu=[1;2];
sigma=[3 0;0 4];
m=mvnrnd(mu,sigma,10000);
figure(1)
plot(m(:,1),m(:,2),'.');
figure(2)
hist3(m,{-10:0.5:10 -10:0.5:10});

%（5）承(4)，在2-d histogram 上畫等高線圖。没写出来
figure(3)
h=hist3(m);
[C,h]=contour(h);
clabel(C,h)


%(6) Plot line x-y=1.
% x=linspace(-6,6);
% y=x-1;
% plot(x,y,'.')

%(7) Plot circle x2+y2=1.
% theta=linspace(0,2*pi);
% plot(cos(theta),sin(theta));
% axis equal

%(8) Plot ellipse x2+y2/4 =1.
% theta=linspace(0,2*pi);
% plot(cos(theta),2*sin(theta));
% axis equal

%(9) Plot hyperbola x2-y2/4 =1.
% fimplicit(@(x,y) x.^2 - (y.^2) /4- 1);
% axis equal

%(10) Generate data of line 2x-y=0 and plot. (產生 100 點，畫在2-d 上)
% x=100*rand(1,100);
% plot(x,2*x,'+');

%(11) Generate data of circle x2+y2=4 and plot. (產生 100 點，畫在2-d 上)
% theta=2*pi*rand(1,100);
% plot(cos(theta),sin(theta),'+');
% axis equal

%(12) Generate data of ellipse x2/4+y2 =1 and plot. (產生 100 點，畫在2-d 上)
% clear
% theta=2*pi*rand(1,100);
% plot(2*cos(theta),sin(theta),'+');
% axis equal

%(13) Generate data of hyperbola xy=1 and plot. (產生 100 點，畫在2-d 上)
% clear
% x=-1:0.02:1;
% y=1./x;
% plot(x,y,'+');
% axis ([-1,1,-10,10]);

%(14) PlotPlot two spirals. 
% clear
% i=0:1:96;
% r=6.5.*(104.-i)./104;
% theta=pi.*i./16;
% plot(r.*sin(theta),r.*cos(theta),'+');
% hold on
% plot(-r.*sin(theta),-r.*cos(theta),'.');
% hold off
% axis equal

%(15)Plot 8 points in the three dimensional space, and the plane z = x – y + 0.5 that can
%    separate these two classes.
% clear
% x=0:1;
% y=0:1;
% [x1,y1]=meshgrid(x,y);
% z1=x1-y1+0.5;
% surf(x1,y1,z1);
% alpha(0.2);
% hold on
% a=[0 0 1 1 0 1 1 0];
% b=[1 0 0 0 0 1 1 1];
% c=[1 0 0 1 1 0 1 0];
% for i=1:1:8
%    if a(i)-b(i)+0.5>c(i)
%        scatter3(a(i),b(i),c(i),'g+');
%    else
%        scatter3(a(i),b(i),c(i),'ro');
%    end
% end
% hold off

%(16) Plot double moon problem:
% clear
% r=10;
% w=6;
% count=2000;
% randR=rand(1,count)*w;
% randTheta=rand(1,count)*2*pi;
% X=(r+randR).*cos(randTheta);
% Y=(r+randR).*sin(randTheta);
% 
% dataTargets=hardlim(Y);
% dataTargets=dataTargets.*1.0;
%  %距離调整参数-----------------
%  dv = -5;
%  dh = 10;
%  f=find(Y<0);
%  Y(1,f)=Y(1,f)-dv;
%  X(1,f)=X(1,f)+dh; 
% %------------------------------
% data=[X;Y];
% f1=find(dataTargets==1);
% plot(data(1,f1),data(2,f1),'r+');
% hold on
% f0=find(dataTargets==0);
% plot(data(1,f0),data(2,f0),'go');
% hold off
%  
 
%17. Given 5 sine function with different periods (different frequencies), 
% 利用動畫顯示這 5 個 sine functions。週期為 T0, T0/2, …, T0/5.
% T0與function 取樣的點數自訂。
% 動畫顯示的快慢由自己決定或以10 秒、20 秒、及30 秒作動畫顯示。
% clear M
% x=0:0.01:2*pi;
% set(gca,'XTick',0:pi/2:2*pi);
% grid on
% for i=1:1:5
%     plot(x,sin(i.*x),'g.');
%     M=getframe;
%     movie(M,12);
% end



% 18. Design a uniform random number generator. (必須做分析，如何設計?)
% (a) Given a seed number (SEED) and number of data (RANDX), generate random
% values between 0.0 and 1.0.
% (b) Extend to the values between a lower bound and an upper bound.
% clear
% SEED=6462;
% RANDX=1000;
% temp=SEED;
% myRand=zeros(1,RANDX);
% for a=1:1:RANDX
%    x=mod((2688*temp+8892),268892644);%http://www.cnblogs.com/houkai/p/3807041.html
%    temp=x;
%    myRand(1,a)=x/268892644;
% end;
% plot(myRand,'r.');
% %extend
% lowerBound=2;
% upperBound=5;
% myRandExtend=myRand.*(upperBound-lowerBound)+lowerBound;
% figure
% plot(myRandExtend,'g+');



% 19. Design a Gaussian (normal) random number generator. (必須做分析，如何設計?)
% (a) Given a seed number (SEED) and number of data (RANDX), generate random
% values with mean 0 and standard deviation 1, i.e., N(0, 1).
% (b) Modify to mean m and standard deviation σ, i.e., N(m, σ2).
% clear
% SEED=6462;
% RANDX=100000;
% U=rand(1,RANDX);
% V=rand(1,RANDX);
% X=sqrt(-2*log(U)).*sin(2*pi*V);%Box-Muller
% histogram(X);
% %Modify
% mean=2;
% theta=3;
% Y=mean+(theta.*X);
% figure
% histogram(Y);
