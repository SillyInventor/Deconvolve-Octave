
Wavelengths = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/wavelengths.csv");
LED = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/LED Spec 2 5-5-19.csv");
Water = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/Water Scatter Spec - 5-5-19.csv");
N500 = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/500ppm Scatter Spec - 5-5-19.csv");
N1000 = csvread ("C:/Users/JamesDavis/Desktop/Work/CISUVC/1000ppm Scatter Spec - 5-5-19.csv");

increment=.01;
cw=2; % cw = Convolution width of the physical convolution process (unknown)
dw=2.01; % dw = Deconvolution width (estimated) must equal cw for perfect results
SmoothWidth=6; % Width of final smoothing to remove high-frequency noise

Wavelengths = Wavelengths';
LED = LED';
Water = Water';
N500 = N500';
N1000 = N1000';

arrayLength = length(Wavelengths);

SmoothLength = 30;
LED(SmoothLength:arrayLength-SmoothLength) = nanfastsmooth(LED(SmoothLength:arrayLength-SmoothLength),SmoothLength);
LED = LED./max(LED);

Water = nanfastsmooth(Water,19);
Water(1:201) = nanfastsmooth(Water(1:201),50);
Water(700:2001) = nanfastsmooth(Water(700:2001),50);
Water = Water./max(Water);
Water = Water.*1.3;

N500 = nanfastsmooth(N500,19);
N500(1:201) = nanfastsmooth(N500(1:201),50);
N500(700:2001) = nanfastsmooth(N500(700:2001),50);
N500 = N500./max(N500);
N500 = N500.*1.3;

N1000 = nanfastsmooth(N1000,19);
N1000(1:201) = nanfastsmooth(N1000(1:201),50);
N1000(700:2001) = nanfastsmooth(N1000(700:2001),50);
N1000 = N1000./max(N1000);
N1000 = N1000.*1.3;

% Now attempt to recover the original signal by deconvolution (2 methods)
WaterDeconv=ifft(fft(Water)./fft(LED)).*sum(LED);  % Deconvolution by fft/ifft
WaterDeconv=abs(fastsmooth(WaterDeconv,SmoothWidth,5));

N500Deconv=ifft(fft(N500)./fft(LED)).*sum(LED);  % Deconvolution by fft/ifft
N500Deconv=abs(fastsmooth(N500Deconv,SmoothWidth,5));

N1000Deconv=ifft(fft(N1000)./fft(LED)).*sum(LED);  % Deconvolution by fft/ifft
N1000Deconv=abs(fastsmooth(N1000Deconv,SmoothWidth,5));

% Plot all the steps
subplot(2,2,1); plot(Wavelengths,LED); title('LED');
subplot(2,2,2); plot(Wavelengths,WaterDeconv);title('Water'); 
subplot(2,2,3); plot(Wavelengths,N500Deconv); title('500 ppm nitrate');
subplot(2,2,4); plot(Wavelengths,N1000Deconv);title('1000 ppm nitrate');