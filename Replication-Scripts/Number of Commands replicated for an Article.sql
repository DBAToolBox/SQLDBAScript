use [distribution]
GO

SELECT count(*) [Count of Reads], art.article as Article, publication as Publication
FROM MSrepl_commands cmds WITH (NOLOCK)
INNER JOIN MSarticles art WITH (NOLOCK) 
      ON art.article_id = cmds.article_id
INNER JOIN MSpublications pub WITH (NOLOCK)
      ON art.publication_id=pub.publication_id
GROUP BY art.article,pub.publication
ORDER BY [Count of Reads] DESC