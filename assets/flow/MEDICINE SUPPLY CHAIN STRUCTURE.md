SUPPLY CHAIN STRUCTURE:
1) Admin:
Roles of Admin:
* No role
* Supplier
* Transporter
* Manufacturer
* Wholesaler
* Distributer
* Pharma
* Revoke
Events:
* User Registration
* User Role Revoke
* User Role Ressign
Functions:
* Register User (registerUser)
* Revoke Role (revokeRole)
* Reassign Role (reassignRole)

2) User:
User Information:
* Name
* Location
* Etherium Address
* Role
Functions:
* Getting User Info (getUserInfo)	
* Get number of registered users (getUserCount)
* Getting user by Index values (getUserbyIndex)

3) Supplier:
Events:
* Raw Materials Supply Initialization:
o Product Id
o Supplier
o Shipper
o Reciever
       Functions:
* Create new Raw Package by Supplier (LAB) (createRawPackage)
* Get the Count of created packages by Supplier (LAB) (getPackagesCountS)
* Get PackageID by Indexed value of Stored Data (getPackageIdByIndexS)

4) Transporter:
Functions:
* Load Product(Medicine) for transporting from one location to another (loadConsingment)

5) Manufacturer:
Functions:
* Update Raw Materials recieved status by Manufacturer from LAB (rawMaterialsReceived)
* Get(verify) Raw Materials Package Count at Manufacturer (getPackagesCountManuf)
* Develop PackageID by Indexed value of stored data (getPackageIDByIndexManuf)
Events:
* Generate New Batch of Medicine from received Raw Materials (MedicineNewBatch)
o Batch Id
o Manufacturer Address
o Shipper Address
o Receiver Address
Functions:
* Manufacture Medicine Batch to send (manufactureMedicine)
* Get Medicine Batch Count to be manufactured and sent (getBatchesCountManuf)
* Develop Medicine Batch ID by indexed value of stored data (getBatchIdByIndexManuf)

6) Wholesaler:
Functions:
* Verify Medicine Batch Received (medicineReceived)
* Transfer from Wholesaler to Distributer (transferMedicineWholDist)
* Get Medicine Batch Count to Transfer (getBatchesCountWholDist)
* Get Medicine BatchID by indexed value of stored data (getBatchIdByIndexWholsDist)
* Develop Sub Contract ID of Medicine Batch Transfer in between Wholesaler to Distributer (getSubContractWholDist)

7) Distributer:
Transfer Medicine from Distributer to Pharmacy
Functions:
* Transfer Medicine from Distributer to Pharmacy (transferMedicineDtoP)
* Get Medicine Batch Count to be sent (getBatchesCountDistPhar)
* Get Medicine BatchID by Indexed value of stored data (getBatchIdByIndexDistPhar)
* Get SubContract ID of Medicine Batch Transfer in between Distributer to Pharmacy (getSubContractDP)

8) Pharmacy:
Functions:
* Medicine Batch Recieved from Distrubuter (medicineRecievedAtPharmacy)
Event:
Status of Medicines: (BatchID, Pharmacy, Status)
* Not Found
* At Pharmacy
* Sold,
* Expired
* Damaged
Functions:
* Update Medicine Batch status (updateMedStatus)
* Get Medicine Batch status (medInfo)
* Get Medicine Batch Count (getBatchesCountPhar)
* Get Medicine BatchID by indexed value of stored data (getBatchIdByIndexPhar)

