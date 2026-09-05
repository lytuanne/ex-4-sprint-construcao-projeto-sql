-- MÓDULO 3: SPRINT SQL COM SQLITE (Migrado do DuckDB)

-- Projeto: Análise de Acidentes da PRF (2025)

-- 1. IMPORTAÇÃO E VIEW PRINCIPAL

-- A tabela 'acidentes_prf_2025' foi gerada a partir da importação 
-- do arquivo dados_brutos/acidentes2025.csv no banco prf_2025.sqlite.

DROP VIEW IF EXISTS vw_acidentes_base;

CREATE VIEW vw_acidentes_base AS
SELECT
    id,
    data_inversa,
    substr(data_inversa, 7, 4) AS ano,
    substr(data_inversa, 4, 2) AS mes,
    dia_semana,
    horario,
    uf,
    br,
    km,
    municipio,
    causa_acidente,
    tipo_acidente,
    classificacao_acidente,
    fase_dia,
    condicao_metereologica,
    tipo_pista,
    tracado_via,
    uso_solo,
    pessoas,
    mortos,
    feridos_leves,
    feridos_graves,
    ilesos,
    ignorados,
    feridos,
    veiculos,
    CASE
        WHEN CAST(mortos AS INTEGER) >= 1 THEN 1
        ELSE 0
    END AS acidente_fatal
FROM acidentes_prf_2025;


-- 2. CONSULTAS UNIVARIADAS

-- 2.1 Acidentes por UF

SELECT
    uf,
    COUNT(*) AS total_acidentes
FROM vw_acidentes_base
GROUP BY uf
ORDER BY total_acidentes DESC;

-- 2.2 Acidentes por BR

SELECT
    br,
    COUNT(*) AS total_acidentes,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos
FROM vw_acidentes_base
WHERE br IS NOT NULL
GROUP BY br
ORDER BY total_mortos DESC
LIMIT 20;

-- 2.3 Acidentes por Município

SELECT
    uf,
    municipio,
    COUNT(*) AS total_acidentes
FROM vw_acidentes_base
GROUP BY uf, municipio
ORDER BY total_acidentes DESC
LIMIT 30;

-- 2.4 Acidentes por Mês (Indicadores Mensais)

SELECT
    ano,
    mes,
    COUNT(*) AS total_acidentes,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY ano, mes
ORDER BY ano, mes;

-- 2.5 Acidentes por Tipo de Acidente

SELECT
    tipo_acidente,
    COUNT(*) AS total_acidentes
FROM vw_acidentes_base
GROUP BY tipo_acidente
ORDER BY total_acidentes DESC;

-- 2.6 Acidentes por Causa

SELECT
    causa_acidente,
    COUNT(*) AS total_acidentes
FROM vw_acidentes_base
GROUP BY causa_acidente
ORDER BY total_acidentes DESC;

-- 2.7 Acidentes por Condição Meteorológica (Clima)

SELECT
    condicao_metereologica,
    COUNT(*) AS total_acidentes
FROM vw_acidentes_base
GROUP BY condicao_metereologica
ORDER BY total_acidentes DESC;

-- 2.8 Acidentes por Tipo de Pista

SELECT
    tipo_pista,
    COUNT(*) AS total_acidentes
FROM vw_acidentes_base
GROUP BY tipo_pista
ORDER BY total_acidentes DESC;

-- 2.9 Acidentes por Fase do Dia

SELECT
    fase_dia,
    COUNT(*) AS total_acidentes
FROM vw_acidentes_base
GROUP BY fase_dia
ORDER BY total_acidentes DESC;



-- 3. CONSULTAS BIVARIADAS


-- 3.1 Bivariada por Tipo de Acidente (com HAVING e Percentuais)

SELECT
    tipo_acidente AS categoria,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY categoria
HAVING COUNT(*) >= 100
ORDER BY acidentes_fatais DESC;

-- 3.2 Bivariada por Causa do Acidente

SELECT
    causa_acidente,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY causa_acidente
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC
LIMIT 20;

-- 3.3 Bivariada por Condição Meteorológica

SELECT
    condicao_metereologica,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY condicao_metereologica
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;

-- 3.4 Bivariada por Fase do Dia

SELECT
    fase_dia,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY fase_dia
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;

-- 3.5 Bivariada por Tipo de Pista

SELECT
    tipo_pista,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY tipo_pista
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;

-- 4. EXPORTAÇÕES E VISÕES COMPLEMENTARES


DROP VIEW IF EXISTS vw_indicadores_mensais;
CREATE VIEW vw_indicadores_mensais AS
SELECT
    ano,
    mes,
    COUNT(*) AS total_acidentes,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY ano, mes
ORDER BY ano, mes;