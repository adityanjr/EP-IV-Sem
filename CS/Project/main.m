clear all;
%% parameters
Fs = 1000;
fc = 100;
fp = 2;
bit_t = 0.1;
%% message generation with BPSK
m = randi([0 1], 1, 20);
for bit = 1:length(m)
 if(m(bit)==0)
 m(bit) = -1;
 end
end
message = repmat(m,fp,1);
message = reshape(message,1,[]);
%% PN generation and multiply with message
pn_code = randi([0,1],1,length(m)*fp);
for bit = 1:length(pn_code)
 if(pn_code(bit)==0)
 pn_code(bit) = -1;
 end
end
DSSS = message.*pn_code;
%% create carrier and multipy with encoded sequence
t = 0:1/Fs:(bit_t-1/Fs);
s0 = -1*cos(2*pi*fc*t);
s1 = cos(2*pi*fc*t);
carrier = [];
BPSK = [];
for i = 1:length(DSSS)
 if (DSSS(i) == 1)
 BPSK = [BPSK s1];
 elseif (DSSS(i) == -1)
 BPSK = [BPSK s0];
 end
 carrier = [carrier s1];
end
Errors=zeros(1,10);
for h=1:10
 noise=[];
 p_error=0;
 for y=1:100
 noise=awgn(BPSK,-10*h);

%% demodulation
rx =[];
for i = 1:length(pn_code)
 if(pn_code(i)==1)
 rx = [rx noise((((i-1)*length(t))+1):i*length(t))];
 else
 rx = [rx (-1)*noise((((i-1)*length(t))+1):i*length(t))];
 end
end
result = [];
for i = 1:length(m)
 x = length(t)*fp;
 cx = sum(carrier(((i-1)*x)+1:i*x).*rx(((i-1)*x)+1:i*x));
 if(cx>0)
 result = [result 1];
 else
 result = [result -1];
 end
end
counter=0;
for z=1:length(m)
 if m(z)~=result(z)
 counter=counter+1;
 end
end
p_error=p_error+counter*100/length(m);
 end
Errors(h) = (p_error/100);
end
%% Draw original message, PN code , encoded sequence on time domain
pn_size = length(pn_code);
tm = 0:bit_t:(length(m)-1)*bit_t;
tpn = linspace(0,(pn_size-1)*bit_t/length(m),pn_size);
figure
subplot(311)
stairs(tm,m,'linewidth',2)
title('Message bit sequence')
axis([0 bit_t*length(m) -1 1]);
subplot(312)
stairs(tpn,pn_code,'linewidth',2)
title('Pseudo-random code');
axis([0 bit_t/length(m)*pn_size -1 1]);
subplot(313)
stairs(tpn,DSSS,'linewidth',2)
title('Modulated signal');
axis([0 bit_t/length(m)*pn_size -1 1]);
%% Draw original message, PN code , encoded sequence on frequency domain
f = linspace(-Fs/2,Fs/2,1024);
figure
subplot(321)
plot(f,abs(fftshift(fft(message,1024))),'linewidth',2);
title('Message spectrum')
subplot(322)
plot(f,abs(fftshift(fft(pn_code,1024))),'linewidth',2);
title('Pseudo-random code spectrum');
subplot(323)
plot(f,abs(fftshift(fft(DSSS,1024))),'linewidth',2);
title('Message multiplied by pseudo code');
subplot(324)
plot(f,abs(fftshift(fft(BPSK,1024))),'linewidth',2);
title('Transmitted signal spectrum');
subplot(325)
plot(f,abs(fftshift(fft(rx,1024))),'linewidth',2);
title('Received signal multiplied by pseudo code')