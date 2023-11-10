# Windows11 : How to make permanent system tray icons


Windows 11 has introduced several changes to the user interface and system functionality, including the way system tray icons are managed. While these changes offer a sleek and modern appearance, they have posed a challenge for developers and system administrators who need to programmatically create permanent system tray icons without clicking the ‘up’ button. In Windows 11, the option to permanently display these icons without user intervention or choice is no longer available. In contrast to Windows 10, where this process was straightforward using XML, Windows 11 requires a more creative approach.

In this article, we’ll explore a solution that empowers developers and system administrators to regain control over system tray icons in Windows 11.

The Script Solution:

The solution to this challenge lies in a script that leverages the Windows registry to customize system tray icons. In my example, my custom application (SatyamKrishnaSystemApp) is developed in Powershell that creates a system tray icon. The registry that controls all the system tray icons is :

HKEY_CURRENT_USER\Control Panel\NotifyIconSettings

The script recursively searches “ExecutablePath” registry string (REG_SZ) for the keyword “*powershell.exe” under all subKeys and adds a DWORD registry to force icon visibility.

This is achieved by adding a registry DWORD value named “IsPromoted” with a hex-value 1

For further reading:

https://satnix.wordpress.com/2023/10/20/how-to-make-permanent-system-tray-icons-in-windows-11/
