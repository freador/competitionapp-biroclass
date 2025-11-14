# Repository Guidelines

## Project Structure & Module Organization
Core Rails code stays under `app/` with MVC folders mirroring naming in `test/`. Service objects or integrations belong in `lib/`, credentials and runtime tweaks live in `config/`, and background adapters (Solid Queue/Cable) keep their initializer files versioned. Assets flow through `app/assets` plus Tailwind, while persistent uploads land in `storage/`. Keep migrations, fixtures, and seeds aligned so environments remain reproducible.

## Build, Test, and Development Commands
`bin/setup` installs gems, provisions PostgreSQL, and seeds defaults. `bin/dev` (per `Procfile.dev`) boots Rails, Tailwind, and Hotwire watchers for local work. Database tasks: `bin/rails db:prepare` before running suites, `bin/rails db:migrate RAILS_ENV=test` when schema drifts. Execute `bin/rails test` (or `bin/rails test:system`) pre-push, `bundle exec rubocop` for style, and `bundle exec brakeman` for security linting.

## Coding Style & Naming Conventions
Use two-space indentation, snake_case for methods/locals, CamelCase for classes/modules, and plural controllers. Namespace service classes by feature (`Competitions::RankingJob`). Shared partials/components sit near their controller. Keep Tailwind utility classes grouped by layout → color → state for readability. Run RuboCop’s omakase config before committing to catch drifts early.

## Testing Guidelines
Minitest ships by default: place unit/controller tests in `test/models` and `test/controllers`, system specs in `test/system`, and fixtures in `test/fixtures`. Each new behavior needs a regression test plus fixture updates. Trigger `bin/rails test` locally, and include `bin/rails test:system` when touching Turbo behaviors or invite flows. Aim for deterministic data; favor factories/helpers when fixtures become complex.

## Commit & Pull Request Guidelines
Write imperative, scoped subjects (`Implement judge invite flow`) with optional bodies describing approach and trade-offs. Reference issues/tickets in the body, not the subject. Before requesting review: summarize the change, attach UI screenshots, link migrations or data scripts, and confirm `test`, `rubocop`, and `brakeman` results. Document environment changes (env vars, Brevo keys, Solid Queue tuning) in the PR description.

## 🏆 Documento de Especificação do Produto — Competition App
**Visão Geral:** plataforma web para criar competições, convidar jurados e obter rankings automáticos para qualquer categoria (fotos, vídeos, performances). Objetivos: criação rápida, avaliação ágil, ranking em tempo real, experiência simples e compartilhável.
**Stack:** Rails 8 backend e views com Tailwind; PostgreSQL; Deploy Railway (web + Solid Queue worker + volume `/storage`); autenticação Devise/built-in; Brevo para convites e notificações; Solid Queue/Solid Cable integrados.
**Modelos principais:** `User` (roles: user, admin, judge; convites e senhas), `Competition` (rules, status draft/open/closed, owner admin), `Participant` (opcional usuário), `Note` (score 0–10 + comentário), `Ranking` (total_score e position gerados via job). Relacionamentos seguem o esquema descrito e se refletem nos diretórios `app/models` e `db/migrate`.
**Fluxos & Regras:** criador configura competição, adiciona jurados/participantes e publica; admin gerencia ciclo de vida; jurado envia notas via dashboard depois de aceitar convite Brevo; participantes visualizam página pública (login opcional). Regras-chave: publicar exige ≥1 jurado e participante; nota por jurado/participante é única; rankings atualizam com jobs Solid Queue quando `Note` é criada/atualizada; ao encerrar, notas travam edição.
**Páginas & Segurança:** Landing e página pública exibem participantes/ranking; área autenticada inclui dashboard, CRUD de competições, tela de notas e configurações. Controle de acesso por role (admin CRUD completo, judge apenas notas, user cria competições, participant leitura). Convites usam tokens criptografados com Rails Encryption.
**Roadmap MVP (2 semanas):** Semana 1 cobre setup Rails/Tailwind, modelos, auth, CRUD e convites; Semana 2 entrega notas, ranking automático (`total_score = notes.average(:score)`), página pública, integração Brevo, deploy Railway, testes e ajustes. Extensões futuras: uploads multimídia, votação pública, mobile app, comentários, ranking ponderado e fases múltiplas.
