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


--Step 2
-- 1. Joining fields from different tables in the database
-- 2. Filtering out claims we do not want to include

select C.ClaimNumber
	,O.OfficeDesc
	,O.State
	,U.UserName
	,U.Title
	,U.Supervisor
	,CLS.ClaimStatusDesc
	,P.LastName + ',' + TRIM (P.FirstName + ' ' + P.MiddleName) as ClaimantName
	,CL.ReopenedDate 
	,CLT.ClaimantTypeDesc
	,U.ReserveLimit
	,RT.ReserveTypeDesc
	,(CASE 
		WHEN RT.ParentID IN (1, 2, 3, 4, 5) THEN RT.ParentID
		Else RT.reserveTypeID
		END) AS ReserveCostID
from Insurance.dbo.Claimant CL

LEFT Join Insurance.dbo.Claim C ON CL.ClaimID = C.ClaimID
LEFT Join Insurance.dbo.ClaimantType CLT ON CL.ClaimantTypeID = CLT.ClaimantTypeID  
LEFT Join Insurance.dbo.ClaimStatus CLS ON CL.claimStatusID = CLS.ClaimStatusID
LEFT Join Insurance.dbo.Patient P ON CL.PatientID = P.PatientID 
Inner Join Insurance.dbo.Users U ON C.ExaminerCode = U.UserName
Inner Join Insurance.dbo.Users U2 ON U.Supervisor = U2.UserName
Inner Join Insurance.dbo.Users U3 ON U2.Supervisor = U3.UserName
Inner Join Insurance.dbo.Office O ON U.OfficeID = O.OfficeID
LEFT Join Insurance.dbo.Reserve R ON CL.ClaimantID = R.ClaimantID
Inner Join Insurance.dbo.ReserveType RT ON RT.reserveTypeID = R.ReserveTypeID
Where CLS.ClaimStatusID = 1 OR (CLS.ClaimStatusID = 2 and CL.ReopenedReasonID <> 3)
	AND (RT.ParentID IN (1, 2, 3, 4, 5) or RT.reserveTypeID IN (1, 2, 3, 4, 5))



