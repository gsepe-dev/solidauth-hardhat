// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SolidAuth {
    address admin;

    enum AccessMode { READ, WRITE, APPEND, CREATE, DELETE }

    struct Permission {
        bool read;
        bool write;
        bool append;
        bool create;
        bool delPermission; // Cambiato 'del' in 'delPermission' per evitare l'errore
    }

    // Mappatura WebID -> Indirizzo del wallet
    mapping(string => address) private webIdToWallet;

    // Mappatura Indirizzo del wallet -> Risorsa -> Permessi
    mapping(address => mapping(string => Permission)) private walletPermissions;

    event WalletAssigned(string indexed webId, address indexed wallet);
    event PermissionUpdated(address indexed wallet, string indexed resource, Permission permission);

    modifier onlyAdminorOwner(address wallet) {
        require(msg.sender == admin || msg.sender == wallet, "Access denied: Only admin or owner allowed");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Assegna un indirizzo wallet a un WebID
    function assignWallet(string memory webId, address wallet) external onlyAdminorOwner(wallet) {
        webIdToWallet[webId] = wallet;
        emit WalletAssigned(webId, wallet);
    }

    // Imposta i permessi per un indirizzo di wallet
    function setPermissions(
        address wallet,
        string memory resource,
        bool read,
        bool write,
        bool append,
        bool create,
        bool delPermission
    ) external onlyAdminorOwner(wallet) {
        walletPermissions[wallet][resource] = Permission(read, write, append, create, delPermission);
        emit PermissionUpdated(wallet, resource, walletPermissions[wallet][resource]);
    }

    // Controlla se un wallet è autorizzato per una determinata modalità
    function isAuthorized(address wallet, string memory resource, AccessMode mode) external view returns (bool) {
        Permission storage perm = walletPermissions[wallet][resource];
        if (mode == AccessMode.READ) return perm.read;
        if (mode == AccessMode.WRITE) return perm.write;
        if (mode == AccessMode.APPEND) return perm.append;
        if (mode == AccessMode.CREATE) return perm.create;
        if (mode == AccessMode.DELETE) return perm.delPermission;
        return false;
    }
}
