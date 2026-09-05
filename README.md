# Projeto PRF 2025 - Migração DuckDB para SQLite

Este repositório contém a migração e consolidação do projeto de análise de dados de acidentes da Polícia Rodoviária Federal (PRF) de 2025, migrado do **DuckDB** para o **SQLite**. 

---

## 🎯 Objetivo da Sprint

Demonstrar a portabilidade do SQL e a reprodutibilidade analítica ao migrar o pipeline do DuckDB para SQLite. O projeto abrange a carga dos dados brutos, criação de views, engenharia de atributos, consultas univariadas e bivariadas, exportação de datasets e documentação técnica completa.

---

## 📁 Estrutura do Projeto

```text
projeto_prf/
│
├── dados_brutos/
│   └── acidentes2025.csv
│
├── sql/
│   └── modulo3_sqlite.sql
│
├── docs/
│   ├── README_SQL.md
│   ├── DICIONARIO_SQL.md
│   └── CONTROLE_QUALIDADE.md
│
├── resultados/
│   ├── indicadores_mensais.csv
│   ├── base_analitica_sql.csv
│   ├── base_modelavel_sql.csv
│   └── bivariada_tipo.csv
│
└── prf_2025.sqlite
