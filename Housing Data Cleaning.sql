SELECT *
FROM PortfolioProject..Housing




--Reformatting Date
SELECT SaleDateConverted, CONVERT(date,SaleDate)
FROM PortfolioProject..Housing

UPDATE Housing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE Housing
ADD SaledateConverted Date;

Update Housing
SET SaleDateConverted = CONVERT(date,SaleDate)



--Populating Property Address Date
SELECT x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM PortfolioProject..Housing x
JOIN PortfolioProject..Housing y
	ON x.ParcelID = y.ParcelID
	AND x.[UniqueID ] <> y.[UniqueID ]
WHERE x.PropertyAddress is NULL

update x
SET PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM PortfolioProject..Housing x
JOIN PortfolioProject..Housing y
	ON x.ParcelID = y.ParcelID
	AND X.[UniqueID ] <> y.[UniqueID ]
WHERE x.PropertyAddress is NULL


--Seperating the Address Into Individual Columns (Address, City, State)
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City

FROM PortfolioProject..Housing

ALTER TABLE Housing
ADD PropertySplitAddress NVARCHAR(255);

Update Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Housing
ADD PropertySplitCity NVARCHAR(255);

Update Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



SELECT PARSENAME(REPLACE(Owneraddress, ',', '.') ,3),
PARSENAME(REPLACE(Owneraddress, ',', '.') ,2),
PARSENAME(REPLACE(Owneraddress, ',', '.') ,1)

FROM PortfolioProject..Housing


ALTER TABLE Housing
ADD OwnerSplitAddress NVARCHAR(255);

Update Housing
SET  OwnerSplitAddress= PARSENAME(REPLACE(Owneraddress, ',', '.') ,3)



ALTER TABLE Housing
ADD OwnerSplitCity NVARCHAR(255);

Update Housing
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress, ',', '.') ,2)



ALTER TABLE Housing
ADD OwnerSplitState NVARCHAR(255);

Update Housing
SET OwnerSplitState = PARSENAME(REPLACE(Owneraddress, ',', '.') ,1)




--Changing X & Y to Yes & No in "SoldAsVacant" column
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..Housing
GROUP BY SoldAsVacant

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject..Housing

UPDATE Housing
SET SoldasVacant = 
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


	  
--Removing extra columns
ALTER TABLE Housing
DROP COLUMN OwnerAddress, TaxDistrict, propertyAddress, SaleDate