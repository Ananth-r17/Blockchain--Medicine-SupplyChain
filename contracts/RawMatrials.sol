pragma solidity >=0.4.25 <0.6.0;

/* Raw Materials Smart Contract **/
/// @title Raw Materials
/// @notice
/// @dev Create new instance of RawMaterials package
contract RawMaterials {
    /// @notice
    address Admin;

    enum packageStatus {atlab, picked, delivered}
    event TransportUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Manufacturer,
        uint TransporterType,
        uint Status
    );
    /// @notice
    address productid;
    /// @notice
    bytes32 description;
    /// @notice
    bytes32 lab_name;
    /// @notice
    bytes32 location;
    /// @notice
    uint quantity;
    /// @notice
    address shipper;
    /// @notice
    address manufacturer;
    /// @notice
    address supplier;
    /// @notice
    packageStatus status;
    /// @notice
    bytes32 packageReceiverDescription;

    /// @notice
    /// @dev Intiate New Package of Raw Matrials by Supplier
    /// @param Splr Supplier Ethereum Network Address
    /// @param Des Description of Raw Matrials
    /// @param LN Lab Name
    /// @param Loc Lab Location
    /// @param Quant Number of units in a package
    /// @param Shpr Transporter Ethereum Network Address
    /// @param Rcvr Manufacturer Ethereum Network Address
    constructor (
        address Splr,
        bytes32 Des,
        bytes32 LN,
        bytes32 Loc,
        uint Quant,
        address Shpr,
        address Rcvr
    )
    public {
      Admin = Splr;
      productid = address(this);
      description = Des;
      lab_name = LN;
      location = Loc;
      quantity = Quant;
      shipper = Shpr;
      manufacturer = Rcvr;
      supplier = Splr;
      status = packageStatus(0);
    }

    /// @notice
    /// @dev Get Raw Matrials Package Details
    /// @return Package Details
    function getSuppliedRawMatrials () public view returns(
        bytes32 Des,
        bytes32 LN,
        bytes32 Loc,
        uint Quant,
        address Shpr,
        address Rcvr,
        address Splr
    ) {
        return(
          description,
          lab_name,
          location,
          quantity,
          shipper,
          manufacturer,
          supplier
        );
    }

    /// @notice
    /// @dev Get Status of Transaction
    /// @return Status of Delivery
    function getRawMatrialsStatus() public view returns(uint)
    {
        return uint(status);
    }

    /// @notice
    /// @dev Pick Package by Transporter from Lab
    /// @param shpr Transporter Ethereum Network Address
    function pickPackage(address shpr) public
    {
        require(shpr == shipper, "Only Shipper can call this function");
        require(status == packageStatus(0), "Package must be at the lab");
        status = packageStatus(1);
        emit TransportUpdate(address(this),shipper,manufacturer,1,1);
    }

    /// @notice
    /// @dev Received Raw Materials Status Update By Manufacturer
    /// @param manu Manufacturer Ethereum Network Address
    function receivedRawMaterials(address manu) public
    {
        require(manu == manufacturer, "Only Manufacturer can call this function");
        require(status == packageStatus(1), "Product not delivered yet");
        status = packageStatus(2);
        emit TransportUpdate(address(this),shipper,manufacturer,1,2);
    }
}
