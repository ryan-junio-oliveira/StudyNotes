# 13. Projeto Final — Consultas de Negócio

> Parte do [Curso Completo de SQL](./README.md) — Todas as consultas rodam no [`projeto-catalogo-filmes.sql`](./projeto-catalogo-filmes.sql)

## 13.1 Top 5 filmes por média dos usuários

```sql
SELECT f.titulo, ROUND(AVG(a.nota),2) AS media_usuarios, COUNT(*) AS votos
FROM filmes f JOIN avaliacoes a ON a.filme_id = f.id
GROUP BY f.id, f.titulo
HAVING COUNT(*) >= 2
ORDER BY media_usuarios DESC, votos DESC
LIMIT 5;
```

## 13.2 Recomendação: filmes do mesmo gênero que o usuário mais avaliou bem

```sql
WITH genero_favorito AS (
    SELECT fg.genero_id, AVG(a.nota) AS media
    FROM avaliacoes a
    JOIN filme_generos fg ON fg.filme_id = a.filme_id
    WHERE a.usuario_id = 1
    GROUP BY fg.genero_id
    ORDER BY media DESC LIMIT 1
)
SELECT f.titulo, f.nota_imdb
FROM filmes f
JOIN filme_generos fg ON fg.filme_id = f.id
WHERE fg.genero_id = (SELECT genero_id FROM genero_favorito)
  AND f.id NOT IN (SELECT filme_id FROM avaliacoes WHERE usuario_id=1);
```

## 13.3 Diretores com maior média (mín. 2 filmes)

```sql
SELECT d.nome, COUNT(f.id) AS filmes, ROUND(AVG(f.nota_imdb),2) AS media_imdb
FROM diretores d JOIN filmes f ON f.diretor_id = d.id
GROUP BY d.id
HAVING COUNT(f.id) >= 2
ORDER BY media_imdb DESC;
```

## 13.4 Filmes sem avaliação

```sql
SELECT f.titulo FROM filmes f
LEFT JOIN avaliacoes a ON a.filme_id = f.id
WHERE a.id IS NULL;
```

## 13.5 Ranking com Window Function

```sql
SELECT titulo, nota_imdb,
       RANK() OVER (ORDER BY nota_imdb DESC) AS posicao_global,
       RANK() OVER (PARTITION BY diretor_id ORDER BY nota_imdb DESC) AS posicao_no_diretor
FROM filmes;
```

## 13.6 Estatísticas por gênero

```sql
SELECT g.nome AS genero, COUNT(DISTINCT f.id) AS total_filmes,
       ROUND(AVG(f.nota_imdb),2) AS media_imdb,
       ROUND(AVG(a.nota),2) AS media_usuarios
FROM generos g
JOIN filme_generos fg ON fg.genero_id = g.id
JOIN filmes f ON f.id = fg.filme_id
LEFT JOIN avaliacoes a ON a.filme_id = f.id
GROUP BY g.nome;
```

---

⬅️ [Anterior: Transações/Procedures](./12-transacoes-procedures-triggers.md) | [Próximo: Boas Práticas e Apêndice](./14-boas-praticas-apendice.md) | [Sumário](./README.md)
