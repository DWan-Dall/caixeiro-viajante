# Relatório: Análise do Problema do Caixeiro Viajante com Força Bruta e Heurística

## 1. Introdução

O Problema do Caixeiro Viajante (Traveling Salesman Problem - TSP) consiste em encontrar o caminho mais curto que permite visitar um conjunto de cidades exatamente uma vez e retornar à cidade de origem.

## 2. Algoritmos Utilizados

Neste trabalho, foram implementadas duas abordagens para resolver o TSP:

- **Força Bruta:** testa todos os caminhos possíveis para encontrar a melhor opção.
    - Gera todas as possíveis permutações das cidades;
    - Calcula a distância total de cada caminho;

- **Heurística Escolhida: Vizinho Mais Próximo** - pois aproxima uma solução em tempo muito mais rápido.
    - Começa em uma cidade;
    - Sempre escolhe a cidade mais próxima não visitada;

## 3. Metodologia

Foram geradas coordenadas aleatórias (x, y) para representar cidades, utilizando amostras de 5 a 8 cidades.

- Número de cidades variando de 5 a 8.
- Coordenadas geradas aleatoriamente no intervalo [0, 100].
- Medição dos tempos de execução e distâncias totais percorridas.
- Gráficos gerados para comparar desempenhos.

## 3.1 Ambiente de Desenvolvimento

- Linguagem: R
- Pacotes:
    - dplyr → manipulação de dados;
    - ggplot2 → criação de gráficos;
    - combinat → gerar todas as permutações (para a força bruta);
- Variáveis usadas:
    - `API_KEY`
- Relatório gerado em RMarkdown.

## 4. Resultados Obtidos:

| Cidades | Distância Bruta | Tempo Bruta (segundos) | Distância Heurística | Distância Heurística |
| ----------------- | ----------------- | ----------------- | ----------------- | ----------------- | 
| 5 | 196 | 0.027 | 200 | 0.0005 |
| 6 | 209 | 0.144 | 237 | 0.0006 |
| 7 | 229 | 1.17 | 239 | 0.0008 |
| 8 | 233 | 10.5 | 244 | 0.001 |

- Gráfico de Comparativo de Distâncias e Comparação de tempo (com escala logarítmica), salvo em resultados/grafico-resultado-outras-cidades.png.

## 5. Análise de Complexidade

- O gráfico logarítmico mostra que a força bruta cresce muito mais rapidamente que a heurística.
- Confirma o comportamento esperado de O(n!) versus O(n²).

## 4.1 Força Bruta

- Complexidade: O(n!)
- Explicação: Para n cidades, existem n! permutações possíveis de caminhos.

**Observação:** Muito ineficiente para número elevado de cidades; o tempo cresce exponencialmente.

## 4.2 Heurística do Vizinho Mais Próximo

- Complexidade: O(n^2)
- Explicação: Para cada cidade, busca-se a cidade mais próxima entre as restantes.

**Observação:** Rápido e eficiente para tamanhos moderados de instâncias, mas não garante solução ótima.

## 5. Conclusão

A abordagem de força bruta garante encontrar a rota ótima, mas é inviável para quantidades maiores de cidades devido ao crescimento exponencial do tempo de execução. A heurística do vizinho mais próximo provém soluções aproximadas muito mais rápidas, sendo adequada para problemas de tamanho médio ou quando é necessário sacrificar um pouco de qualidade pela rapidez.

O estudo demonstra claramente a diferença prática entre a busca exaustiva e heurísticas em problemas combinatórios.

A solução por força bruta, embora ótima, torna-se inviável para números maiores de cidades devido à sua complexidade fatorial. A heurística do vizinho mais próximo oferece soluções rápidas, ainda que não necessariamente ótimas, sendo prática para aplicações reais.

## 6. Anexos

Script R: caixeiro_viajante.Rmd

Gráfico: resultados/grafico-resultado-outras-cidades.png


<details>

<summary></summary>

### ✍️ Autoria
Projeto desenvolvido para o Mestrado Profissional em Computação Aplicada - UNIVALI<br>
Matéria: ANÁLISE DE ALGORITMOS<br>
Professor:
<br>
 - Rudimar Luiz Scaranto Dazzi
<br>

[@DWan-Dall](https://github.com/DWan-Dall)💜.

</details> 