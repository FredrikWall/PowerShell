# Active Directory LDAP Functions

A collection of PowerShell functions for managing Active Directory objects using LDAP, without requiring the Microsoft Active Directory module. These lightweight functions provide direct LDAP access for common AD operations.

## Overview

These functions enable direct interaction with Active Directory through LDAP queries and operations. They are particularly useful in environments where the Active Directory PowerShell module is not available or when you need lightweight, dependency-free AD management tools.

## Prerequisites

- PowerShell 3.0 or higher
- Network access to Active Directory
- Appropriate permissions for reading/creating AD objects

## Functions

### Get Functions

#### Get-LDAPComputer

Retrieves Active Directory computer object information using LDAP queries.

**Syntax:**
```powershell
Get-LDAPComputer -ComputerName <String>
```

**Parameters:**
- `ComputerName` - The name of the computer object to query

**Examples:**
```powershell
# Get information about a single computer
Get-LDAPComputer -ComputerName PC001

# Pipeline support for multiple computers
"PC001","PC002" | Get-LDAPComputer

# Access specific properties
("PC001" | Get-LDAPComputer).Path

# View all available properties
"PC001" | Get-LDAPComputer | Get-Member
```

**Features:**
- Pipeline support for bulk operations
- Returns DirectoryServices.DirectoryEntry object
- Handles missing computer objects gracefully

---

#### Get-LDAPGroup

Retrieves Active Directory group object information using LDAP queries.

**Syntax:**
```powershell
Get-LDAPGroup -GroupName <String>
```

**Parameters:**
- `GroupName` - The name of the group object to query

**Examples:**
```powershell
# Get information about a single group
Get-LDAPGroup -GroupName GROUP01

# Pipeline support
"GROUP01" | Get-LDAPGroup

# Query multiple groups
"GROUP01","GROUP02" | Get-LDAPGroup

# Access specific properties
("GROUP01" | Get-LDAPGroup).Path

# View all available properties
"GROUP01" | Get-LDAPGroup | Get-Member
```

**Features:**
- Pipeline support for bulk operations
- Returns DirectoryServices.DirectoryEntry object
- Query any group type (Security, Distribution)

---

#### Get-LDAPOU

Retrieves Active Directory Organizational Unit (OU) information using LDAP queries.

**Syntax:**
```powershell
Get-LDAPOU -OUName <String>
```

**Parameters:**
- `OUName` - The name of the OU object to query

**Examples:**
```powershell
# Get information about a single OU
Get-LDAPOU -OUName OU001

# Pipeline support
"OU001" | Get-LDAPOU

# Query multiple OUs
"OU001","OU002" | Get-LDAPOU

# Access the distinguished name
("OU001" | Get-LDAPOU).distinguishedName

# View all available properties
"OU001" | Get-LDAPOU | Get-Member
```

**Features:**
- Pipeline support for bulk operations
- Returns DirectoryServices.DirectoryEntry object
- Access to full OU hierarchy information

---

#### Get-LDAPUser

Retrieves Active Directory user object information using LDAP queries.

**Syntax:**
```powershell
Get-LDAPUser -UserName <String>
```

**Parameters:**
- `UserName` - The name of the user object to query

**Examples:**
```powershell
# Get information about a single user
Get-LDAPUser -UserName User01

# Pipeline support
"USER01" | Get-LDAPUser

# Query multiple users
"USER01","USER02" | Get-LDAPUser

# Access specific properties
("USER01" | Get-LDAPUser).Path

# View all available properties
"USER01" | Get-LDAPUser | Get-Member
```

**Features:**
- Pipeline support for bulk operations
- Returns DirectoryServices.DirectoryEntry object
- Access to all user attributes

---

### New Functions

#### New-LDAPComputer

Creates a new Active Directory computer object using LDAP.

**Syntax:**
```powershell
New-LDAPComputer -ComputerName <String> -SAMAccountName <String> -OUPath <String>
```

**Parameters:**
- `ComputerName` - The name of the computer to create
- `SAMAccountName` - The SAM account name for the computer
- `OUPath` - The distinguished name of the target OU

**Examples:**
```powershell
# Create a new computer object
New-LDAPComputer -ComputerName "PC001" -SAMAccountName "PC001" -OUPath "OU=Test,OU=Computers,OU=LabOU,DC=poweradmin,DC=se"

# Using positional parameters
New-LDAPComputer "PC001" "PC001" "OU=Test,OU=Computers,OU=LabOU,DC=poweradmin,DC=se"
```

**Notes:**
- Computer object is created in a disabled state
- Basic attributes are set; additional configuration may be needed
- Requires appropriate permissions in the target OU

---

#### New-LDAPGroup

Creates a new Active Directory group object using LDAP.

**Syntax:**
```powershell
New-LDAPGroup -GroupName <String> -OUPath <String>
```

**Parameters:**
- `GroupName` - The name of the group to create
- `OUPath` - The distinguished name of the target OU

**Examples:**
```powershell
# Create a new group object
New-LDAPGroup -GroupName "GROUP01" -OUPath "OU=Test,OU=Groups,OU=LabOU,DC=poweradmin,DC=se"

# Using positional parameters
New-LDAPGroup "GROUP01" "OU=Test,OU=Groups,OU=LabOU,DC=poweradmin,DC=se"
```

**Notes:**
- Group is created with basic attributes
- Additional group properties can be configured after creation
- Requires appropriate permissions in the target OU

---

#### New-LDAPOU

Creates a new Active Directory Organizational Unit using LDAP.

**Syntax:**
```powershell
New-LDAPOU -OUName <String> -OUPath <String>
```

**Parameters:**
- `OUName` - The name of the OU to create
- `OUPath` - The distinguished name of the parent OU

**Examples:**
```powershell
# Create a new OU
New-LDAPOU -OUName "OU01" -OUPath "OU=Test,OU=LabOU,DC=poweradmin,DC=se"

# Using positional parameters
New-LDAPOU "OU01" "OU=Test,OU=LabOU,DC=poweradmin,DC=se"
```

**Notes:**
- OU is created with basic attributes
- Can be nested within existing OU structure
- Requires appropriate permissions in the parent OU

---

#### New-LDAPUser

Creates a new Active Directory user object using LDAP.

**Syntax:**
```powershell
New-LDAPUser -UserName <String> -SAMAccountName <String> -OUPath <String>
```

**Parameters:**
- `UserName` - The name of the user to create
- `SAMAccountName` - The SAM account name for the user
- `OUPath` - The distinguished name of the target OU

**Examples:**
```powershell
# Create a new user object
New-LDAPUser -UserName "USER01" -SAMAccountName "USER01" -OUPath "OU=Test,OU=Users,OU=LabOU,DC=poweradmin,DC=local"

# Using positional parameters
New-LDAPUser "USER01" "USER01" "OU=Test,OU=Users,OU=LabOU,DC=poweradmin,DC=local"
```

**Notes:**
- User object is created in a disabled state
- Basic attributes are set; password and additional configuration needed
- Requires appropriate permissions in the target OU

---

## Common Features

All functions in this collection share these characteristics:

- **No Module Dependencies**: Works without the Active Directory PowerShell module
- **LDAP-Based**: Uses DirectoryServices.DirectoryEntry for direct LDAP access
- **Lightweight**: Minimal overhead and fast execution
- **Error Handling**: Includes try-catch blocks for graceful error management
- **Pipeline Support**: Get functions support pipeline input for bulk operations

## Usage Tips

### Getting Objects
Use the Get functions to query existing AD objects. These functions return DirectoryServices.DirectoryEntry objects, giving you access to all LDAP attributes.

### Creating Objects
When using New functions:
1. Ensure you have the correct distinguished name (DN) for the target OU
2. Computer and user objects are created disabled by default
3. Additional configuration (passwords, group memberships, etc.) should be done separately

### Best Practices
- Always test in a non-production environment first
- Verify OUPath distinguished names before creating objects
- Use appropriate error handling when integrating into scripts
- Consider using pipeline operations for bulk queries

## LabAD Folder

The LabAD subfolder contains test data files (e.g., gNamesSWEDEN.txt) that can be used for lab environments and testing purposes.

## Author

**Fredrik Wall**
- Email: wall.fredrik@gmail.com
- Twitter: [@walle75](https://twitter.com/walle75)
- Blog: [http://www.poweradmin.se](http://www.poweradmin.se)
- GitHub: [https://github.com/FredrikWall](https://github.com/FredrikWall)

## License

See the LICENSE file in the repository root for license information.

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check the issues page if you want to contribute.