
Wavelengths = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/wavelengths.csv");
LED = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/LED Spec 2 5-5-19.csv");
Water = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/Water Scatter Spec - 5-5-19.csv");
N500 = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/500ppm Scatter Spec - 5-5-19.csv");
N1000 = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/1000ppm Scatter Spec - 5-5-19.csv");

Wavelengths = Wavelengths';
WavelengthsHalf =198.87:.054904:426.00;
LED = LED';
Water = Water';
N500 = N500';
N1000 = N1000';

LED = nanfastsmooth(LED,30);
Water = nanfastsmooth(Water,30);
N500 = nanfastsmooth(N500,30);
N1000 = nanfastsmooth(N1000,30);

SumLED = sum(LED);
maxVal = 10e30;

WaterDeconv = deconv([Water 1:4136],LED).*sum(LED);
indices = find(WaterDeconv>maxVal);
WaterDeconv(indices) = maxVal;
indices = find(WaterDeconv<-maxVal);
WaterDeconv(indices) = -maxVal;

N500Deconv = deconv([N500 1:4136],LED).*sum(LED);
indices = find(N500Deconv>maxVal);
N500Deconv(indices) = maxVal;
indices = find(N500Deconv<-maxVal);
N500Deconv(indices) = -maxVal;

N1000Deconv = deconv([N1000 1:4136],LED).*sum(LED);
indices = find(N1000Deconv>maxVal);
N1000Deconv(indices) = maxVal;
indices = find(N1000Deconv<-maxVal);
N1000Deconv(indices) = -maxVal;


ydc=deconv(yc,c).*sum(c);     % Attempt to recover y by deconvoluting c from yc

%}

x=0:.01:20;y=zeros(size(x));
temp=0:.005:20;
y(900:1100)=1;                % Create a rectangular function y, 
                              % 200 points wide
y=y+.01.*randn(size(y));      % Noise added before the convolution
c1=exp((0:200)./30);    % exponential trailing convolution 
c2=exp(-(1:1800)./30);    % exponential trailing convolution
c = [c1 c2];
c = c./(max(c)+1);
yc=conv([y 1:2000],c,'full')./sum(c);  % Create exponential trailing rectangular
                              % function, yc
% yc=yc+.01.*randn(size(yc)); % Noise added after the convolution
ydc=deconv(yc,c).*sum(c);     % Attempt to recover y by deconvoluting c from yc
% The sum(c2) is included simply to scale the amplitude of the result to match the original y.
% Plot all the steps
indices = find(ydc>maxVal);
ydc(indices) = maxVal;
indices = find(ydc<-maxVal);
ydc(indices) = -maxVal;

subplot(2,2,1); plot(Wavelengths,LED); title('LED');
subplot(2,2,2); plot(WavelengthsHalf,WaterDeconv);title('water');
subplot(2,2,3); plot(WavelengthsHalf,N500Deconv); title('500ppm nitrate');
subplot(2,2,4); plot(WavelengthsHalf,N1000Deconv);title('1000ppm nitrate')
