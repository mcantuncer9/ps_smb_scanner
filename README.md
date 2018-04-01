# ps_smb_scanner

This script scans the inner network for open SMB Protocol with given username & password.





ps_smb_scanner is a post exploitation tool for pen tests. 
After server exploitation attacker can execute this tool with find All active machines in the domain and check if the given username & password work on that domain participants. Main purpose in this tool is use the server as a "Pivot."


Work on machine:
	~Windows Server 2016
	~64Bit Architecture

Created a local network & domain with Windows Server 16:
  - 3 users added to domain. 
  - Saved credentials test in code. 
  - Need some progress for output. (Mostly OK.)  
  - 1 user Windows7; 1 user Windows8; 1 user Windows10;


How to use:



.\Invoke-SMBScanner.ps1 -username "UserNameHere" -password "PasswordHere"

ComputerName    Username Password
------------    -------- --------

SERVER          decoder  1234qqqQ

[+] SUCCESS: decoder works with 1234qqqQ on VULWIN7-DEVICE4

VULWIN7-DEVICE4 decoder  1234qqqQ

[+] SUCCESS: decoder works with 1234qqqQ on VULMACHINE

VULMACHINE      decoder  1234qqqQ

[-] FAILURE: decoder did not work with 1234qqqQ on MAINMACHINE



  
Mahmut Can Tuncer
TOBB Economics & Technology University
131101071
