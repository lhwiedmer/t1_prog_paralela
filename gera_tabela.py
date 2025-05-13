import pandas as pd

# Ler o arquivo separado por |
df = pd.read_csv('avg_results.txt', sep='|')

# Encontrar o índice do menor tempo por (TAM, Threads)
idx = df.groupby(['tam', 'threads'])['elapsed_avg'].idxmin()

# Filtrar as linhas com os melhores tempos
melhores = df.loc[idx]

# Criar a coluna formatada tempo/desvio/blocking
melhores['TempoDesvio'] = (
    melhores['elapsed_avg'].map(lambda x: f"{x:.2f}") + '/' +
    melhores['elapsed_std'].map(lambda x: f"{x:.3f}")
)


# Pivotar a tabela
tabela = melhores.pivot(index='tam', columns='threads', values='TempoDesvio')

# Ordenar colunas, se quiser
tabela = tabela.reindex(columns=sorted(tabela.columns))

# Exibir resultado
tabela.to_csv("tabela_final.csv")  # formato padrão com vírgulas

