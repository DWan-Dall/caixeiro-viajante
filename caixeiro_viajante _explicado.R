---
title: "Caixeiro Viajante"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## 1. Instalar pacotes se necessario
#  install.packages(c("dplyr", "ggplot2", "combinat"))

# install.packages("rmarkdown", "knitr")
# Rodar no bash para gerar o arquivo html
# Rscript -e "rmarkdown::render('caixeiro_viajante.Rmd')"

library(dplyr) # Biblioteca para manipulação de dados
library(ggplot2) # Biblioteca para geração de gráficos
library(combinat) # Biblioteca para permutação (força bruta) e combinações 

# Criar pasta 'resultados' para salvar saídas, se não existir
if (!dir.exists("resultados")) {
  dir.create("resultados")
}

## 2. Gerar coordenadas aleatórias para cidades no plano (0 a 100)
# se eu quiser determinar a quantidade de cidades eu defino em n = 7 ou no caso do código gerar_cidades(5)

gerar_cidades <- function(n) {
  set.seed(42) # Garante que a sequência de números aleatórios seja sempre a mesma (permite poder repetir os testes)
  tibble(
    cidade = paste0("C", 1:n), # Gera os nomes aleatórios com C1, C2 ...
    x = runif(n, 0, 100), 
    y = runif(n, 0, 100)
  )
}

print(gerar_cidades)

## 3. Calcular distância entre duas cidades
# Calcula a distância com a formula Euclidiana entre duas cidades (c1 e c2)
distancia <- function(c1, c2) {
  sqrt((c1$x - c2$x)^2 + (c1$y - c2$y)^2)
}

## 4. Calcular distância total de um caminho
calcular_distancia_total <- function(caminho, cidades) {
  total <- 0
  for (i in 1:(length(caminho)-1)) { # Calcula a distância entre cada cidade
    total <- total + distancia(cidades[caminho[i], ], cidades[caminho[i+1], ])
  }
  total <- total + distancia(cidades[caminho[length(caminho)], ], cidades[caminho[1], ]) # Volta para a primeira cidade depois de calcular o tamanho do caminho e soma o total da viagem
  return(total)
}

## 5. Aplica a força bruta
forca_bruta <- function(cidades) {
  inicio <- Sys.time() # Inicia a medição de tempo de execução
  perms <- permn(1:nrow(cidades)) # Gera os caminhos/permutações possíveis das cidades - uso da complexidade O(n!)
  melhor_dist <- Inf # melhor distência
  melhor_caminho <- NULL # Inicializa o melhor caminho como NULL pois ainda não temos um caminho encontrado

  for (p in perms) {
    d <- calcular_distancia_total(p, cidades) # Calcula a distância total do caminho atual para cada caminho da cidade
    if (d < melhor_dist) { # Se melhor caminho (distância do que a anterior ele atualiza as variáveis)
      melhor_dist <- d
      melhor_caminho <- p
    }
  }
  tempo <- Sys.time() - inicio # Termina a medição de tempo de execução
  return(list(caminho = melhor_caminho, distancia = melhor_dist, tempo = as.numeric(tempo, units = "secs"))) # retorna uma lista com o melhor caminho encontrado, a menor distância e o tempo usado
}

## 6. Aplica heurística do vizinho mais próximo
heuristica_vizinho <- function(cidades) {
  inicio <- Sys.time() # Inicia a medição de tempo de execução
  restantes <- 2:nrow(cidades) # Inicializa a contagem (lista) de cidades restantes retirando a primeira cidade
  atual <- 1 # Começa a viagem pela cidade 1
  caminho <- c(atual) # Pega a cidade atual

  while (length(restantes) > 0) { # Enquanto ainda houver cidades não visitadas
    proximo <- restantes[which.min(sapply(restantes, function(i) distancia(cidades[atual, ], cidades[i, ])))] # Faz a contagem da próxima - uso da complexidade O(n^²)
    caminho <- c(caminho, proximo) # Adiciona na listade do camhinho percorrido
    restantes <- setdiff(restantes, proximo) #  Remove a cidade escolhida da lista de restantes
    atual <- proximo # Atualiza a cidade atual
  }

  tempo <- Sys.time() - inicio # Termina a medição de tempo de execução
  return(list(caminho = caminho, distancia = calcular_distancia_total(caminho, cidades), tempo = as.numeric(tempo, units = "secs"))) # retorna uma lista com o melhor caminho encontrado, a menor distância e o tempo usado
}

## 7. Faz testes para vários tamanhos de cidades (Executa Testes (De 5 até 8 cidades))
resultados <- tibble() #Cria uma tabela chamada resultados

for (n in 5:8) { # começa um loop para testar com vários tamanhos de entrada - n vai assumir os valores 5, 6, 7, 8 — ou seja, 4 testes com diferentes quantidades de cidades
  cidades <- gerar_cidades(n)
  res_bruto <- forca_bruta(cidades) # Chama sua função forca_bruta() e resolve por força bruta com esse conjunto de cidades (caminho, distância e tempo)
  res_heuristica <- heuristica_vizinho(cidades) ## Chama sua função heuristica_vizinho() e resolve por essa heurisca com esse conjunto de cidades (caminho, distância e tempo)

  resultados <- resultados %>% bind_rows(tibble( # Criando uma nova linha de dados com os resultados do teste.
    Cidades = n,
    Distancia_Bruta = round(res_bruto$distancia,2),
    Tempo_Bruta = round(res_bruto$tempo,4),
    Distancia_Heuristica = round(res_heuristica$distancia,2),
    Tempo_Heuristica = round(res_heuristica$tempo,4)
  ))
}

print(resultados) # Imprime os resultados

## 8. Gera Plot
grafico-resultado <- ggplot(resultados, aes(x = Cidades)) +
  geom_line(aes(y = Distancia_Bruta, color = "Bruta")) +
  geom_line(aes(y = Distancia_Heuristica, color = "Heuristica")) +
  labs(title = "Comparacao de Distancia", y = "Distancia Total", x = "Numero de Cidades") +
  theme_minimal() # Define o tipo de gráfico

# Mostrar o gráfico
print(grafico-resultado) 

# Salvar o gráfico
ggsave("resultados/grafico-resultado-outras-cidades.png", plot = grafico-resultado, width = 8, height = 6, dpi = 300)


## 9. Analisando crescimento (Big-O experimental)

# Gráfico de tempo de execução
grafico_tempo <- ggplot(resultados, aes(x = Cidades)) +
  geom_line(aes(y = Tempo_Bruta, color = "Bruta")) +
  geom_line(aes(y = Tempo_Heuristica, color = "Heuristica")) +
  scale_y_log10() + # Serve para comparar o visual, não usar log, o gráfico vai mostrar uma linha subindo absurdamente (força bruta) e a outra quase reta no chão (heurística).
  labs(title = "Tempo de Execucao - Forca Bruta vs Heuristica", 
       y = "Tempo (segundos)", x = "No de Cidades") +
  theme_minimal() # Define o tipo de gráfico

print(grafico_tempo)

# Salvar o gráfico também
ggsave("resultados/grafico-tempo.png", plot = grafico_tempo, width = 8, height = 6, dpi = 300)
