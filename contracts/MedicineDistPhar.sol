pragma solidity >=0.4.25 <0.6.0;

import './Medicine.sol';

/* Medicine from Distributer to Pharmacy */
/// @title MedicineDistPhar
/// @dev Sub Contract for Medicine Transaction between Distributer and Pharmacy
contract MedicineDistPhar {
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
    /// @dev Create Sub Contract for Medicine Transaction
    /// @param BatchID BatchID of the Medicine
    /// @param Sender Distributer Ethereum Network Address
    /// @param Shipper Transporter Ethereum Network Address
    /// @param Receiver Pharmacy Ethereum Network Address
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
    /// @dev Pick Medicine Batch by Transporter from Distributer
    /// @param BatchID Batch ID of Medicine
    /// @param Shipper Transporter Ethereum Network Address
    function pickDistPhar(address BatchID, address Shipper) public
    {
        require(Shipper == shipper, "Only Shipper can call this function.");
        status = packageStatus(1);

        Medicine(BatchID).sendDistPhar(receiver, sender);
    }

    /// @notice
    /// @dev Recieved Medicine Batch by Pharmacy
    /// @param BatchID Batch ID of the Medicine
    /// @param Receiver Pharmacy Ethereum Network Address
    function recieveDistPhar(address BatchID, address Receiver) public
    {
        require(Receiver == receiver, "Only Pharmacy can call this function.");
        status = packageStatus(2);

        Medicine(BatchID).recievedDistPhar(Receiver);
    }

    /// @notice
    /// @dev Get Medicine Batch Transaction status in between Distributer and Pharma
    /// @return Transaction status
    function getBatchIDStatus() public view returns(uint)
    {
        return uint(status);
    }

}
