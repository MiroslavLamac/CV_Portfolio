-- Porfolio insurance project
Use Insurance
Go
-- Step 1
-- 1. tha last date a claimant re-opened claim
Select ClaimantID, ReopenedDate 
from Insurance.dbo.Claimant


-- 2. the date an examiner was assigned a claim
Select PK, max(entrydate) as ExaminerAssignedDate
from ClaimLog
where FieldName = 'Examinercode'
Group by PK


-- 3. the last date an examiner published on the Reserving Tool for each claim
Select ClaimNumber, max(EnteredON) as LastSavedON
from Insurance.dbo.ReservingTool
where IsPublished = 1
Group by ClaimNumber





