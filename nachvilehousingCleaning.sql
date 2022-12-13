/*-In this Project we'll be cleaning data using SQL--- */

/*---------------------Skilled used,Date format,Updating, modified  Address using  (join,parsename,substring),CASE statment,Alter table,Deleting duplicate columns,delete Unused columns */

--first step,Cleanning Data,let's Go--

SELECT*
FROM project.dbo.Nachvilehoussing

--------------------------------------------------------------------------------------------------------------------------------------------------------------

/*--Unite DATE format---------------------*/
SELECT
--saledate, 
CAST(saledate AS DATE)  AS Date_of_sale
FROM project.dbo.Nachvilehoussing

ALTER TABLE Nachvilehoussing
ADD Date_of_sale DATE;

UPDATE nachvilehoussing 
SET saledate = CAST(saledate AS DATE) 
--WHERE saledate = CAST(saledate AS DATE) 

/*-------------------populate property Address Data---------*/
SELECT*
--propertyaddress
FROM project.dbo.Nachvilehoussing
------------------------------------------
------------------------------------------
SELECT
p.ParcelID,
p.PropertyAddress,
n.ParcelID,
n.PropertyAddress,
ISNULL(p.PropertyAddress,n.PropertyAddress) AS Property_Address
FROM project.dbo.Nachvilehoussing P
JOIN project.dbo.Nachvilehoussing n
ON P.ParcelID = n.ParcelID
AND p.[UniqueID ] <> n.[UniqueID ]
WHERE P.PropertyAddress IS NULL

UPDATE p 
SET  PropertyAddress = ISNULL(p.PropertyAddress,n.PropertyAddress)
FROM project.dbo.Nachvilehoussing P
JOIN project.dbo.Nachvilehoussing n
ON P.ParcelID = n.ParcelID
AND p.[UniqueID ] <> n.[UniqueID ]
WHERE P.PropertyAddress IS NULL

/*SELECT
p.ParcelID,
p.PropertyAddress,
n.ParcelID,
n.PropertyAddress
FROM project.dbo.Nachvilehoussing P
JOIN project.dbo.Nachvilehoussing n
ON P.ParcelID = n.ParcelID
--AND p.[UniqueID ] <> n.[UniqueID ]
WHERE P.PropertyAddress IS NULL*/

/*---------------------------------We'll be breaking out Address into seprate columns(Address,city,state)---------------*/
SELECT
propertyaddress
FROM project.dbo.Nachvilehoussing

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) AS Address
FROM project.dbo.Nachvilehoussing

-------

ALTER TABLE project.dbo.Nachvilehoussing
ADD splitAdrress NVARCHAR(250);

UPDATE project.dbo.Nachvilehoussing
SET splitAdrress =SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

--------

ALTER TABLE project.dbo.Nachvilehoussing
ADD spliteCity NVARCHAR(250);

UPDATE project.dbo.Nachvilehoussing
SET spliteCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress))

SELECT*
--propertyaddress
FROM project.dbo.Nachvilehoussing



SELECT
OwnerAddress
FROM project.dbo.Nachvilehoussing

SELECT
PARSENAME(REPLACE(OwnerAddress , ',' ,'.') ,3),
PARSENAME(REPLACE(OwnerAddress , ',' ,'.') ,2),
PARSENAME(REPLACE(OwnerAddress , ',' ,'.') ,1)
FROM project.dbo.Nachvilehoussing



ALTER TABLE project.dbo.Nachvilehoussing
ADD ownersplitAddress NVARCHAR(250);

UPDATE project.dbo.Nachvilehoussing
SET ownersplitAddress = PARSENAME(REPLACE(OwnerAddress , ',' ,'.') ,1)

--------

ALTER TABLE project.dbo.Nachvilehoussing
ADD ownerspliteCity NVARCHAR(250);

UPDATE project.dbo.Nachvilehoussing
SET ownersplitecity  = PARSENAME(REPLACE(OwnerAddress , ',' ,'.') ,2)

ALTER TABLE project.dbo.Nachvilehoussing
ADD ownersplitestate NVARCHAR(250);

UPDATE project.dbo.Nachvilehoussing
SET ownersplitestate  = PARSENAME(REPLACE(OwnerAddress , ',' ,'.') ,3)

SELECT
OwnerName AS owener_Name,
PropertyAddress AS property_Address,
SaleDate AS sale_date,
SalePrice AS sale_price,
YearBuilt AS year_of_bulit,
TotalValue AS total_Value,
TaxDistrict AS Tax_district
FROM project.dbo.Nachvilehoussing

/*--------------------------------------------rename "Y" with "Yes" and "N" With "NO" in the 'SoldAsVacant' coloumn-----------------------*/
SELECT DISTINCT
SoldAsVacant
FROM project.dbo.Nachvilehoussing

SELECT 
soldasvacant,
CASE soldasvacant WHEN 'Y' THEN 'YES' WHEN 'N' THEN 'NO' ELSE soldasvacant END AS sold_as_vacant
FROM project.dbo.Nachvilehoussing 

UPDATE project.dbo.Nachvilehoussing 
SET SoldAsVacant = CASE soldasvacant WHEN 'Y' THEN 'YES' WHEN 'N' THEN 'NO' ELSE soldasvacant END --AS sold_as_vacant

/*------------------------------Deleting Duplicate from Nachvilehoussing  table------------------*/

WITH RowNumCTE AS (
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY parcelId,
propertyAddress,
saleprice,
uniqueid,
owneraddress,
legalreference,
saledate
ORDER BY uniqueid
) AS Row_num
FROM project.dbo.Nachvilehoussing 
) 
SELECT*
FROM RowNumCTE
WHERE Row_num >= 1
ORDER BY ParcelID

/*------------------------------Delete  Unused columns--------------*/

SELECT*
FROM project.dbo.Nachvilehoussing 

ALTER TABLE project.dbo.Nachvilehoussing 
DROP COLUMN owneraddress,taxdistrict,propertyaddress