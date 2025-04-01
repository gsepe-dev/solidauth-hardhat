// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SolidAuth {
    address public admin;

    enum AccessMode { READ, WRITE, APPEND, CREATE, DELETE }

    struct Permission {
        bool read;
        bool write;
        bool append;
        bool create;
        bool delPermission; // Cambiato 'del' in 'delPermission' per evitare l'errore
    }

    // Mappa WebID -> Risorsa -> Permessi
    mapping(string => mapping(string => Permission)) private webIdPermissions;

    event PermissionUpdated(string indexed webId, string indexed resource, Permission permission);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Access denied: Admin only");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function setPermissions(
        string memory webId,
        string memory resource,
        bool read,
        bool write,
        bool append,
        bool create,
        bool delPermission
    ) external onlyAdmin {
        webIdPermissions[webId][resource] = Permission(read, write, append, create, delPermission);
        emit PermissionUpdated(webId, resource, webIdPermissions[webId][resource]);
    }

    function isAuthorized(string memory webId, string memory resource, AccessMode mode) external view returns (bool) {
        Permission storage perm = webIdPermissions[webId][resource];
        if (mode == AccessMode.READ) return perm.read;
        if (mode == AccessMode.WRITE) return perm.write;
        if (mode == AccessMode.APPEND) return perm.append;
        if (mode == AccessMode.CREATE) return perm.create;
        if (mode == AccessMode.DELETE) return perm.delPermission;
        return false;
    }
}
