-- MÓDULO 3: SPRINT SQL COM SQLITE - EXPORTAÇÕES (Pasta resultados/)
-- Projeto: Análise de Acidentes da PRF (2025)

-- Configura o modo de saída para CSV
.mode csv
.headers on

-- 1. Gerar o arquivo indicadores_mensais.csv
.output resultados/indicadores_mensais.csv
SELECT
    substr(data_inversa, 7, 4) AS ano,
    substr(data_inversa, 4, 2) AS mes,
    COUNT(*) AS total_acidentes,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos,
    SUM(CASE WHEN CAST(mortos AS INTEGER) >= 1 THEN 1 ELSE 0 END) AS acidentes_fatais,
    ROUND(100.0 * SUM(CASE WHEN CAST(mortos AS INTEGER) >= 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS perc_fatais
FROM acidentes_prf_2025
GROUP BY ano, mes
ORDER BY ano, mes;

-- 2. Gerar o arquivo base_analitica_sql.csv
.output resultados/base_analitica_sql.csv
SELECT * 
FROM acidentes_prf_2025;

-- 3. Gerar o arquivo base_modelavel_sql.csv
.output resultados/base_modelavel_sql.csv
SELECT 
    uf, 
    br, 
    fase_dia, 
    condicao_metereologica, 
    tipo_pista, 
    mortos, 
    feridos, 
    veiculos
FROM acidentes_prf_2025;

-- 4. Gerar o arquivo bivariada_tipo.csv
.output resultados/bivariada_tipo.csv
SELECT 
    tipo_acidente, 
    classificacao_acidente, 
    COUNT(*) AS total
FROM acidentes_prf_2025
GROUP BY tipo_acidente, classificacao_acidente
ORDER BY total DESC;

-- Reseta a saída para o padrão da tela
.output stdout