function ps_smb_scanner {
    [CmdletBinding()] Param(
	
	  [parameter(Mandatory = $True)]
      [String] $UserName,

      [parameter(Mandatory = $True)]
      [String] $Password,
    )

    Begin {
        Set-StrictMode -Version 2
        Try {Add-Type -AssemblyName System.DirectoryServices.AccountManagement}
        Catch {Write-Error $Error[0].ToString() + $Error[0].InvocationInfo.PositionMessage}
    }
	
	

}