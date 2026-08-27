# 01. Introdução — O que é Git (e por que não é só "salvar")

> Parte do [Curso Completo de Git](./README.md) — Projeto **portfolio** em `projeto-portfolio/`

## 1.1 Sem Git vs com Git

| Sem Git | Com Git |
|---------|---------|
| `portfolio_v1.zip`, `portfolio_v2_final.zip`, `portfolio_FINAL2.zip` | Um diretório com histórico: `git log` mostra quem, quando e por quê mudou cada linha |
| Medo de apagar | `git revert` ou `git reflog` desfaz |

## 1.2 Distribuído e snapshots

- **Centralizado (SVN):** servidor único — sem internet, sem histórico.
- **Distribuído (Git):** todo clone tem **todo histórico** (`.git/`). Sem internet você commita; com internet `push`.

Git não guarda *diferenças*, guarda **snapshots**: cada `commit` é uma foto do projeto + ponteiro para o(s) pai(s).

```
commit a1b2c3 (HEAD -> main)  foto do portfolio/index.html em 27/08
  ↑
commit 9f8e7d  foto anterior
```

## 1.3 Os 3 estados — a ideia mais importante

```
Working Directory  ── git add ──►  Staging Area (Index)  ── git commit ──►  Repository (.git)
    (arquivos)                      (pré-commit)                         (histórico)
     └─ git status mostra onde cada arquivo está ─┘
```

- **Working Directory:** seus arquivos no disco.
- **Staging:** `git add` coloca lá — é onde você **monta** o próximo commit (pode escolher `git add index.html` só).
- **Repository:** `git commit` congela o staging em um commit imutável.

> Entender isso explica 80% da confusão de iniciantes.

## 1.4 O que é `.git/`?

`git init` cria `portfolio/.git/`:

```
.git/objects  — todos os commits/blobs (conteúdo)
.git/refs/heads/main — arquivo texto com hash do último commit (a branch é só um ponteiro!)
.git/HEAD — onde você está (ex: "ref: refs/heads/main")
```

**Branch não é pasta** — é um **post-it** móvel apontando para um commit.

---

⬅️ [Sumário](./README.md) | ➡️ [02. Configuração e init](./02-configuracao.md)
