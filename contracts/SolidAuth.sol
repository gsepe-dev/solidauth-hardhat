// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolidAuth {

    enum AccessMode { READ, WRITE, APPEND, CREATE, DELETE }

    struct Permission {
        bool read;
        bool write;
        bool append;
        bool create;
        bool del;
    }

    address public admin; 

    // Mapping WebID -> Wallet address
    mapping(string => address) webIdToWallet;

    // Mapping Wallet address -> Resource -> Permission
    mapping(address => mapping(string => Permission)) walletPermissions;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Access denied: Only admin allowed");
        _;
    }

    modifier onlyAdminOrOwner(address wallet, string memory resource) {
        //Controllare il campo READ è equivalente a qualsiasi altro campo
        //Perchè i permessi vengono assegnati sempre come tupla
        require((msg.sender == admin) || (walletPermissions[wallet][resource]).read, "Access denied: Only admin or the respective wallet allowed");
        _;
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "Error: New admin address cannot be zero");
        admin = newAdmin;
    }

    function assignWalletToWebId(address wallet, string memory webId) external onlyAdmin {
        require(webIdToWallet[webId] == address(0), "Error: Assigning an existing WebID to another wallet");
        webIdToWallet[webId] = wallet;
    }

    function getWalletByWebId(string memory webId) external view returns (address) {
        return webIdToWallet[webId];
    }

    function removeWalletFromWebId(string memory webId) external onlyAdmin {
        delete webIdToWallet[webId];
    }

    function setPermissions(address wallet, string memory resource, Permission calldata permissions) external onlyAdminOrOwner(msg.sender, resource) {
        walletPermissions[wallet][resource] = permissions;
    }

    function getPermissions(address wallet, string memory resource) external view returns (Permission memory) {
        return walletPermissions[wallet][resource];
    }

    function removePermissions(address wallet, string memory resource) external onlyAdminOrOwner(msg.sender, resource) {
        delete walletPermissions[wallet][resource];
    }

    function isAuthorized(address wallet, string memory resource, AccessMode mode) external view returns (bool) {
        Permission storage perm = walletPermissions[wallet][resource];
        if (mode == AccessMode.READ) return perm.read;
        if (mode == AccessMode.WRITE) return perm.write;
        if (mode == AccessMode.APPEND) return perm.append;
        if (mode == AccessMode.CREATE) return perm.create;
        if (mode == AccessMode.DELETE) return perm.del;
        return false;
    }
}