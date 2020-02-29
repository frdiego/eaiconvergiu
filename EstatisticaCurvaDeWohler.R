# Define o caminho onde esta o arquivo com os dados de confiabilidade
setwd("C:/Users/frdie/OneDrive/Work/02-E_ai_convergiu/Posts/03-Rascunho/10-Confiabilidade/")

# Le o arquivo de confiabilidade
df_Fadiga <- read.csv("Confiabilidade.csv", sep = ",", dec = ".")

# Cria uma coluna com o Log do Numero de Ciclos
df_Fadiga$log_N <- log10(df_Fadiga$NumeroDeCiclos)

# Cria uma coluna com o log da Tensao
df_Fadiga$log_S <- log10(df_Fadiga$Tensao_Mpa)

# Scatter Plot dos log_N e log_S
plot(df_Fadiga$log_N, df_Fadiga$log_S, 
     main="Diagrama de Wohler ou Tensao - Numero \nde Ciclos (S-N) em escala logaritmica",
     xlab="log(N)", ylab="log(S)")
grid(5, 5, lwd = 2)

# Cria um modelo linear entre o log_S e log_N
CurvaWohler <- lm(log_S ~ log_N, data=df_Fadiga)

# Obtem o valor de log(Sfsp*2) e bsp
coef(CurvaWohler)

# Resume as estatiticas de log_S e log_N
summary(CurvaWohler)

# Intervalo de confianca
confint(CurvaWohler, level = 0.95)

# Definindo os parametros do modelo de fadiga
# Coeficiente de Resistência à Fadiga do Material (MPa) medio
log_Sfsp_mu <- summary(CurvaWohler)$coefficients[1,1]
# Coeficiente de Resistência à Fadiga do Material (MPa) desvio padrao
log_Sfsp_sigma <- summary(CurvaWohler)$coefficients[1,2]
# Distribuicao do Coeficiente de Resistência à Fadiga do Material (MPa)
x_log_Sfsp <- seq(3.065, 3.10, length=1000)
y_log_Sfsp <- dnorm(x_log_Sfsp, mean=log_Sfsp_mu, sd=log_Sfsp_sigma)
plot(x_log_Sfsp, y_log_Sfsp, type="l", lwd=1, 
     main="Distribuicao do Logaritmo do Coeficiente de \nResistência a Fadiga do Material (MPa) [log(Sfsp*2)]",
     xlab="log(Sfsp*2)", ylab="Densidade f(x)")
grid(5, 5, lwd = 2)

# Expoente de Resistência à Fadiga do Material media
bsp_mu <- summary(CurvaWohler)$coefficients[2,1]
# Expoente de Resistência à Fadiga do Material desvio padrao
bsp_sigma <- summary(CurvaWohler)$coefficients[2,2]
# Distribuicao do Expoente de Resistência à Fadiga do Material
x_bsp <- seq(-0.218, -0.21, length=1000)
y_bsp <- dnorm(x_bsp, mean=bsp_mu, sd=bsp_sigma)
plot(x_bsp, y_bsp, type="l", lwd=1, 
     main="Distribuicao do Expoente de Resistencia\n a Fadiga do Material [bsp]",
     xlab="bsp", ylab="Densidade f(x)")
grid(5, 5, lwd = 2)

# Interpretacao grafica do R-squared 
plot(df_Fadiga$log_N, df_Fadiga$log_S, col='grey',
     main="Diagrama de Wohler ou Tensao - Numero \nde Ciclos (S-N) em escala logaritmica",
     xlab="log(N)", ylab="log(S)")
grid(5, 5, lwd = 2)
abline(CurvaWohler, col="black")
segments(df_Fadiga$log_N, df_Fadiga$log_S, df_Fadiga$log_N, CurvaWohler$fitted.values, col="red")
legend("topright",
       legend=c("Dados Medidos", "Previsao do Modelo", "Diferenca entre o Medido e o Modelo"),
       lty=c(1,1,1), col=c('grey','black','red'), cex = 0.5)

# Plot do residuo
plot(CurvaWohler, which=1)

# Histograma do resido
hist(CurvaWohler$residuals)

# Cria um vetor log_N para criação da curva 
novox = seq(min(df_Fadiga$log_N),max(df_Fadiga$log_N),by = 0.05)
# Cria um modelo do intervalo de confianca
conf_interval <- predict(CurvaWohler, newdata=data.frame(log_N=novox), interval="predict", level = 0.95)
plot(df_Fadiga$log_N, df_Fadiga$log_S, col='grey',
     main="Diagrama de Wohler ou Tensao - Numero \nde Ciclos (S-N) em escala logaritmica",
     xlab="log(N)", ylab="log(S)")
grid(5, 5, lwd = 2)
abline(CurvaWohler, col="black")
lines(novox, conf_interval[,2], col="black", lty=2)
lines(novox, conf_interval[,3], col="black", lty=2)
legend("topright",
       legend=c("Curva S-N Media", "Intervalo de Confianca da Curva S-N"),
       lty=c(1,2), cex = 0.8)