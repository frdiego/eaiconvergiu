clc

// ===================================
// Dados de entrada
// ===================================

ti = 1; // Tempo inicial (s)
tf = 30; // Tempo final (s)
Fi = 100; // Frequencia de inicio do sinal (Hz)
Ff = 700; // Frequencia de final do sinal (Hz)
Fs = 44100; // Frequencia de amostragem (Hz)

// ===================================
// Operacoes Basicas
// ===================================

// Conversao digital do sinal do tempo
t = ti:(1/Fs):tf;

// Lembrar de rodar a funcao chirp.sci antes desse trecho
// Usando a function y = chirp(t, f0, t1, f1, form, phase)
// Parameters
// t: vector of times to evaluate the chirp signal
// f0: frequency at time t=0 [0 Hz]
// t1: time t1 [1 sec]
// f1: frequency at time t=t1 [100 Hz]
// form: shape of frequency sweep;   'linear' :     f(t) = (f1-f0)*(t/t1) + f0, ,    'quadratic':   f(t) = (f1-f0)*(t/t1)^2 + f0,    'logarithmic': f(t) = (f1-f0)^(t/t1) + f0
// phase: phase shift at t=0
s = chirp(t,Fi,tf,Ff,'linear');

// Criacao do sinal stereo para o cancelamento
s_direito = s;
s_esquerdo = s;
stereo = [s_esquerdo;s_direito]; 

// ===================================
// Analise Grafica dos Sinais
// ===================================

// Plot do sinal no tempo
figure()
title("Sinal do Gerado")
plot(t,s,'b','LineWidth',2)
xlabel("Tempo [s]")
ylabel("Amplitude do sinal [Propocional a Pa]")
legend(['Sinal de pressão sonora'])
xgrid(1)

// FFT do sinal
y = fft(s);

// Numero de amostras
N = size(t,'*'); 

// Vetor de frequencia
f = Fs*(0:(N/2))/N; 
n = size(f,'*');
figure()
title("Análise de Frequência")
plot(f,abs(y(1:n)),'b','LineWidth',2)
xlabel("Frequência [Hz]")
ylabel("Amplitude do sinal [Propocional a Pa]")
legend(['FFT do sinal de pressão sonora'])
xgrid(1)

// ===================================
// Geracao dos Sinais em *.wav
// ===================================

// Escreve em wave stereo
savewave ('Sweep.wav',stereo,Fs);
