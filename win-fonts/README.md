## Win-Fonts Powershell Module
Perform font operations like Search (list),  show, hide, delete using Windows Explorer Shell.  
It is safer than using private registry and file operations. 

Useful for batch enabling/ disabling of fonts. 

## Requirements 
* Windows 8+
* Powershell 5+

## Credits
Thanks you to [Doug Maurer (krzydoug
)](https://forums.powershell.org/u/krzydoug/summary) and the  [Powershell
Community Forum](https://forums.powershell.org/) for helping with COM+ objects
in Powershell


### Hide-Font

NAME
    Hide-Font

SYNOPSIS
    Hide Font in Fonts control panel.  Hidden from application font lists


SYNTAX
    Hide-Font [-Name] <Object> [<CommonParameters>]


DESCRIPTION
    Hide font in Windows Explorer making the font unavailable to use in Apps. Font remains installed


### Show-Font
NAME
    Show-Font

SYNOPSIS
    Show font in Windows control panel and apps


SYNTAX
    Show-Font [-Name] <Object> [<CommonParameters>]


DESCRIPTION
    Show font in Windows Explorer making the font available to use in Apps. Font remains installed


### Search-FontName
NAME
    Search-FontName

SYNOPSIS
    Search font by Name : "Hide" or "Show"


SYNTAX
    Search-FontName [[-Name] <String>] [<CommonParameters>]


DESCRIPTION
    Search font by status : "Hide" or "Show"


### Search-FontStatus
NAME
    Search-FontStatus

SYNOPSIS
    Search font by status : "Hide" or "Show"


SYNTAX
    Search-FontStatus [[-Status] <String>] [<CommonParameters>]


DESCRIPTION
    Search font by status : "Hide" or "Show"
