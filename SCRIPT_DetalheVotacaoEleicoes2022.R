################################################################################
# Análise dos detalhe de votação nas eleições 2022 (Fatorial PCA)
# Dados obtidos em:
# https://sig.tse.jus.br/ords/dwapr/seai/r/sig-eleicao/estatisticas-eleicao?session=202624093615400
# José Caetano Beuker
# 17.12.2022
################################################################################
# Pacotes necessários
pacotes <- c("plotly", # plataforma gráfica
             "tidyverse", # carregar outros pacotes do R
             "ggrepel", # geoms de texto e rótulo para 'ggplot2' que ajudam a
             # evitar sobreposição de textos
             "reshape2",# função 'melt'
             "knitr", "kableExtra", # formatação de tabelas
             "PerformanceAnalytics", # função 'chart.Correlation' para plotagem
             "factoextra", # facilita a extração e visualização de dados multivalorados
             "psych", # elaboração da fatorial e estatísticas
             "ltm", # determinação do alpha de Cronbach pela função 'cronbach.alpha'
             "Hmisc", # matriz de correlações com p-valor
             "tigris", # baixar e usar arquivos formatados de fronteiras cartográficas
             "dplyr" # Realizar a transformação de dados
             )

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T)
} else {
  sapply(pacotes, require, character = T)
}

# Carregando a base de dados
library(readr)
detalhe_votacao <- read_delim("detalhe_votacao.csv",
                      delim = ";", escape_double = FALSE,
                      locale = locale(encoding = "WINDOWS-1252"),
                      trim_ws = TRUE)
View(detalhe_votacao)

# Objeto detalhes de MG
DetalhaMG <- detalhe_votacao[detalhe_votacao$sg_uf == "MG",]

# Estatísticas descritivas das variaveis
summary(DetalhaMG[,7:17])

# Coeficientes de correlação de Pearson para cada par de variáveis
rho <- rcorr(as.matrix(DetalhaMG[,7:17]), type="pearson")

corr_coef <- rho$r # matriz de correlações
corr_sig <- round(rho$P, 5) # matriz com p-valor dos coeficientes

# Elaboação de um mapa de calor das correlações de Pearson entre as variáveis
ggplotly(
  DetalhaMG[,7:17] %>%
    cor() %>%
    melt() %>%
    rename(Correlação = value) %>%
    ggplot() +
    geom_tile(aes(x = Var1, y = Var2, fill = Correlação)) +
    geom_text(aes(x = Var1, y = Var2, label = format(Correlação, digits = 1)),
              size = 5) +
    scale_fill_viridis_b() +
    labs(x = NULL, y = NULL) +
    theme_bw()
)

# Visualização das distribuições das variáveis, scatters, valores das correlações
chart.Correlation(DetalhaMG[,7:17], histogram = TRUE, pch = "+")

# Teste de efericidade de Bartlett
cortest.bartlett(DetalhaMG[,7:17])

