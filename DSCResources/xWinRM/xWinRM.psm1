function Get-TargetResource
{
  [CmdletBinding()]
  [OutputType([System.Collections.Hashtable])]
  param
  (
    [parameter(Mandatory = $true)]
    [ValidateSet('HTTP','HTTPS')]
    [System.String]
    $Protocol,
    
    [ValidateSet('Present','Absent')]
    [System.String]
    $Ensure,
    
   [System.String]
    $HTTPSCertThumpprint = $null
  )

  #Write-Verbose "Use this cmdlet to deliver information about command processing."

  #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    
  $httplistener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | ?{$_.Keys -like '*HTTP'}
  $httpslistener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | ?{$_.Keys -like '*HTTPS*'}  
      
      $returnValue = @{
      Protocol = $Protocol
      Ensure = $Ensure
      Service_Basic = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\Basic -ErrorAction SilentlyContinue).Value
      Client_Basic = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Basic -ErrorAction SilentlyContinue).Value
      Client_Digest = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Digest -ErrorAction SilentlyContinue).Value
      Service_Kerberos = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\Kerberos -ErrorAction SilentlyContinue).Value
      Client_Kerberos = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Kerberos -ErrorAction SilentlyContinue).Value
      Service_Negotiate = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\Negotiate -ErrorAction SilentlyContinue).Value
      Client_Negotiate = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Negotiate -ErrorAction SilentlyContinue).Value
      Service_Certificate = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\Certificate -ErrorAction SilentlyContinue).Value
      Client_Certificate = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Certificate -ErrorAction SilentlyContinue).Value
      Service_CredSSP = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\CredSSP -ErrorAction SilentlyContinue).Value
      Client_CredSSP = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\CredSSP -ErrorAction SilentlyContinue).Value
      Service_AllowUnencrypted = (Get-ChildItem -Path WSMan:\localhost\Service\AllowUnencrypted -ErrorAction SilentlyContinue).Value
      Client_AllowUnencrypted = (Get-ChildItem -Path WSMan:\localhost\Client\AllowUnencrypted -ErrorAction SilentlyContinue).Value
      HttpPort = (Get-ChildItem -Path ('WSMan:\localhost\listener\' + $httplistener.Name) -ErrorAction SilentlyContinue | ?{$_.Name -eq 'Port'}).Value
      HttpsPort = (Get-ChildItem -Path ('WSMan:\localhost\listener\' + $httpslistener.Name) -ErrorAction SilentlyContinue | ?{$_.Name -eq 'Port'}).Value
      MaxEnvelopeSizekb = (Get-ChildItem -Path WSMan:\localhost\MaxEnvelopeSizekb -ErrorAction SilentlyContinue).Value
      MaxTimeoutms = (Get-ChildItem -Path WSMan:\localhost\MaxTimeoutms -ErrorAction SilentlyContinue).Value
      MaxBatchItems = (Get-ChildItem -Path WSMan:\localhost\MaxBatchItems -ErrorAction SilentlyContinue).Value
      MaxProviderRequests = (Get-ChildItem -Path WSMan:\localhost\MaxProviderRequests -ErrorAction SilentlyContinue).Value
      MaxMemoryPerShellMB = (Get-ChildItem -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -ErrorAction SilentlyContinue).Value
      HTTPSCertThumpprint = (Get-ChildItem -Path ('WSMan:\localhost\listener\' + $httpslistener.Name) -ErrorAction SilentlyContinue | ?{$_.Name -eq 'CertificateThumbprint'}).Value
      }

      $returnValue
}


function Set-TargetResource
{
  [CmdletBinding()]
  param
  (
    [parameter(Mandatory = $true)]
    [ValidateSet('HTTP','HTTPS')]
    [System.String]
    $Protocol,

    [ValidateSet('Present','Absent')]
    [System.String]
    $Ensure,

    [ValidateSet('true','false')]
    [System.String]
    $Service_Basic = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Basic = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Digest = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Service_Kerberos = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Kerberos = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Service_Negotiate = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Negotiate = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Service_Certificate = 'false',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Certificate = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Service_CredSSP = 'false',

    [ValidateSet('true','false')]
    [System.String]
    $Client_CredSSP = 'false',

    [ValidateSet('true','false')]
    [System.String]
    $Service_AllowUnencrypted = 'false',

    [ValidateSet('true','false')]
    [System.String]
    $Client_AllowUnencrypted = 'false',

    [System.String]
    $HttpPort = 5985,

    [System.String]
    $HttpsPort = 5986,

    [System.String]
    $MaxEnvelopeSizekb = 500,

    [System.String]
    $MaxTimeoutms = 60000,

    [System.String]
    $MaxBatchItems = 32000,

    [System.String]
    $MaxProviderRequests = 4294967295,

    [System.String]
    $MaxMemoryPerShellMB = 1024,

    [System.String]
    $HTTPSCertThumpprint = $null
  )

  #Write-Verbose "Use this cmdlet to deliver information about command processing."

  #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

  #Include this line if the resource requires a system reboot.
  #$global:DSCMachineStatus = 1
}


function Test-TargetResource
{
  [CmdletBinding()]
  [OutputType([System.Boolean])]
  param
  (
    [parameter(Mandatory = $true)]
    [ValidateSet('HTTP','HTTPS')]
    [System.String]
    $Protocol,

    [ValidateSet('Present','Absent')]
    [System.String]
    $Ensure,

    [ValidateSet('true','false')]
    [System.String]
    $Service_Basic = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Basic = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Digest = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Service_Kerberos = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Kerberos = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Service_Negotiate = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Negotiate = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Service_Certificate = 'false',

    [ValidateSet('true','false')]
    [System.String]
    $Client_Certificate = 'true',

    [ValidateSet('true','false')]
    [System.String]
    $Service_CredSSP = 'false',

    [ValidateSet('true','false')]
    [System.String]
    $Client_CredSSP = 'false',

    [ValidateSet('true','false')]
    [System.String]
    $Service_AllowUnencrypted = 'false',

    [ValidateSet('true','false')]
    [System.String]
    $Client_AllowUnencrypted = 'false',

    [System.String]
    $HttpPort = 5985,

    [System.String]
    $HttpsPort = 5986,

    [System.String]
    $MaxEnvelopeSizekb = 500,

    [System.String]
    $MaxTimeoutms = 60000,

    [System.String]
    $MaxBatchItems = 32000,

    [System.String]
    $MaxProviderRequests = 4294967295,

    [System.String]
    $MaxMemoryPerShellMB = 1024,

    [System.String]
    $HTTPSCertThumpprint = $null
  )

  #Write-Verbose "Use this cmdlet to deliver information about command processing."

  #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


  if ($Ensure -eq 'Present') 
  {
    if ($Protocol -eq 'HTTP') 
    {
      Write-Verbose -Message "Attempting to find $Protocol listener"      
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like "*$Protocol*"
      }
      if ($listener -ne $null) 
      {
        Write-Verbose -Message "Found $Protocol listener"
        $target = Get-TargetResource -Protocol $Protocol -Ensure $Ensure
        if 
        (
          $Service_Basic -eq $target.Service_Basic -and $Service_Kerberos -eq $target.Service_Kerberos -and
          $Service_Negotiate -eq $target.Service_Negotiate -and $Service_Certificate -eq $target.Service_Certificate -and 
          $Service_CredSSP -eq $target.Service_CredSSP -and $Client_Basic -eq $target.Client_Basic -and
          $Client_Kerberos -eq $target.Client_Kerberos -and $Client_Negotiate -eq $target.Client_Negotiate -and
          $Client_Certificate -eq $target.Client_Certificate -and $Client_CredSSP -eq $target.Client_CredSSP -and
          $Service_AllowUnencrypted -eq $target.Service_AllowUnencrypted -and $Client_AllowUnencrypted -eq $target.Client_AllowUnencrypted -and
          $HttpPort -eq $target.
        ) 
        {
          return $true
        }
        else 
        {
          return $false
        }
      }
      else 
      {
        Write-Verbose -Message "Could not find $Protocol listener"      
        return $false
      }
    }
    else 
    {
      Write-Verbose -Message "Attempting to find $Protocol listener"
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like '*HTTPS*'
      }
      if ($listener -ne $null) 
      {
        Write-Verbose -Message "Found $Protocol listener"              
        return $true
      }
      else 
      {
        Write-Verbose -Message "Could not find $Protocol listener"      
        return $false
      }    
    }
  }
  if ($Ensure -eq 'Absent') 
  {
    if ($Protocol -eq 'HTTP') 
    {
      Write-Verbose -Message "Attempting to find $Protocol listener"      
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like "*$Protocol*"
      }
      if ($listener -ne $null) 
      {
        Write-Verbose -Message "Found $Protocol listener"      
        return $false
      }
      else 
      {
        Write-Verbose -Message "Could not find $Protocol listener"      
        return $true
      }
    }
    else 
    {
      Write-Verbose -Message "Attempting to find $Protocol listener"
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like '*HTTPS*'
      }
      if ($listener -ne $null) 
      {
        Write-Verbose -Message "Found $Protocol listener"      
        return $false
      }
      else 
      {
        Write-Verbose -Message "Could not find $Protocol listener"      
        return $true
      }    
    }
  }
}


Export-ModuleMember -Function *-TargetResource

