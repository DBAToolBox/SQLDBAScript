
--Replace transaction number with yours

select * from dbo.MSarticles
where article_id IN 
(SELECT Article_id 
from MSrepl_commands
where xact_seqno = 0x0010984C00003FE0000400000000)
