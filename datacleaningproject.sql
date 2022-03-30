select *
from NashvilleHousing

-- Standardizing the date

select SaleDate, CONVERT(Date, SaleDate)
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--fill null values in the property address column

select *
from NashvilleHousing
order by ParcelID

--select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
--from NashvilleHousing a
--JOIN NashvilleHousing b
--   on a.ParcelID = b.ParcelID
--   AND a.[UniqueID ] <> b.[UniqueID ]
--   where a.PropertyAddress is null

update a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null


---breaking out address column into individual columns

select PropertyAddress
from NashvilleHousing


select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
 from NashvilleHousing

 ALTER TABLE NashvilleHousing
Add PropertySplitAddress varchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity varchar(255);

update NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


select *
from NashvilleHousing


select OwnerAddress
from NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
from NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress varchar(255);

update NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity varchar(255);

update NashvilleHousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState varchar(255);

update NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


select OwnerAddress
from NashvilleHousing
where OwnerAddress is null


---Change Y and N to Yes and No in the Sold as Vacant colomn


select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
from NashvilleHousing


update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END



---The following can only be done to a copy of the data
---REMOVE DUPLICATES

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from NashvilleHousing
--order by ParcelID
 )
SELECT *
FROM RowNumCTE
where row_num > 1
--order by PropertyAddress


----delete unused columns

Select *
from NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate


