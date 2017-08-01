
-- show all Articles
--sp_helpsubscription


use Distribution
go

sp_helpsubscriptionerrors  @publisher = 'PublishedServerName'
        ,  @publisher_db =  'PublisherDBName' 
        ,  @publication =  'PublicationName' 
        ,  @subscriber =  'SubscriberServerName' 
        ,  @subscriber_db =  'SubscriberDBName'