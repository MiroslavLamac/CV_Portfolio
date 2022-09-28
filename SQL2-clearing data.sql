--Cleaning data in SQL Quaries

--Select * from PortfolioProject.dbo.NashvilleHousing



--Standardize Date Format
-------------------------------------------------------------------------------------
Select SaleDate, Convert(date, SaleDate) from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

Select SaleDateConverted from PortfolioProject.dbo.NashvilleHousing
-------------------------------------------------------------------------------------
-- Populate Property Address Data

Select * from PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID --Duplicity

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
-------------------------------------------------------------------------------------
   
-- Breaking out Addresss into idnvividual Columns (Address, City, State)

Select PropertyAddress from PortfolioProject.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as AdressStreet,--same as excel
SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as AdressCity
from PortfolioProject.dbo.NashvilleHousing

