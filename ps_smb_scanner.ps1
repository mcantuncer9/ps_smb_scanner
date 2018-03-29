function ps_smb_scanner {
    [CmdletBinding()] Param(
	
	  [parameter(Mandatory = $True)]
      [String] $UserName,

      [parameter(Mandatory = $True)]
      [String] $Password,
    )

    Begin {
	  
    }	
}