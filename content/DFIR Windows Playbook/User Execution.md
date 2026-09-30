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

1.  Какой файл был скачан пользователем ? 
	1. Exe 
	2. Script 
	3. LNK file
2. С какого ресурса данный файл был скачан ? 
3. Запускал ли пользователь данный файл ? 
	1. Что данный файл делает? 
	2. Каков его хеш? 
	3. Был ли раньше замечен данный файл на VirusTotal или в подобных системах? 
		1. Если был ранее замечен
			1. Что это за вредоносный файл, к какому семейству относиться ? 
4. Были ли какие-либо детекции  от EDR, XDR, Antivirus systems на данный файл ?
5. Доступен ли файл для извлечения и для дальнейшего анализа ?
	1. Дальнейшие шаги для анализа вредоносного ПО


