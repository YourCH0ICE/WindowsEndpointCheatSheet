---
title: 2. User Execution
authors: 2026-08-18
ID: T1204
Tactic: User Execution
---
---
### Definition 
An adversary may rely upon specific actions by a user in order to gain execution. Users may be subjected to social engineering to get them to execute malicious code by, for example, opening a malicious document file or link. These user actions will typically be observed as follow-on behavior from forms of [[Phishing]]. 

While [User Execution](https://attack.mitre.org/techniques/T1204) frequently occurs shortly after Initial Access it may occur at other phases of an intrusion, such as when an adversary places a file in a shared directory or on a user's desktop hoping that a user will click on it. This activity may also be seen shortly after [Internal Spearphishing](https://attack.mitre.org/techniques/T1534).
Adversaries may also deceive users into performing actions such as:

- Enabling [Remote Access Tools](https://attack.mitre.org/techniques/T1219), allowing direct control of the system to the adversary
- Running malicious JavaScript in their browser, allowing adversaries to [Steal Web Session Cookie](https://attack.mitre.org/techniques/T1539)s[[1]](https://blog.talosintelligence.com/roblox-scam-overview/)[[2]](https://krebsonsecurity.com/2023/05/discord-admins-hacked-by-malicious-bookmarks/)
- Downloading and executing malware for [User Execution](https://attack.mitre.org/techniques/T1204)
- Coerceing users to copy, paste, and execute malicious code manually[[3]](https://www.reliaquest.com/blog/new-execution-technique-in-clearfake-campaign/)[[4]](https://www.proofpoint.com/us/blog/threat-insight/clipboard-compromise-powershell-self-pwn)

For example, tech support scams can be facilitated through [[Phishing]], vishing, or various forms of user interaction. Adversaries can use a combination of these methods, such as spoofing and promoting toll-free numbers or call centers that are used to direct victims to malicious websites, to deliver and execute payloads containing malware or [Remote Access Tools](https://attack.mitre.org/techniques/T1219).[[5]](https://www.proofpoint.com/us/blog/threat-insight/caught-beneath-landline-411-telephone-oriented-attack-delivery)

---
### Questions for the Investigator 

1. Which file was executed ?
	1. EXE
		1.  Did the user execute this file?
			**To answer this question, check out the following artifacts:** 
			1. [[Prefetch (.pf)]]
			2. [[Amcache]] 
			3. [[MFT]]
			4. Registry key  
				1. **Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist**
				2. **Software\Microsoft\Windows\CurrentVersion\Search\RecentApps**
				3. **SYSTEM\CurrentControlSet\Services\Bam\State\UserSettings\<SID>**
			5. Windows Event Logs: 
				1. **Security.evtx** event code: [4688](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventID=4688)
				2. Sysmon event code: [1](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=90001)
		2. How did this executable end up on the host? 
			**To answer this question, check out the following artifacts:** 
			1. [[MFT]]
			2. Browser History File
				1. 
			3. PowerShell logs
			4. ConsoleHost_history.txt 
				1. File path: C:\Users\<user_name>\AppData\Microsoft\Windows\PowerShell\PSReadLine\
		3. What does this file do?
			1. Were any other files created? 
				If yes: 
				1. Which files—or which file—were created?
				2. Where was this files—or which file created? 
				3. Is there any information available about these files?
					1. What is its hash? 
					2. Has this file been detected before on VirusTotal or similar systems?
			        3. If it has been detected before
			            1. What kind of malicious file is it, and to which family does it belong?
					4. Have there been any detections of this file by EDR, XDR, or antivirus systems?
					5. Is the file available for extraction and further analysis?
					     [[Next steps for malware analysis]]
				4. Did it start any other processes?
			        1. Which processes?
			        2. With what command line?
			        3. Were any scripts or system tools executed?
			    5. Did it create or modify any files?
			        1. Which files?
			        2. Where were they created?
			        3. Were any additional executable files, DLLs, or scripts created?
			    6. Did it make any Registry changes?
			        1. Which keys or values were created or modified?
			        2. Were these changes related to persistence?
			    7. Did it establish any network connections?
			        1. Which IP addresses or domains?
			        2. Which ports and protocols?
			        3. Which process initiated the connection?
			        4. Is the destination known or suspicious?
			        5. Does the communication appear to be C2 communication?
			    8. Did it download or execute any additional payloads?
			        1. Which files?
			        2. From where?
			        3. Were they executed?
			    9. Did it collect any information from the system?
			        1. System information?
			        2. User information?
			        3. Credentials?
			        4. Browser data?
			        5. Files or documents?
			    10. Did it attempt to send any collected information outside the system?
			        1. What data?
			        2. To which destination?
			        3. Which process performed the communication?
			    11. Did it interact with or inject code into another process?
			        1. Which process?
			        2. What happened after the interaction?
			    12. Did it attempt to evade security controls?
			        1. Disable or modify AV/EDR?
			        2. Delete logs or files?
			        3. Add exclusions?
			        4. Hide or obfuscate its activity?
			    13. Based on the observed behavior, what is the purpose of this file?
			        1. Downloader?
			        2. Dropper?
			        3. Loader?
			        4. Stealer?
			        5. RAT / Backdoor?
			        6. C2 implant?
			        7. Persistence mechanism?
			        8. Ransomware?
			        9. Other malicious functionality?
			        10. Legitimate or dual-use software?
			        11. Unknown / insufficient evidence?
	    4. What is its hash?
	    5. Has this file been detected before on VirusTotal or similar systems?
	        1. If it has been detected before
	            1. What kind of malicious file is it, and to which family does it belong?
		6. Have there been any detections of this file by EDR, XDR, or antivirus systems?
		7. Is the file available for extraction and further analysis?
		     [[Next steps for malware analysis]]
		8.  [[Persistence]]
	2. Script (ps1, bat, js, etc. )
		1. Is it known which script was run?  
			**To answer this question, check out the following artifacts:** 
			1. Windows Event Logs: 
				1. Security.evtx event code: [4688]
				2. Sysmon event code: [1](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=90001)
			2. ConsoleHost_history.txt 
				1. File path: C:\Users\<user_name>\AppData\Microsoft\Windows\PowerShell\PSReadLine\
		2. How did this script end up on the host? 
			**To answer this question, check out the following artifacts:** 
			1.  [[MFT]]
		3. What does this script do? 
			**To answer this question, check out the following artifacts:** 
			1. Windows Event Logs:
				1. Microsoft-Windows-PowerShell%4Operational.evtx event.code [4104](https://medium.com/@six.dingus/event-id-4104-83fd9441957c)
				2. Windows PowerShell.evtx (for old PowerShell v5.1/2.0)
			2. Volume Shadow Copies - VSC
				1. These options allow you to restore a deleted .ps1 file if it was on the drive when the restore point was created.
			3.  
	3. LNK file
		1. 

2.  How did this file end up on this host? 
	1. This file was downloaded from Google Drive, OneDrive, etc. ?
    2. The user manually copied and pasted this malicious file from a USB drive or other external storage device ? 
	    1.<span style="color: #D96C6C;"> To answer this question, it is necessary to correlate several artifacts</span>
		1. The user used an infected USB drive ? 
    3. Did the user download the attached file from a phishing email? 

| Браузер                       | Browser History / основной файл                                               |
| ----------------------------- | ----------------------------------------------------------------------------- |
| **Google Chrome**             | `%LOCALAPPDATA%\Google\Chrome\User Data\Default\History`                      |
| Chrome, другой профиль        | `%LOCALAPPDATA%\Google\Chrome\User Data\Profile 1\History`                    |
| **Microsoft Edge (Chromium)** | `%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\History`                     |
| Edge, другой профиль          | `%LOCALAPPDATA%\Microsoft\Edge\User Data\Profile 1\History`                   |
| **Mozilla Firefox**           | `%APPDATA%\Mozilla\Firefox\Profiles\<PROFILE>\places.sqlite`                  |
| **Brave**                     | `%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\History`        |
| **Opera**                     | `%APPDATA%\Opera Software\Opera Stable\History`                               |
| **Opera GX**                  | `%APPDATA%\Opera Software\Opera GX Stable\History`                            |
| **Vivaldi**                   | `%LOCALAPPDATA%\Vivaldi\User Data\Default\History`                            |
| **Chromium**                  | `%LOCALAPPDATA%\Chromium\User Data\Default\History`                           |
| **Yandex Browser**            | `%LOCALAPPDATA%\Yandex\YandexBrowser\User Data\Default\History`               |
| **Tor Browser**               | `<Tor Browser>\Browser\TorBrowser\Data\Browser\profile.default\places.sqlite` |
