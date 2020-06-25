pragma solidity >=0.4.25 <0.6.0;

/** Medicine Smart Contract **/
/// @title Medicin
contract Medicine {

    /// @notice
    address Admin;

    enum medicineStatus {
        atmanuf,
        pickedforWhol,
        pickedforDist,
        deliveredatWhol,
        deliveredatDist,
        pickedforPharm,
        deliveredatPharm
    }

    // address batchid;
    bytes32 description;
    /// @notice
    bytes32 rawmaterials;
    /// @notice
    uint quantity;
    /// @notice
    address shipper;
    /// @notice
    address manufacturer;
    /// @notice
    address wholesaler;
    /// @notice
    address distributer;
    /// @notice
    address pharma;
    /// @notice
    medicineStatus status;

    event ShippmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Receiver,
        uint TransporterType,
        uint Status
    );

    /// @notice
    /// @dev Creation of new Medicine Batch by Manufacturer in Lab
    /// @param Manu Manufacturer Ethereum Network Address
    /// @param Des Description of Medicine Batch
    /// @param RM Raw Materials for Medicine
    /// @param Quant Number of Units
    /// @param Shpr Shipper(Transporter) Ethereum Network Address
    /// @param Rcvr Receiver Ethereum Network Address
    /// @param RcvrType Receiver Type either Wholesaler(1) or Distributer(2)
    constructor(
        address Manu,
        bytes32 Des,
        bytes32 RM,
        uint Quant,
        address Shpr,
        address Rcvr,
        uint RcvrType
    ) public {
        Admin = Manu;
        manufacturer = Manu;
        description = Des;
        rawmaterials = RM;
        quantity = Quant;
        shipper = Shpr;
        if(RcvrType == 1)
        {
          wholesaler = Rcvr;
        }
        else if(RcvrType == 2)
        {
          distributer = Rcvr;
        }
    }

    /// @notice
    /// @dev Get Medicine Batch basic Details
    /// @return Medicine Batch Details
    function getMedicineInfo () public view returns(
        address Manu,
        bytes32 Des,
        bytes32 RM,
        uint Quant,
        address Shpr
    )
    {
      return(
        manufacturer,
        description,
        rawmaterials,
        quantity,
        shipper
        );
    }

    /// @notice
    /// @dev Get Address of Wholesaler, Distributer and Pharmacy
    /// @return Address Array
    function getWholDiPh() public view returns(address[3] memory WholDiPh)
    {
        return ([wholesaler,distributer,pharma]);
    }

    /// @notice
    /// @dev Get Medicine Batch Transaction Status
    /// @return Medicine Transaction Status
    function getBatchIDStatus() public view returns(uint)
    {
        return uint(status);
    }

    /// @notice
    /// @dev Pick Medicine Batch by Shipper(Transporter)
    /// @param Shpr Shipper Ethereum Network Address
    function pickPackage(address Shpr) public
    {
        require(Shpr == shipper, "Only Shipper can call this function");
        require(status == medicineStatus(0), "Package must be at Supplier.");

        if(wholesaler!=address(0x0))
        {
            status = medicineStatus(1);
            emit ShippmentUpdate(address(this),shipper,wholesaler,1,1);
        }
        else{
            status = medicineStatus(2);
            emit ShippmentUpdate(address(this),shipper,distributer,1,1);
        }
    }

    /// @notice
    /// @dev Received Medicine Batch by Wholesaler or Distributer
    /// @param Rcvr Wholesaler or Distributer
    function receivedPackage(address Rcvr) public returns(uint RcvrType)
    {
      require(Rcvr == wholesaler || Rcvr == distributer, "Only Wholesaler or Distrubuter can call this function");
      require(uint(status) >= 1, "Product not picked up yet");

        if(Rcvr == wholesaler && status == medicineStatus(1))
        {
          status = medicineStatus(3);
          emit ShippmentUpdate(address(this),shipper,wholesaler,2,3);
          return 1;
        }
        else if(Rcvr == distributer && status == medicineStatus(2))
        {
          status = medicineStatus(4);
          emit ShippmentUpdate(address(this),shipper,distributer,3,4);
          return 2;
        }
    }

    /// @notice
    /// @dev Pick to deliver Medicine from Wholesaler to Distrubuter
    /// @param receiver Distributer Ethereum Network Address
    /// @param sender Wholesaler Ethereum Network Address
    function sendWholDis(address receiver, address sender) public
    {
      require(wholesaler == sender, "This Wholesaler is sender.");
      distributer = receiver;
      status = medicineStatus(2);
    }

    /// @notice
    /// @dev Recieved Medicine by Distributer
    /// @param receiver Distributer Ethereum Network Address
    function recievedWholDis(address receiver) public
    {
      require(distributer == receiver, "This Distributer is reciever.");
      status = medicineStatus(4);
    }

    /// @notice
    /// @dev Pick from Distributer to Pharmacy
    /// @param receiver Pharmacy Ethereum Network Address
    /// @param sender Distributer Ethereum Network Address
    function sendDistPhar(address receiver, address sender) public
    {
        require(distributer == sender, "This Distributer is sender.");
        pharma = receiver;
        status = medicineStatus(5);
    }

    /// @notice
    /// @dev Update Medicine Batch transaction Status(Recieved) in between Distributer and Pharmacy
    /// @param receiver Pharmacy Ethereum Network Address
    function recievedDistPhar(address receiver) public
    {
        require(pharma == receiver, "This Pharmacy is reciever.");
        status = medicineStatus(6);
    }
}
