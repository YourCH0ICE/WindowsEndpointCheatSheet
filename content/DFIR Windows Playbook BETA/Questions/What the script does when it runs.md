**To answer this question, check out the following artifacts:** 

1. Windows Event Logs: 
	1. Security.evtx event code: [4688]
	2. Sysmon event code: [1](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=90001)
	3. Microsoft-Windows-PowerShell%4Operational.evtx event.code [4104](https://medium.com/@six.dingus/event-id-4104-83fd9441957c)
	4. Windows PowerShell.evtx (for old PowerShell v5.1/2.0)
2. ConsoleHost_history.txt 
	1. File path: C:\Users\<user_name>\AppData\Microsoft\Windows\PowerShell\PSReadLine\
3. Volume Shadow Copies - VSC
	1. These options allow you to restore a deleted .ps1 file if it was on the drive when the restore point was created.