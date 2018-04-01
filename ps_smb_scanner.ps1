[CmdletBinding()] Param(

        [parameter(Mandatory = $True)]
        [String] $UserName,

        [parameter(Mandatory = $True)]
        [String] $Password

    )

    Begin {
        Set-StrictMode -Version 2
        #try to load assembly
        Try {Add-Type -AssemblyName System.DirectoryServices.AccountManagement}
        Catch {Write-Error $Error[0].ToString() + $Error[0].InvocationInfo.PositionMessage}
    }

    Process {
        $fileName = $((get-date -f "MM-dd-yyyy_HH.mm.ss")).ToString() + "_smb_log.txt"

        $ComputerNames = @()
        
        Write-Verbose "Searching the domain for active machines."
        "Searching the domain for active machines."

        $ComputerNames = [array] ([adsisearcher]'objectCategory=Computer').Findall() | ForEach {$_.properties.cn}

        Write-Verbose "Retrived $($ComputerNames.Length) systems from the domain."
	"Retrived $($ComputerNames.Length) systems from the domain."
	"Retrived $($ComputerNames.Length) systems from the domain.`r`n" | Add-Content $fileName

        foreach ($Computer in $ComputerNames){     

            Try {
                
                Write-Verbose "Checking: $Computer"
                $up = Test-Connection -count 1 -Quiet $Computer 

                if($up){

                    if ($Username.contains("\\")) {
                        $ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
                    }
                    else{
                        $ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Machine
                    }

		
		$pc = New-Object DirectoryServices.AccountManagement.PrincipalContext($ContextType,$Computer)
		$secString = ConvertTo-SecureString $Password -AsPlainText -Force
		try {
		    if($pc.ValidateCredentials($Username, $secString)) {
                        Write-Verbose "[+] SUCCESS: $Username works with $Password on $Computer"
				"[+] SUCCESS: $Username works with $Password on $Computer"
			"[+] SUCCESS: $Username works with $Password on $Computer" | Add-Content $fileName

                        $out = new-object psobject
                        $out | add-member Noteproperty 'ComputerName' $Computer
                        $out | add-member Noteproperty 'Username' $Username
                        $out | add-member Noteproperty 'Password' $Password
                        $out
			$out | Add-Content $fileName
			"`r`n" | Add-Content $fileName
		    }
		    else {
                        Write-Verbose "[-] FAILURE: $Username did not work with $Password on $Computer"
			"[-] FAILURE: $Username did not work with $Password on $Computer"
			"[-] FAILURE: $Username did not work with $Password on $Computer`r`n" | Add-Content $fileName
 		    }
		}
		finally {
		    $pc.Dispose()
	       }
             }
           }
          Catch {Write-Error $($Error[0].ToString() + $Error[0].InvocationInfo.PositionMessage)}
       }
    }