use Distribution
go

With MaxXact (ServerName, DistAgentName, PublisherDBID, XactSeqNo)
 As (Select S.name, DA.name, DA.publisher_database_id, max(H.xact_seqno)
 From distribution.dbo.MSdistribution_history H with(nolock)
 Inner Join distribution.dbo.MSdistribution_agents DA with(nolock) On DA.id = H.agent_id
 Inner Join master.sys.servers S with(nolock) On S.server_id = DA.subscriber_id
 Group By S.name, DA.name, DA.publisher_database_id)
 
Select MX.ServerName, MX.DistAgentName, MX.PublisherDBID, COUNT(*) As TransactionsNotReplicated
From distribution.dbo.msrepl_transactions T with(nolock)
Right Join MaxXact MX On MX.XactSeqNo < T.xact_seqno And MX.PublisherDBID = T.publisher_database_id
Group By MX.ServerName, MX.DistAgentName, MX.PublisherDBID;