# Blockchain - Medicine Supply Chain
A Supply Chain for Manufacturing, Distribution and Delivery of Medicines using Blockchain.

The Motive of the Medicines Supply Chain is the to bring raw drugs and matrials from supplier(Labs) to processed Medicines in the Pharmacy via various of intermediate Steps.

#### What are the problems in Current System?
---
- False and illegal drugs
- Expiration
- No Transparency on the Manufacturer and Supplier Side
- Slow Process and Error prone paper work
- Mutable and Unchecked Source
- Lack of Coordination between various steps

#### What does the Blockchain System Provide?
---
- Accurate information about status in entire chain at any point and at any location
- Visibility of all transfers in the chain
- Traceability back to source of all medicines
- Seamless collaboration between all parties
- Reduce paper work and increased process pace

#### Application Workflow Diagram
---
![](https://github.com/Ananth-r17/Blockchain--Medicine-SupplyChain/blob/master/assets/flow/Flow%20of%20Chain.png)
![](https://github.com/Ananth-r17/Blockchain--Medicine-SupplyChain/blob/master/assets/flow/Flow%20of%20Chain.png)

#### Roles
---
1. Admin
2. Supplier
3. Transfporter (Shipper)
4. Manufacturer
5. Wholesaler
6. Distributer
7. Pharmacy

**Admin:** Admin register new users, reassigns and revokes roles. Gives roles according to work.
**Lab:** Give Raw Materials for supply to the Supplier with details of Lab and the Raw Materials.
**Manufacturer:** Manufactures New Medicine Batch from the Raw Materials Batch provided by the Lab.
**Supplier:** Supplier supplies manufactured Medicine Batch either to the Wholesaler or directly to the Distributer.
**Transporter:** Transporter or Shipper are responsible for shipping medicine packages from one stage to other stage.
**Wholesaler:** Wholesaler is reponsible to receive medicine from Manufacturer/Supplier and check medicine quality, than transfer to Distributer.
**Distrubuter:** Distributer is reponsible to distribute Medicine to Pharmacies and verify Quality.
**Pharmacy:** Pharmacy is reponsible to provide right medicine to the consumer and update Medicine Status.

#### Tools and Technologies Used
---
- Solidity (Ethereum Smart Contract Language)
- Remix IDE (Useful to write and Compile Solidity)
- Metamask (Ethereum wallet)
- Test Network: Ropsten (Using Infura for the network address)
- Infura
- Truffle IDE (For Compiling and Verifying Smart Contracts on local system)
- Web3JS

#### Prerequisites
---
- Nodejs v8.12 or above
- Truffle v5.0.0 (core: 5.0.0) (http://truffleframework.com/docs/getting_started/installation)
- Solidity v0.5.0
- Metamask (https://metamask.io)
- Ganache (Etherium Accounts) (https://truffleframework.com/docs/ganache/quickstart)

#### Contract Deployment Steps:
---
**Setting up Ethereum Smart Contract:**

```
git clone https://github.com/Ananth-r17/Blockchain--Medicine-SupplyChain.git
cd Blockchain--Medicine-SupplyChain/
```

1. Go to your project folder in terminal then execute:

```
rm -rf build/
truffle compile

```
**Response:**
After Successful Compilation, you will get response in terminal as follows:
```
Compiling your contracts...
===========================
> Compiling .\contracts\Medicine.sol
> Compiling .\contracts\MedicineDistPhar.sol
> Compiling .\contracts\MedicineWholDist.sol
> Compiling .\contracts\RawMatrials.sol
> Artifacts written to C:\Users\Ananth Rajagopal\Desktop\Ananth\Proj\Blockchain Supply Chain\build\contracts
> Compiled successfully using:
   - solc: 0.5.1+commit.c8a2cb62.Emscripten.clang
```
2. Now Execute:
```
truffle migrate --network ropsten reset
```

After successful deployment you will get response in terminal as follows:
```
Starting migrations...
======================
> Network name:    'ropsten'
> Network id:      3
> Block gas limit: 8007800


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0xe8e77626586f73b955364c7b4bbf0bb7f7685ebd40e852b164633a4acbd3244c
   > Blocks: 1            Seconds: 121
   > contract address:    0xccc6e5ce623327f99bdabe79e37c834cef3fa18a
   > account:             0x9aa02364404185746d666b246b76abffd958050e
   > balance:             99.99
   > gas used:            283300
   > gas price:           60 gwei
   > value sent:          0 ETH
   > total cost:          0.016998 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:            0.016998 ETH


2_deploy_supplychain.js
=======================
[ '0xccc6e5ce623327f99bdabe79e37c834cef3fa18a' ]

   Deploying 'SupplyChain'
   -----------------------
   > transaction hash:    0xd05404fd8a8481e4c867052760f14b5b290473848a9956873df52785819e4946
   > Blocks: 2            Seconds: 9
   > contract address:    0xeeae3c137366afe51af16bb3de408c838d6ab756
   > account:             0x389a6b840b54143c0ce57c60ffd358f60b2dd6ee
   > balance:             99.61
   > gas used:            6499304
   > gas price:           60 gwei
   > value sent:          0 ETH
   > total cost:          0.38995824 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.38995824 ETH


Summary
=======
> Total deployments:   2
> Final cost:          0.40695624 ETH

```
