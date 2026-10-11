 **To answer this question, check out the following artifacts:** 
 
Were any other files created? 
	If yes: 
	1. Which files—or which file—were created?
	2. Where was this files—or which file created? 
1. Is there any information available about these files?
	1. What is its hash? 
	2. Has this file been detected before on VirusTotal or similar systems?
	3. If it has been detected before
		1. What kind of malicious file is it, and to which family does it belong?
	4. Have there been any detections of this file by EDR, XDR, or antivirus systems?
	5. Is the file available for extraction and further analysis?
		 [[Next steps for malware analysis]]
2. Did it start any other processes?
	1. Which processes?
	2. With what command line?
	3. Were any scripts or system tools executed?
3. Did it create or modify any files?
	1. Which files?
	2. Where were they created?
	3. Were any additional executable files, DLLs, or scripts created?
4. Did it make any Registry changes?
	1. Which keys or values were created or modified?
	2. Were these changes related to persistence?
5. Did it establish any network connections?
	1. Which IP addresses or domains?
	2. Which ports and protocols?
	3. Which process initiated the connection?
	4. Is the destination known or suspicious?
	5. Does the communication appear to be C2 communication?
6. Did it download or execute any additional payloads?
	1. Which files?
	2. From where?
	3. Were they executed?
7. Did it collect any information from the system?
	1. System information?
	2. User information?
	3. Credentials?
	4. Browser data?
	5. Files or documents?
8. Did it attempt to send any collected information outside the system?
	1. What data?
	2. To which destination?
	3. Which process performed the communication?
9. Did it interact with or inject code into another process?
	1. Which process?
	2. What happened after the interaction?
10. Did it attempt to evade security controls?
	1. Disable or modify AV/EDR?
	2. Delete logs or files?
	3. Add exclusions?
	4. Hide or obfuscate its activity?
11. Based on the observed behavior, what is the purpose of this file?
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