
BEGIN TRAN;

UPDATE dbo.ABTableB
SET TableBValue = 'blah'
WHERE TableBId = 1;

UPDATE dbo.ABTableA 
SET TableAValue = 'blah'
WHERE TableAId = 1;

rollback tran