pragma solidity >=0.4.25 <0.6.0;

import './Medicine.sol';

/* MedicineWholDist */
/// @title MedicineWholDist
/// @notice
/// @dev Sub Contract for Medicine Transaction between Wholesaler and Distributer
contract MedicineWholDist {
    /// @notice
    address Admin;

    enum packageStatus {atmanuf, picked, delivered}

    /// @notice
    address batchid;
    /// @notice
    address sender;
    /// @notice
    address shipper;
    /// @notice
    address receiver;
    /// @notice
    packageStatus status;

    /// @notice
    /// @dev Create SubContract for Medicine Transaction
    /// @param BatchID BatchID of the Medicine
    /// @param Sender Wholesaler Ethereum Network Address
    /// @param Shipper Transporter Ethereum Network Address
    /// @param Receiver Distributer Ethereum Network Address
    constructor(address BatchID, address Sender, address Shipper, address Receiver) public
    {
      Admin = Sender;
      batchid = BatchID;
      sender = Sender;
      shipper = Shipper;
      receiver = Receiver;
      status = packageStatus(0);
    }

    /// @notice
    /// @dev Pick Medicine Batch by Transporter from Wholesaler
    /// @param BatchID BatchID of Medicine
    /// @param Shipper Transporter Ethereum Network Address
    function pickWholDist(address BatchID, address Shipper) public
    {
        require(Shipper == shipper, "Only Shipper can call this function.");
        status = packageStatus(1);

        Medicine(BatchID).sendWholDis(receiver,sender);
    }

    /// @notice
    /// @dev Recieved Medicine Batch by Distributer
    /// @param BatchID BatchID of the Medicine
    /// @param Receiver Distributer Ethereum Network Address
    function recieveWholDis(address BatchID, address Receiver) public
    {
        require(Receiver == receiver, "Only Receiver(Distributer) can call this function.");
        status = packageStatus(2);

        Medicine(BatchID).recievedWholDis(Receiver);
    }

    /// @notice
    /// @dev Get Medicine Batch Transaction status in between Wholesaler and Distributer
    /// @return Transaction status
    function getBatchIDStatus() public view returns(uint)
    {
        return uint(status);
    }

}
