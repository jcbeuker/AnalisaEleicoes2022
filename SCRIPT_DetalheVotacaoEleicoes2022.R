################################################################################
# Análise dos detalhe de votação nas eleições 2022
# Dados obtidos em:
# https://sig.tse.jus.br/ords/dwapr/seai/r/sig-eleicao/estatisticas-eleicao?session=202624093615400
# José Caetano Beuker
# 17.12.2022
################################################################################
# Pacotes necessários
pacotes <- c("tidyverse","ggrepel","reshape2","knitr","kableExtra",
             "PerformanceAnalytics","factoextra","psych","tigris")

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
