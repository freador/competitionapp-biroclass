# Competition App

Aplicacao Rails 8 para criar competicoes, gerenciar convites de jurados e gerar rankings automaticos.

## Desenvolvimento local

- Execute `bin/setup` para instalar dependencias, preparar o banco PostgreSQL local e aplicar seeds iniciais.
- Suba o ambiente com `bin/dev`, que inicia Rails, Tailwind e watchers Hotwire.

## Deploy no Railway

1. **Fonte Docker:** crie um servico apontando para este repositorio e mantenha o builder padrao Docker, que utilizara o `Dockerfile` ja configurado.
2. **Comandos por servico:**  
   - Web: `./bin/thrust ./bin/rails server`.  
   - Solid Queue worker dedicado (opcional): `./bin/rails solid_queue:supervisor`.
3. **Volume persistente:** anexe um volume e monte-o em `/rails/storage` para preservar uploads do Active Storage entre deploys.
4. **Banco de dados:** adicione um servico PostgreSQL no Railway e exponha o `DATABASE_URL` para a aplicacao web e para o worker.

### Variaveis de ambiente

Configure as variaveis abaixo no painel do Railway (ou via CLI). Valores marcados como *padrao* ja sao definidos no `Dockerfile`, podendo ser sobrescritos conforme necessario:

| Variavel | Obrigatorio? | Valor padrao | Descricao |
| --- | --- | --- | --- |
| `RAILS_MASTER_KEY` | Sim | - | Chave para descriptografar `config/credentials`. |
| `DATABASE_URL` | Sim | - | URL completa do banco PostgreSQL provisionado no Railway. |
| `RAILS_ENV` | Sim | `production` | Ambiente Rails. Mantenha `production` em deploy. |
| `PORT` | Sim | `3000` (Railway substitui) | Porta que o Railway atribui ao container. |
| `RAILS_SERVE_STATIC_FILES` | Sim | `true` | Permite que o Rails sirva assets pre-compilados. |
| `RAILS_LOG_TO_STDOUT` | Sim | `true` | Garante logs na saida padrao para o coletor do Railway. |
| `RAILS_LOG_LEVEL` | Opcional | `info` | Ajuste para `debug` apenas para troubleshooting. |
| `RAILS_MAX_THREADS` | Opcional | `5` | Threads por processo Puma. |
| `WEB_CONCURRENCY` | Opcional | `1` | Numero de workers Puma (escale conforme recursos). |
| `JOB_CONCURRENCY` | Opcional | `1` | Processos do Solid Queue supervisor. |
| `SOLID_QUEUE_IN_PUMA` | Opcional | `true` | Mantem jobs sendo executados junto ao web quando nao ha worker dedicado. |
| `RAILWAY_VOLUME_PATH` | Opcional | `/rails/storage` | Caminho interno usado pelo volume montado. |

> Observacao: secrets adicionais (tokens de convidado, credenciais externas etc.) devem ser declarados no painel do Railway conforme forem introduzidos na aplicacao.

Depois de configurar as variaveis, dispare o deploy pelo botao do Railway ou via `railway up`. Certifique-se de que `bin/rails db:prepare` roda com sucesso (o `ENTRYPOINT` do container ja cuida disso ao iniciar).
