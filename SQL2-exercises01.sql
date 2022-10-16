Use Insurance
GO
-- Exercise porftolio

-- Select all the PDF files in the Attachment table that were enetered by "lnikki"
select * from Insurance.dbo.Attachment
where EnteredBy = 'lnikki'
	and FileName like '%.pdf'

--------------------------------------------------------------------------------------------
-- Find all the medical reserve type records in the Reserve type table
select * from Insurance.dbo.ReserveType
where ParentID = 1 OR reserveTypeID = 1

--------------------------------------------------------------------------------------------
-- Which claimants (denoted by ClaimandID) have at least 15 reserve changes?
Select ClaimantID, COUNT(*) as ReserveChangeClaim
from Insurance.dbo.Reserve
Group by ClaimantID
having COUNT(*) >= 15

--------------------------------------------------------------------------------------------
--Copy the Claim table schema (i.e. the table without any of the data) into a table called Claim2 
Select * into Insurance.dbo.Claim2 from Insurance.dbo.Claim --with data
select * from claim2

Select Top 0 * into Insurance.dbo.Claim2 from Insurance.dbo.Claim --without data
select * from claim2

--------------------------------------------------------------------------------------------
--How many of each document type are in the attachment table

Select 
PARSENAME(filename,1) as DocumentType, Count(*) AS CountDocu
From Insurance.dbo.Attachment
Group by PARSENAME(filename,1)
Order by CountDocu desc

Select RIGHT(filename,4) as documenttype, Count(1) as Counts
from Insurance.dbo.Attachment
Group by RIGHT(filename,4)
Order by Count(1) desc

--------------------------------------------------------------------------------------------
--Get the claim statuses for every patient that has a middle name.
Select p.MiddleName, cs.ClaimStatusID
from patient P
Inner join dbo.Claimant C ON p.PatientID = c.PatientID
Inner join dbo.ClaimStatus CS ON C.ClaimStatusID = CS.ClaimStatusID
where p.MiddleName != ''
order by cs.ClaimStatusID 

Select CS.ClaimStatusID, p.MiddleName, c.*
from Claimant C
Inner join dbo.ClaimStatus CS ON C.ClaimStatusID = CS.ClaimStatusID
Inner join Patient P ON p.PatientID = c.PatientID
where p.MiddleName <> ''
order by cs.ClaimStatusID

-------------------------------------------------------------------------------------------
/* Display the Claim Number and how many times each claim was locked or unlocked? (ClaimLogTable)
Include Claim Numbers that were never locked or unlocked */

select c.ClaimNumber,  COUNT(CL.pk) as LockCount
From claim C
left Join ClaimLog CL ON CL.PK = C.ClaimID and FieldName = 'LockedBy'
--Where cl.FieldName = 'LockedBy'
Group by c.ClaimNumber
order by LockCount

-------------------------------------------------------------------------------------------
-- What is the name of the patient on Claim Number 752663830-X?

select c.ClaimNumber, clm.PatientID, p.FirstName, p.MiddleName, p.LastName
from Claim c
inner join Claimant clm ON c.ClaimID = clm.ClaimID and c.ClaimNumber = '752663830-X'
--where c.ClaimNumber = '752663830-X'
inner join patient p ON p.PatientID = clm.PatientID

