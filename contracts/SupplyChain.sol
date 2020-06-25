pragma solidity >=0.4.25 <0.6.0;

import './RawMatrials.sol';
import './Medicine.sol';
import './MedicineWholDist.sol';
import './MedicineDistPhar.sol';

/// @title Blockchain : Medical SupplyChain
/// @author Ananth R
contract SupplyChain {

    /// @notice
    address public Admin;

    /// @notice
    /// @dev Initiate SupplyChain Contract
    constructor () public
    {
        Admin = msg.sender;
    }

//----------------------------------------------------------------------------------------------
    /********************* Admin Section ****************************/

    /// @dev Validate Admin
    modifier onlyAdmin() {
        require(msg.sender == Admin, "Only Admin can call this function.");
        _;
    }

    enum roles {
        norole,
        supplier,
        transporter,
        manufacturer,
        wholesaler,
        distributer,
        pharma,
        revoke
    }

    event UserRegister(address indexed EthAddress, bytes32 Name);
    event UserRoleRevoked(address indexed EthAddress, bytes32 Name, uint Role);
    event UserRoleRessigned(address indexed EthAddress, bytes32 Name, uint Role);

    /// @notice
    /// @dev Register New user by Admin
    /// @param EthAddress Ethereum Network Address of User
    /// @param Name Name of user (Username)
    /// @param Location Location of User
    /// @param Role Role of User
    function registerUser(address EthAddress, bytes32 Name, bytes32 Location, uint Role) public onlyAdmin
    {
      require(UsersDetails[EthAddress].role == roles.norole, "User Already registered");
      UsersDetails[EthAddress].name = Name;
      UsersDetails[EthAddress].location = Location;
      UsersDetails[EthAddress].ethAddress = EthAddress;
      UsersDetails[EthAddress].role = roles(Role);
      users.push(EthAddress);
      emit UserRegister(EthAddress, Name);
    }
    /// @notice
    /// @dev Revoke User's role
    /// @param userAddress User Ethereum Network Address
    function revokeRole(address userAddress) public onlyAdmin
    {
      require(UsersDetails[userAddress].role != roles.norole, "User not registered");
      emit UserRoleRevoked(userAddress, UsersDetails[userAddress].name,uint(UsersDetails[userAddress].role));
      UsersDetails[userAddress].role = roles(7);
    }
    /// @notice
    /// @dev Reassign New Role to User
    /// @param userAddress User Ethereum Network Address
    /// @param Role Role to be assigned
    function reassignRole(address userAddress, uint Role) public onlyAdmin
    {
      require(UsersDetails[userAddress].role != roles.norole, "User not registered");
      UsersDetails[userAddress].role = roles(Role);
      emit UserRoleRessigned(userAddress, UsersDetails[userAddress].name, uint(UsersDetails[userAddress].role));
    }

//------------------------------------------------------------------------------------------------------------------
    /******************* User Section ****************************/
    struct UserInfo
    {
      bytes32 name;
      bytes32 location;
      address ethAddress;
      roles role;
    }

    /// @notice
    mapping(address => UserInfo) UsersDetails;
    /// @notice
    address[] users;

    /// @notice
    /// @dev Get User Information
    /// @param User User Ethereum Network Address
    /// @return User Details of User
    function getUserInfo(address User) public view returns(bytes32 name, bytes32 location, address ethAddress, roles role)
    {
      return (UsersDetails[User].name, UsersDetails[User].location, UsersDetails[User].ethAddress, UsersDetails[User].role);
    }

    /// @notice
    /// @dev Get Number of registered Users
    /// @return Number of registered Users
    function getUsersCount() public view returns(uint count)
    {
      return users.length;
    }

    /// @notice
    /// @dev Get User by Index value of stored data
    /// @param index Indexed Number
    /// @return User Details of User
    function getUserbyIndex(uint index) public view returns(bytes32 name, bytes32 location, address ethAddress, roles role)
    {
        return getUserInfo(users[index]);
    }

//---------------------------------------------------------------------------------------------
    /************** Supplier Section (Raw Materials, From LAB) *********************/
    /// @notice
    mapping(address => address[]) supplierRawMaterialsInfo;
    event RawSupplyInit(
        address indexed ProductID,
        address Supplier,
        address indexed Shipper,
        address indexed Receiver
    );

    /// @notice
    /// @dev Create new Raw Package by Supplier
    function createRawPackage(
        bytes32 Des, //Description of Raw Materials
        bytes32 LN, //Lab Name
        bytes32 Loc, //Lab Location
        uint Quant, //Quantity
        address Shpr, //Shipper Address (Transporter)
        address Rcvr //Reciever Address (Manufacturer)
        ) public
        {
        require(UsersDetails[msg.sender].role == roles.supplier, "Only Supplier Can call this function ");
        RawMaterials rawData = new RawMaterials(
            msg.sender,
            Des,
            LN,
            Loc,
            Quant,
            Shpr,
            Rcvr
            );
        supplierRawMaterialsInfo[msg.sender].push(address(rawData));
        emit RawSupplyInit(address(rawData), msg.sender, Shpr, Rcvr); //Initialize Raw Materials Supply
    }

    /// @notice
    /// @dev  Get the Count of created packages by Supplier (LAB)
    /// @return Number of packages
    function getPackagesCountS() public view returns (uint count)
    {
        require(UsersDetails[msg.sender].role == roles.supplier, "Only Supplier Can call this function");
        return supplierRawMaterialsInfo[msg.sender].length; //No. of Pakages to be sent from LAB
    }

    /// @notice
    /// @dev Get PackageID by Indexed value of Stored Data (ID, Shipper and Reciever(Distributer))
    /// @param index Indexed Value
    /// @return PackageID
    function getPackageIdByIndexS(uint index) public view returns(address packageID)
    {
        require(UsersDetails[msg.sender].role == roles.supplier, "Only Supplier Can call this function");
        return supplierRawMaterialsInfo[msg.sender][index];
    }

//-----------------------------------------------------------------------------------------------------------------
    /*********** Transporter Section *********/

    /// @notice
    /// @dev Load Produec(Medicine) for transporting from one location to another.
    /// @param pid PackageID / MedicineID
    /// @param transportertype Transporter Type
    /// @param cid Contract ID for Transaction
    function loadConsingment(address pid, uint transportertype, address cid) public
    {
        require(UsersDetails[msg.sender].role == roles.transporter, "Only Transporter can call this function");
        require(transportertype > 0, "Transporter Type must be correct");

        if(transportertype == 1) // Supplier to Manufacturer
        {
            RawMaterials(pid).pickPackage(msg.sender);
        }
        else if(transportertype == 2) // Manufacturer to Wholesaler OR Manufacturer to Distributer
        {
            Medicine(pid).pickPackage(msg.sender);
        }
        else if(transportertype == 3) // Wholesaler to Distributer
        {
            MedicineWholDist(cid).pickWholDist(pid,msg.sender);
        }
        else if(transportertype == 4) // Distrubuter to Pharmacy
        {
            MedicineDistPhar(cid).pickDistPhar(pid,msg.sender);
        }
    }

//-------------------------------------------------------------------------------------------
    /************** Manufacturer Section ***************/
    /// @notice
    mapping(address => address[]) RawMaterialsAtManufacturer;

    /// @notice
    /// @dev Update Medicine recieved status by Manufacturer
    /// @param pid PackageID
    function rawMaterialsReceived(address pid) public
    {
        require(UsersDetails[msg.sender].role == roles.manufacturer, "Only manufacturer can call this function");
        RawMaterials(pid).receivedRawMaterials(msg.sender);
        RawMaterialsAtManufacturer[msg.sender].push(pid); //Check if Raw Materials Recieved
    }

    /// @notice
    /// @dev Get(verify) Raw Materials Package Count at Manufacturer
    /// @return Number of Packages at Manufacturer
    function getPackagesCountManuf() public view returns(uint count)
    {
        require(UsersDetails[msg.sender].role == roles.manufacturer, "Only Manufacturer can call this function");
        return RawMaterialsAtManufacturer[msg.sender].length; //Get Count of Materials
    }

    /// @notice
    /// @dev PackageID by Indexed value of stored data
    /// @param index Indexed Value
    /// @return PackageID
    function getPackageIDByIndexManuf(uint index) public view returns(address BatchID){
        require( UsersDetails[msg.sender].role == roles.manufacturer, "Only Manufacturer can call this function");
        return RawMaterialsAtManufacturer[msg.sender][index]; //Get Index Value of Materials
    }

    /// @notice
    mapping(address => address[]) ManufactureredMedicineBatches;
    event MedicineNewBatch(
        address indexed BatchId,
        address indexed Manufacturer,
        address shipper,
        address indexed Receiver
    );

    /// @notice
    /// @dev Medicine Batch to send
    /// @param Des Description of the Medicine Batch
    /// @param RM Raw Matrials Information
    /// @param Quant Quantity of Medicine Units
    /// @param Shpr Shipper (Transporter) Ethereum Network Address
    /// @param Rcvr Receiver Ethereum Network Address
    /// @param RcvrType Receiver Type Ethier Wholesaler(1) or Distributer(2)
    function manufactureMedicine(
        bytes32 Des,
        bytes32 RM,
        uint Quant,
        address Shpr,
        address Rcvr,
        uint RcvrType
    ) public
    {
        require(UsersDetails[msg.sender].role == roles.manufacturer, "Only Manufacturer can call this function");
        require(RcvrType != 0, "Receiver Type must be correct");

        Medicine m = new Medicine(
            msg.sender,
            Des,
            RM,
            Quant,
            Shpr,
            Rcvr,
            RcvrType
        );

        ManufactureredMedicineBatches[msg.sender].push(address(m));
        emit MedicineNewBatch(address(m), msg.sender, Shpr, Rcvr); //New Batch Manufactured and sending begins
    }

    /// @notice
    /// @dev Medicine Batch Count to be sent
    /// @return Number of Batches
    function getBatchesCountManuf() public view returns (uint count)
    {
        require(UsersDetails[msg.sender].role == roles.manufacturer, "Only Manufacturer Can call this function.");
        return ManufactureredMedicineBatches[msg.sender].length; //Batch Count to be sent Defined
    }

    /// @notice
    /// @dev Get Medicine BatchID by indexed value of stored data
    /// @param index Indexed Number
    /// @return Medicine BatchID
    function getBatchIdByIndexManuf(uint index) public view returns(address packageID)
    {
        require(UsersDetails[msg.sender].role == roles.manufacturer, "Only Manufacturer Can call this function.");
        return ManufactureredMedicineBatches[msg.sender][index]; //Batch ID of Batch to be sent Given
    }

//--------------------------------------------------------------------------------------------------------------
    /***************** Wholesaler Section ****************/
    /// @notice
    mapping(address => address[]) MedicineBatchesAtWholesaler;

    /// @notice
    /// @dev Medicine Batch Received
    /// @param batchid Medicine BatchID
    /// @param cid Contract ID for Medicine
    function medicineReceived(address batchid, address cid) public
    {
        require(UsersDetails[msg.sender].role == roles.wholesaler || UsersDetails[msg.sender].role == roles.distributer, "Only Wholesaler and Distributer can call this function");

        uint rtype = Medicine(batchid).receivedPackage(msg.sender);
        if(rtype == 1)
        {
            MedicineBatchesAtWholesaler[msg.sender].push(batchid); //Batch recieved by Wholesaler
        }
        else if(rtype == 2)
        {
            MedicineBatchesAtWholesaler[msg.sender].push(batchid);
            if(Medicine(batchid).getWholDiPh()[0] != address(0))
            {
                MedicineWholDist(cid).recieveWholDis(batchid, msg.sender); //Batch recieved by Distributer from Wholesaler
            }
        }
    }

    /// @notice
    mapping(address => address[]) MedicineWholsDist;
    /// @notice
    mapping(address => address) MedicineWholDistTxContract;

    /// @notice
    /// @dev Sub Contract for Medicine Transfer from Wholesaler to Distributer
    /// @param BatchID Medicine BatchID
    /// @param Shipper Transporter Ethereum Network Address
    /// @param Receiver Distributer Ethereum Network Address
    function transferMedicineWholDist(address BatchID, address Shipper, address Receiver) public
    {
        require(UsersDetails[msg.sender].role == roles.wholesaler && msg.sender == Medicine(BatchID).getWholDiPh()[0], "Only Wholesaler or current Admin of package can call this function");
        MedicineWholDist wd = new MedicineWholDist(
            BatchID,
            msg.sender,
            Shipper,
            Receiver
        );
        MedicineWholsDist[msg.sender].push(address(wd));
        MedicineWholDistTxContract[BatchID] = address(wd); //Fransfer from Wholsaler to Dist
    }

    /// @notice
    /// @dev Get Medicine Batch Count
    /// @return Number of Batches
    function getBatchesCountWD() public view returns (uint count)
    {
        require(UsersDetails[msg.sender].role == roles.wholesaler, "Only Wholesaler Can call this function.");
        return MedicineWholsDist[msg.sender].length; //Batches of Medicine
    }

    /// @notice
    /// @dev Get Medicine BatchID by indexed value of stored data
    /// @param index Indexed Number
    /// @return Medicine BatchID
    function getBatchIdByIndexWD(uint index) public view returns(address packageID)
    {
        require(UsersDetails[msg.sender].role == roles.wholesaler, "Only Wholesaler Can call this function.");
        return MedicineWholsDist[msg.sender][index]; //BatchID by Indexed Values
    }

    /// @notice
    /// @dev Get Sub Contract ID of Medicine Batch Transfer in between Wholesaler to Distributer
    /// @param BatchID BatchID of the Medicine
    /// @return SubContract ID
    function getSubContractWholDist(address BatchID) public view returns (address SubContractWD)
    {
      // require(UsersDetails[msg.sender].role == roles.wholesaler, "Only Wholesaler Can call this function.");
      return MedicineWholDistTxContract[BatchID]; //Sub Contract ID Whol to Dist
    }

//------------------------------------------------------------------------------------------------------------
    /*********** Distributer Section **********/
    /// @notice
    mapping(address => address[]) MedicineBatchAtDistributer;

    /// @notice
    mapping(address => address[]) MedicineDistrPhar;

    /// @notice
    mapping(address => address) MedicineDistPharTxContract;

    /// @notice
    /// @dev Transfer Medicine from Distributer to Pharmacy
    /// @param BatchID Medicine BatchID
    /// @param Shipper Transporter Ethereum Network Address
    /// @param Receiver Pharmacy Ethereum Network Address
    function transferMedicineDtoP(address BatchID, address Shipper, address Receiver) public
    {
      require(UsersDetails[msg.sender].role == roles.distributer && msg.sender == Medicine(BatchID).getWholDiPh()[1], "Only Distributer or Current Admin of package can call this function");
      MedicineDistPhar dp = new MedicineDistPhar(
          BatchID,
          msg.sender,
          Shipper,
          Receiver
      );
      MedicineDistrPhar[msg.sender].push(address(dp));
      MedicineDistPharTxContract[BatchID] = address(dp); //Transfer Initiated
    }

    /// @notice
    /// @dev Get Medicine Batch Count to be sent
    /// @return Number of Batches to be sent to Pharmacty
    function getBatchesCountDistPhar() public view returns (uint count)
    {
      require(UsersDetails[msg.sender].role == roles.distributer, "Only Distributer Can call this function.");
      return MedicineDistrPhar[msg.sender].length; //Batch Count to be sent to Pharmacy
    }

    /// @notice
    /// @dev Get Medicine BatchID by Indexed value of stored data
    /// @param index Index Number
    /// @return Medicine BatchID
    function getBatchIdByIndexDistPhar(uint index) public view returns(address packageID)
    {
      require(UsersDetails[msg.sender].role == roles.distributer, "Only Distributer Can call this function.");
      return MedicineDistrPhar[msg.sender][index]; //BatchID of Medicine
    }

    /// @notice
    /// @dev Get SubContract ID of Medicine Batch Transfer in between Distributer to Pharmacy
    /// @param BatchID Medicine BatchID
    /// @return SubContract ID
    function getSubContractDP(address BatchID) public view returns (address SubContractDP)
    {
      // require(UsersDetails[msg.sender].role == roles.distributer, "Only Distributer Can call this function.");
      return MedicineDistPharTxContract[BatchID];
    }
 //-------------------------------------------------------------------------------------------------------
    /***************** Pharmacy Section ***********/
    /// @notice
    mapping(address => address[]) MedicineBatchAtPharma;

    /// @notice
    /// @dev Medicine Batch Recieved from Distrubuter
    /// @param batchid Medicine BatchID
    /// @param cid SubContract ID
    function medicineRecievedAtPharmacy(address batchid, address cid) public
    {
        require(UsersDetails[msg.sender].role == roles.pharma, "Only Pharmacy Can call this function.");
        MedicineDistPhar(cid).recieveDistPhar(batchid, msg.sender);
        MedicineBatchAtPharma[msg.sender].push(batchid);
        sale[batchid] = medstatus(1); //Batch Recieved From Distributer
    }

    enum medstatus {
        notfound,
        atpharma,
        sold,
        expire,
        damaged
    }

    /// @notice
    mapping(address => medstatus) sale;

    event MedicineStatus(
        address BatchID,
        address indexed Pharma,
        uint status
    );

    /// @notice
    /// @dev Update Medicine Batch status
    /// @param BatchID Medicine BatchID
    /// @param Status Medicine Batch Status (such as sold or expired)
    function updateMedStatus(address BatchID, uint Status) public
    {
      require(UsersDetails[msg.sender].role == roles.pharma && msg.sender == Medicine(BatchID).getWholDiPh()[2], "Only Pharmacy or Current Admin of package can call this function");
      require(sale[BatchID] == medstatus(1), "Medicine must be at the Pharmacy");
      sale[BatchID] = medstatus(Status);

      emit MedicineStatus(BatchID, msg.sender, Status);
    }

    /// @notice
    /// @dev Get Medicine Batch status
    /// @param BatchID BatchID of Medicine
    /// @return Status
    function medInfo(address BatchID) public view returns(uint Status)
    {
        return uint(sale[BatchID]); //Get Medicine Batch Status
    }

    /// @notice
    /// @dev Get Medicine Batch Count
    /// @return Number of Batches
    function getBatchesCountPhar() public view returns(uint count)
    {
        require(UsersDetails[msg.sender].role == roles.pharma, "Only Wholesaler or current Admin of package can call this function");
        return  MedicineBatchAtPharma[msg.sender].length; //Number of Medicine
    }

    /// @notice
    /// @dev Get Medicine BatchID by indexed value of stored data
    /// @param index Index Number
    /// @return BatchID of Medicine at Pharmacy
    function getBatchIdByIndexPhar(uint index) public view returns(address BatchID)
    {
        require(UsersDetails[msg.sender].role == roles.pharma, "Only Wholesaler or current Admin of package can call this function");
        return MedicineBatchAtPharma[msg.sender][index]; //BatchID of Medicine
    }
}
