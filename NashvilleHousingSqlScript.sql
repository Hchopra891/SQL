/*

Cleaning data in SQL Queries

SQL NASHVILLE HOUSING PROJECT

*/ 

select * 
from NashvilleHousing;

--------------------------------------------------------------------------------------------------

select saledateconverted, cast(SaleDate as  Date) as date
from NashvilleHousing;


select saledate, convert(date,SaleDate) as date
from NashvilleHousing
order by SaleDate


update NashvilleHousing
set SaleDate= cast(SaleDate as  Date);



alter table nashvillehousing
add saledateconverted date;

update NashvilleHousing
set SaleDateconverted= cast(SaleDate as  Date)


--------------------------------------------------------------------------------------------------
--- Populate the Property Address data


select *
from NashvilleHousing 
--where PropertyAddress is null;
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

update a
set propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 



--------------------------------------------------------------------------------------------------
-- Breaking Address into individual columns ( Address, City, State)

select PropertyAddress
from NashvilleHousing


select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)  as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(propertyaddress))  as Address
from NashvilleHousing



alter table nashvillehousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) 


--------

alter table nashvillehousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(propertyaddress))




select  PropertyAddress,Propertysplitaddress, propertysplitcity
from  NashvilleHousing




select owneraddress
from NashvilleHousing


select  owneraddress,
PARSENAME(  REPLACE(owneraddress, ',','.'),3),
PARSENAME(  REPLACE(owneraddress, ',','.'),2),
PARSENAME(  REPLACE(owneraddress, ',','.'),1)
from NashvilleHousing
where OwnerAddress is not null



alter table nashvillehousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(  REPLACE(owneraddress, ',','.'),3)


alter table nashvillehousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitcity = PARSENAME(  REPLACE(owneraddress, ',','.'),2)



alter table nashvillehousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(  REPLACE(owneraddress, ',','.'),1)



select OwnerAddress, ownersplitaddress, ownersplitcity, ownersplitstate
from NashvilleHousing


--------------------------------------------------------------------------------------------------
--Change Y to YES and N to NO in 'Sold as Vacant' Field

select
replace(SoldAsVacant,'No','N'),
replace(SoldAsVacant,'Yes','Y')
from NashvilleHousing

update NashvilleHousing 
set SoldAsVacant= replace(SoldAsVacant,'N','No') , replace(SoldAsVacant,'Y','Yes')

           
				



select distinct (soldasvacant), COUNT(soldasvacant)
from NashvilleHousing
group by SoldAsVacant
order by 2


select soldasvacant,
case 
	when soldasvacant= 'Y' then 'Yes'
	when soldasvacant= 'N' then 'No'
	else soldasvacant
	end
from NashvilleHousing


update NashvilleHousing 
set SoldAsVacant= case 
	when soldasvacant= 'Y' then 'Yes'
	when soldasvacant= 'N' then 'No'
	else soldasvacant
	end


----------------------------------------------------------------------------------------------------
--Remove duplicates

with RowNumCTE As (
select *,
ROW_NUMBER() over (
partition by parcelid , 
			 propertyaddress, 
			 saleprice, 
			 saledate,
			 legalreference
			 order by 
				uniqueid
					) row_num
from NashvilleHousing
--order by ParcelID
) 

select *
from RowNumCTE
where row_num>1
order by PropertyAddress

--used delete command here to delete the row_num >1, 
-- then used select statement to check. 
-- once delete is used, it is permanent. 

--------------------------------------------------------------------------------------------------

--Removing unused columns

select * 
from NashvilleHousing


alter table nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress

alter table nashvillehousing
drop column saledate
--drop is a permanent command, be cautious while using it


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-----------------------------------------END OF SESSION ------------------------------------------