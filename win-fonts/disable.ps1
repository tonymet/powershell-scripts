	Function disable-font
	{
        
		[CmdletBinding()]
		param (
            [Parameter(Mandatory = $True,
			   ValueFromPipeline = $True,
			   ValueFromPipelineByPropertyName = $True,
			   HelpMessage = 'Name of Font')]
                [string]$Name
		)
		
		begin
		{
			#$sh = New-Object -ComObject "Shell.Application"
		}
		
		process
		{
            $sh = New-Object -ComObject "Shell.Application"
            $sh.Namespace("C:\Windows\Fonts").ParseName($Name) | ForEach-Object { $_.InvokeVerb("hide") }
		}
		
		end
		{
			
		}
	}