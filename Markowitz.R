## C�digo para trabalho de finan�as PUC-Rio ##

## Favor mencionar a fonte ao uso deste c�digo ##

### NADA SIMULADO AQUI � RECOMENDA��O DE INVESTIMENTO ###


# Feito por Gabriel Boechat (Twitter: @gab_boechat)


# Para contabilizar em quanto tempo o c�digo roda

come�o = Sys.time()

# Bibliotecas utilizadas ------------------------

library(tidyverse) # Para fazer limpeza em geral dos dados
library(gridExtra) # Para ver tabelas nos gr�ficos
library(ggplot2) # Pacote para gerar gr�ficos
library(PerformanceAnalytics) # Fun��es de finan�as
library(quantmod) # Puxar dados financeiros
library(fPortfolio) # Realiza todo esse c�digo, em resumo
library(tseries) # Para fazer a fronteira eficente sem short

# Puxando os dados ------------------------------

# A��es utilizadas no trabalho para cada setor

# OBS: Totalmente aleat�rias

# N�o h� recomenda��o de investimentos

Varejo = c("MGLU3.SA", "VVAR3.SA", "LAME4.SA")
Qu�mico = c("UNIP6.SA", "BRKM5.SA", "DTEX3.SA")
Energia = c("ENBR3.SA", "EGIE3.SA", "CPLE6.SA", "ENGI11.SA")
Financeiro = c("SANB11.SA", "ITSA4.SA", "BBDC4.SA", "BBAS3.SA")
Extra��o = c("PETR4.SA", "PRIO3.SA", "VALE3.SA")
Siderurgia = c("GGBR4.SA", "CSNA3.SA", "USIM5.SA")

tickers_acoes = c(Varejo, 
                  Qu�mico, 
                  Energia, 
                  Financeiro, 
                  Extra��o, 
                  Siderurgia) # Todos tickers juntos

# Puxando as cota��es do Yahoo Finance
# Pacote {quantmod}

cotacao = getSymbols(tickers_acoes, # Vetor com todos tickers 
                     src = 'yahoo', # Fonte
                     from = "2015-09-30", # Data inicial
                     to = "2020-09-30", # Data final
                     periodicity = "daily", # Dados di�rios
                     auto.assign = TRUE,
                     warnings = FALSE) %>% # Puxando do Yahoo
  map(~Ad(get(.))) %>% # Isolando as s�ries em objetos individuais
  reduce(merge) %>% # Juntando as s�ries em um xts apenas
  `colnames<-`(tickers_acoes) %>% # Renomeando as colunas
  na.omit() %>% # Retirando dados faltantes
  abs() # Retorna valores absolutos para evitar pre�os negativos

cotacao$MGLU3.SA[1:387] = cotacao$MGLU3.SA[1:387] + 1.01726 # Erro do yahoo finance

# Observando as cota��es ------------------------

cor = "black"

tema_trabalho_G2 = {theme(panel.background = element_rect(fill = cor),
                         plot.background = element_rect(fill = cor),
                         # Remove panel border
                         panel.border = element_blank(),  
                         panel.grid.minor.x = element_blank(),
                         panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                         colour = "white"),
                         panel.grid.major.x = element_blank(),
                         # Add axis line
                         axis.line = element_line(colour = "white"),
                         # Ajusting labs 
                         plot.title = element_text(color = "white",
                                                   size = 18),
                         axis.title.x = element_text(color = "white",
                                                     size = 14),
                         axis.title.y = element_text(color = "white",
                                                     size = 14),
                         axis.ticks = element_line(colour = "white"),
                         axis.text = element_text(color = "white",
                                                  size = 11),
                         axis.text.x = element_text(color = "white",
                                                    size = 11,
                                                    angle = 45,
                                                    hjust = 1),
                         legend.background = element_rect(fill = cor, 
                                                          colour = "white"),
                         legend.text = element_text(color = "white",
                                                    size = 9),
                         legend.title = element_text(color = "white",
                                                     size = 11),
                         legend.key = element_rect(fill = cor, 
                                                   colour = "white"),
                         plot.caption = element_text(color = "white",
                                                     size = 9,
                                                     face = "italic"))
}

# Varejo ----------------------------------------

cotacao_Varejo = cotacao[,Varejo] %>%
  as.data.frame() %>%
  gather(key = Ticker,
         value = Cota��o) %>%
  cbind(Data = rep(index(cotacao), times = length(Varejo))) # Para usarmos a legenda facilmente no ggplot2

ggplot(data = cotacao_Varejo, mapping = aes(x = as.Date(Data), y = Cota��o, colour = Ticker)) + # Dados usados
  geom_line(lwd = 0.7) + # Gr�fico de linha
  labs(x = NULL, y = NULL, title = "Empresas do setor varejeiro cotadas na B3",
       caption = "Dados de 30/09/2015 at� 30/09/2020
       Fonte: Yahoo Finance") + # T�tulos, nomes dos eixos etc
  scale_y_continuous(labels = scales::dollar_format(prefix = "R$ "),
                     breaks = scales::pretty_breaks(n = 4)) + # Escala dos dados em R$
  tema_trabalho_G2 # Tema constr�ido anteriormente (puramente est�tico, n�o � preciso)



# Energia ---------------------------------------

cotacao_Energia = cotacao[,Energia] %>%
  as.data.frame() %>%
  gather(key = Ticker,
         value = Cota��o) %>%
  cbind(Data = rep(index(cotacao), times = length(Energia))) # Para plotarmos no ggplot2

ggplot(data = cotacao_Energia, mapping = aes(x = as.Date(Data), y = Cota��o, colour = Ticker)) +
  geom_line(lwd = 0.7) +
  labs(x = NULL, y = NULL, title = "Empresas do setor energ�tico cotadas na B3",
       caption = "Dados de 30/09/2015 at� 30/09/2020
       Fonte: Yahoo Finance") +
  scale_y_continuous(labels = scales::dollar_format(prefix = "R$ "),
                     breaks = scales::pretty_breaks(n = 4)) +
  tema_trabalho_G2



# Qu�mico ---------------------------------------

cotacao_Qu�mico = cotacao[,Qu�mico] %>%
  as.data.frame() %>%
  gather(key = Ticker,
         value = Cota��o) %>%
  cbind(Data = rep(index(cotacao), times = length(Qu�mico))) # Para plotarmos no ggplot2

ggplot(data = cotacao_Qu�mico, mapping = aes(x = as.Date(Data), y = Cota��o, colour = Ticker)) +
  geom_line(lwd = 0.7) +
  labs(x = NULL, y = NULL, title = "Empresas do setor qu�mico cotadas na B3",
       caption = "Dados de 30/09/2015 at� 30/09/2020
       Fonte: Yahoo Finance") +
  scale_y_continuous(labels = scales::dollar_format(prefix = "R$ "),
                     breaks = scales::pretty_breaks(n = 4)) +
  tema_trabalho_G2



# Financeiro ---------------------------------------

cotacao_Financeiro = cotacao[,Financeiro] %>%
  as.data.frame() %>%
  gather(key = Ticker,
         value = Cota��o) %>%
  cbind(Data = rep(index(cotacao), times = length(Financeiro))) # Para plotarmos no ggplot2

ggplot(data = cotacao_Financeiro, mapping = aes(x = as.Date(Data), y = Cota��o, colour = Ticker)) +
  geom_line(lwd = 0.7) +
  labs(x = NULL, y = NULL, title = "Empresas do setor financeiro cotadas na B3",
       caption = "Dados de 30/09/2015 at� 30/09/2020
       Fonte: Yahoo Finance") +
  scale_y_continuous(labels = scales::dollar_format(prefix = "R$ "),
                     breaks = scales::pretty_breaks(n = 4)) +
  tema_trabalho_G2



# Extra��o ---------------------------------------

cotacao_Extra��o = cotacao[,Extra��o] %>%
  as.data.frame() %>%
  gather(key = Ticker,
         value = Cota��o) %>%
  cbind(Data = rep(index(cotacao), times = length(Extra��o))) # Para plotarmos no ggplot2

ggplot(data = cotacao_Extra��o, mapping = aes(x = as.Date(Data), y = Cota��o, colour = Ticker)) +
  geom_line(lwd = 0.7) +
  labs(x = NULL, y = NULL, title = "Empresas do setor de extra��o cotadas na B3",
       caption = "Dados de 30/09/2015 at� 30/09/2020
       Fonte: Yahoo Finance") +
  scale_y_continuous(labels = scales::dollar_format(prefix = "R$ "),
                     breaks = scales::pretty_breaks(n = 4)) +
  tema_trabalho_G2



# Siderurgia ---------------------------------------

cotacao_Siderurgia = cotacao[,Siderurgia] %>%
  as.data.frame() %>%
  gather(key = Ticker,
         value = Cota��o) %>%
  cbind(Data = rep(index(cotacao), times = length(Siderurgia))) # Para plotarmos no ggplot2

ggplot(data = cotacao_Siderurgia, mapping = aes(x = as.Date(Data), y = Cota��o, colour = Ticker)) +
  geom_line(lwd = 0.7) +
  labs(x = NULL, y = NULL, title = "Empresas do setor sider�rgico cotadas na B3",
       caption = "Dados de 30/09/2015 at� 30/09/2020
       Fonte: Yahoo Finance") +
  scale_y_continuous(labels = scales::dollar_format(prefix = "R$ "),
                     breaks = scales::pretty_breaks(n = 4)) +
  tema_trabalho_G2

# Retornos --------------------------------------

# Pacote {PerformanceAnalytics}

retornos = Return.calculate(cotacao,
                            method = "discrete")

# Retornos come�am na primeira data; nenhuma posi��o 
# anterior, retorno 0

retornos[1,] = 0 

# Taxa DI di�ria no per�odo

benchmark = 0.00031888 

# Matriz de covari�ncia de todas as a��es:

Cov = cov(retornos)

media_variancia = matrix(data = NA,
                         nrow = 2, # Guardando retorno e vol
                         ncol = length(tickers_acoes)) # Uma coluna para cada a��o

for(i in c(1:length(tickers_acoes))) {
  
  # M�dia e vari�ncia para cada a��o
  
  media_variancia[1,i] = mean(retornos[,i]) 
  media_variancia[2,i] = sd(retornos[,i])
  
}

media_variancia_df = data.frame(t(media_variancia))

media_variancia_df = cbind(media_variancia_df,tickers_acoes)

names(media_variancia_df) = c("Retorno Medio", "Volatilidade", "Acao")

media_variancia_df = media_variancia_df %>%
  mutate(Classificacao = case_when(Acao %in% Energia ~ "Energia",
                                   Acao %in% Qu�mico ~ "Qu�mico",
                                   Acao %in% Siderurgia ~ "Siderurgia",
                                   Acao %in% Varejo ~ "Varejo",
                                   Acao %in% Energia ~ "Energia",
                                   Acao %in% Financeiro ~ "Financeiro",
                                   Acao %in% Extra��o ~ "Extra��o"))

media_variancia_df = media_variancia_df %>%
  mutate(Sharpe = (`Retorno Medio` - benchmark)/Volatilidade) # Tabela completa reunindo todos os dados de cada a��o escolhida

tema_trabalho_G2.2 = {theme(panel.background = element_rect(fill = cor),
                          plot.background = element_rect(fill = cor),
                          # Remove panel border
                          panel.border = element_blank(),  
                          panel.grid.minor.x = element_blank(),
                          panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                          colour = "white"),
                          panel.grid.major.x = element_blank(),
                          # Add axis line
                          axis.line = element_line(colour = "white"),
                          # Ajusting labs 
                          plot.title = element_text(color = "white",
                                                    size = 18),
                          axis.title.x = element_text(color = "white",
                                                      size = 14),
                          axis.title.y = element_text(color = "white",
                                                      size = 14),
                          axis.ticks = element_line(colour = "white"),
                          axis.text = element_text(color = "white",
                                                   size = 11),
                          axis.text.x = element_text(color = "white",
                                                     size = 11),
                          legend.background = element_rect(fill = cor, 
                                                           colour = "white"),
                          legend.text = element_text(color = "white",
                                                     size = 9),
                          legend.title = element_text(color = "white",
                                                      size = 11),
                          legend.key = element_rect(fill = cor, 
                                                    colour = "white"),
                          plot.caption = element_text(color = "white",
                                                      size = 9,
                                                      face = "italic"))
}

ggplot(data = media_variancia_df, mapping = aes(x = Volatilidade, 
                                                y = `Retorno Medio`, 
                                                colour = Classificacao,
                                                label = Acao)) +
  geom_point() +
  ggrepel::geom_text_repel(vjust = -1) +
  labs(x = "Volatilidade",
       y = "Retorno M�dio",
       title = "Risco-Retorno",
       caption = "Dados de 30/09/2015 at� 30/09/2020
       Fonte: Yahoo Finance",
       legend = "Classifica��o") +
  scale_x_continuous(labels = scales::percent) +
  scale_y_continuous(labels = scales::percent) +
  tema_trabalho_G2.2


matplot(retornos*100, type = "l", lty = 1, 
        x = as.Date(index(retornos)),
        main = "Retorno Di�rio de cada ativo",
        xlab = "Data",
        ylab = "Retornos (%)") # Observando subidas e descidas de cada uma das a��es


# Markowitz ---------------------------

# Quantas n observa��es para realizar Markowitz?

n = 5000

# Quantos ativos para realizar a simula��o?

x = 3


# Para cronometrar em quanto tempo a simul��o roda

come�o_markov = Sys.time()

{
  
# Sorteando as a��es
  
acoes_sorteadas = sample(tickers_acoes, # Tickers de todas as a��es que temos dados
                         size = x, # Valor estabelecido acima; quantos devemos sortear
                         replace = FALSE) # N�o queremos escolher a mesma a��o mais de uma vez
print(acoes_sorteadas) # Mostra quais s�o essas a��es que foram sorteadas


# Retorno/Vol das a��es escolhidas

dados_sorteados = media_variancia_df %>%
  dplyr::filter(Acao %in% acoes_sorteadas) %>%
  arrange(factor(Acao, levels = acoes_sorteadas))


retornos_sorteados = retornos[,acoes_sorteadas]

retornos_sorteados = xts::xts(retornos_sorteados, index(retornos)) # S�ries temporais dos retornos das a��es


Cov_sorteados = cov(retornos_sorteados) # Matriz de covari�ncia das a��es
View(cor(Cov_sorteados)) # Matriz de correla��o sendo visualizada


# Matriz de pesos

w = matrix(data = actuar::rpareto(n*x, # Pesos com distribui��o de Pareto
                                  shape = 1,
                                  scale = 1),
           nrow = n, # Cada linha � uma carteira; temos, ent�o, n carteiras
           ncol = x,  # Quantidade de a��es por cada cadeira; temos, ent�o, x a��es
           byrow = TRUE) # Temos aqui uma matriz de pesos com a maior combina��o de pesos poss�veis

for(i in c(1:n)) {
  
  w[i,] = w[i,] / sum(w[i,]) # Normalizando para a soma de pesos ser igual a 1 (100%) em cada carteira (linha)
  
}


# Montando a volatilidade para cada peso e cada carteira
# Usaremos a forma alg�brica

vol_w = rep(NA, n)

for(i in c(1:n)) {
  
  w_momento = matrix(data = w[i,],
                     ncol = 1)
  
  # Transposta do vetor de peso da carteira i
  # multiplica��o matricial matriz de covari�ncia
  # multiplica��o matricial do vetor de peso da carteira i
  
  
  vol_momento = sqrt( t(w_momento) %*% Cov_sorteados %*% w_momento )
  
  # Armazenando a volatilidade de cada carteira
  
  vol_w[i] = vol_momento
  
}

# Montando o retorno para cada peso

ret_w = rep(NA, n)

# Peso de cada a��o no retorno; 
# ser� apagado a cada itera��o

soma = rep(NA, x) 

for(i in c(1:n)) {
  
  for(j in c(1:x)) {
    
    # Peso aleat�rio vezes retorno m�dio de cada a��o
    
    soma[j] = w[i,j] * dados_sorteados$`Retorno Medio`[j]
    
  }
  
  # Retorno da carteira � a soma dos retornos de cada a��o
  
  ret_w[i] = sum(soma)
  
}

# Unindo ambas informa��es em um dataframe apenas:

markowitz = tibble(ret_w, vol_w)

markowitz = markowitz %>%
  mutate(Sharpe = (ret_w-benchmark)/vol_w)

names(markowitz) = c("Retorno Medio", "Volatilidade", "Sharpe")




# Montando a fronteira eficiente:

# Pontos para cada valor de retorno que apresentam 
# a menor vari�ncia poss�vel.

# Fazendo a fronteira � m�o:

# Pegando pontos entre o menor e o maior valor 
# de retorno das carteiras simuladas

ret_vec_front = seq(min(ret_w), max(ret_w), length.out = 1000) 

vol_vec_front = sapply(ret_vec_front, function(er) {
  
  # Pacote {tseries}
  
  op = portfolio.optim(as.matrix(retornos_sorteados), er, 
                       shorts = FALSE, # Posi��es compradas apenas -> n�o existem pesos negativos nesse exemplo
                       riskless = FALSE) # Queremos apenas o valor da carteira de m�nima vari�ncia
  
  # Menor vari�ncia poss�vel para cada ponto 
  
  return(op$ps)
  
}) # Armazenando os valores de vari�ncia m�nima para cada valor de retorno

fronteira_by_hand = tibble(ret_vec_front, vol_vec_front)

names(fronteira_by_hand) = c("Retorno Medio", "Volatilidade")



# Pacote {fPortfolio}
# Monta a simula��o apenas com esse c�digo

fronteira = portfolioFrontier(as.timeSeries(retornos_sorteados)) # Objeto que cont�m todas as informa��es que j� fizemos nesse c�digo

frontierPlot(fronteira,
             pch = 20,
             cex = 1.5,
             type = "o",
             lwd = 2) # Gr�fico da fronteira

singleAssetPoints(fronteira,
                  col = c(1:x),
                  pch = 20,
                  cex = 1.5) # Retorno/Vol de cada a��o

monteCarloPoints(fronteira,
                 mcSteps = n, # Quantidade de simula��es; mesmo valor que usamos no c�digo para simular "� m�o"
                 pch = 20,
                 cex = 0.1,
                 col = "steelblue") # Simula��es com pesos aleat�rios

# Dessa forma, todos os gr�ficos ficam na mesma imagem



# Distribui��o/comportamento de retorno e vol das carteiras simuladas

par(mfrow = c(1,2)) # Para vermos um gr�fico do lado do outro

hist(ret_w*100, breaks = 200, col = "#569E9B",
     xlab = NA,
     main = "Retornos das carteiras simuladas (%)") # Histograma dos retornos 

hist(vol_w*100, breaks = 200, col = "#FCF081",
     xlab = NA,
     main = "Volatilidade das carteiras simuladas (%)") # Histograma das volatilidades



# Carteira de m�nima vari�ncia

m�nima_vari�ncia = fronteira_by_hand %>%
  arrange(Volatilidade) %>%
  slice(1)



# Descobrindo a carteira �tima

�timo = IntroCompFinR::tangency.portfolio(er = dados_sorteados$`Retorno Medio`, # Retorno de cada a��o
                                          cov.mat = Cov_sorteados, # Matriz de covari�ncia
                                          risk.free = benchmark, # Taxa livre de risco (DI)
                                          shorts = FALSE) # Apenas posi��es compradas

ret_esp_�timo = �timo[[2]] # Retorno esperado da carteira �tima
vol_esp_�timo = �timo[[3]] # Volatilidade da carteira �tima

carteira_�tima = tibble(ret_esp_�timo, vol_esp_�timo)

names(carteira_�tima) = c("Retorno Medio", "Volatilidade")



# C�digo abaixo N�o utilizado no gr�fico

# Serve para tra�ar tangente entre a taxa de juros livre de risco
# com a carteira �tima

livre_de_risco = c(benchmark, 0)

livre_de_risco = rbind(livre_de_risco,carteira_�tima) 

# OBS: a tangente � curva na carteira �tima distancia muito da linha de pontos, dificultando sua visualiza��o;
# como j� achamos o ponto de tang�ncia, n�o � necess�rio observarmos a reta de tang�ncia.



# Visualizando os resultados

gr�fico_markovitz =
  ggplot(data = markowitz, mapping = aes(x = Volatilidade, 
                                         y = `Retorno Medio`,
                                         colour = Sharpe)) +
  geom_point(pch = 20,
             lwd = 0.4) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 0.01)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 0.01)) +
  scale_colour_gradient2(low = "red", high = "forestgreen", mid = "darkorange") +
  labs(title = paste0(n," simula��es e ",x," a��es"),
       y = "Retorno M�dio") +
  geom_point(data = fronteira_by_hand, mapping = aes(x = Volatilidade,
                                                     y = `Retorno Medio`),
             colour = "steelblue",
             pch = 20,
             lwd = 0.5) +
  geom_point(data = m�nima_vari�ncia, 
             colour = "red",
             lwd = 3) +
  geom_point(data = carteira_�tima,
             colour = "yellow",
             lwd = 3) +
  tema_trabalho_G2.2

gr�fico_dispers�o =
  ggplot(data = dados_sorteados, mapping = aes(x = Volatilidade, 
                                             y = `Retorno Medio`,
                                             colour = Classificacao,
                                             label = Acao)) +
  geom_point(data = dados_sorteados) +
  ggrepel::geom_text_repel(vjust = -1) +
  labs(x = "Volatilidade",
       y = "Retorno M�dio",
       title = gsub(" , "," ",toString(acoes_sorteadas)),
       caption = "Dados de 30/09/2015 at� 30/09/2020
       Fonte: Yahoo Finance") +
  scale_x_continuous(labels = scales::percent_format(accuracy = 0.01)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 0.01)) +
  tema_trabalho_G2.2

# No mesmo gr�fico:

gridExtra::grid.arrange(gr�fico_dispers�o, gr�fico_markovitz, nrow = 1)


# Para vermos os pesos �timos para cada a��o numa tabela:

pesos_�timos = �timo[[4]] # Pesos para cada ativo

matriz_�tima = matrix(data = NA,
                      nrow = 3,
                      ncol = length(acoes_sorteadas))

matriz_�tima[1,] = paste0(round(pesos_�timos*100, digits = 2),"%") # Pesos �timos
matriz_�tima[2,] = paste0(round(dados_sorteados$`Retorno Medio`*100, digits = 2),"%") # Retornos individuais
matriz_�tima[3,] = paste0(round(dados_sorteados$Volatilidade*100, digits = 2),"%") # Volatilidades individuais

matriz_�tima = as.data.frame(matriz_�tima, 
                             row.names = c("Pesos", "Retorno", "Volatilidade"))

names(matriz_�tima) = acoes_sorteadas


# Matriz de correla��o e pesos �timos em tabelas

grid.arrange(tableGrob(round(cor(Cov_sorteados), digits = 3)),
             tableGrob(matriz_�tima))

}

fim_markov = Sys.time()

tempo_markov = fim_markov - come�o_markov

print(tempo_markov) # Efici�ncia da simula��o



fim = Sys.time()

fim - come�o # Efici�ncia do c�digo como inteiro