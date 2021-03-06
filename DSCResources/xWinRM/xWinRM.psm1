﻿function Get-TargetResource
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
    $HTTPSCertThumpprint = 'Self'
  )

  #Write-Verbose "Use this cmdlet to deliver information about command processing."

  #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    
  $httplistener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
    $_.Keys -like '*HTTP'
  }
  $httpslistener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
    $_.Keys -like '*HTTPS*'
  }  
    
  $returnValue = @{
    Protocol                   = $Protocol
    Ensure                     = $Ensure
    Service_Basic              = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\Basic -ErrorAction SilentlyContinue).Value
    Client_Basic               = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Basic -ErrorAction SilentlyContinue).Value
    Client_Digest              = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Digest -ErrorAction SilentlyContinue).Value
    Service_Kerberos           = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\Kerberos -ErrorAction SilentlyContinue).Value
    Client_Kerberos            = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Kerberos -ErrorAction SilentlyContinue).Value
    Service_Negotiate          = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\Negotiate -ErrorAction SilentlyContinue).Value
    Client_Negotiate           = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Negotiate -ErrorAction SilentlyContinue).Value
    Service_Certificate        = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\Certificate -ErrorAction SilentlyContinue).Value
    Client_Certificate         = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\Certificate -ErrorAction SilentlyContinue).Value
    Service_CredSSP            = (Get-ChildItem -Path WSMan:\localhost\Service\Auth\CredSSP -ErrorAction SilentlyContinue).Value
    Client_CredSSP             = (Get-ChildItem -Path WSMan:\localhost\Client\Auth\CredSSP -ErrorAction SilentlyContinue).Value
    Service_AllowUnencrypted   = (Get-ChildItem -Path WSMan:\localhost\Service\AllowUnencrypted -ErrorAction SilentlyContinue).Value
    Client_AllowUnencrypted    = (Get-ChildItem -Path WSMan:\localhost\Client\AllowUnencrypted -ErrorAction SilentlyContinue).Value
    HttpPort                   = (Get-ChildItem -Path ('WSMan:\localhost\listener\' + $httplistener.Name) -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Name -eq 'Port'
    }).Value
    HttpsPort                  = (Get-ChildItem -Path ('WSMan:\localhost\listener\' + $httpslistener.Name) -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Name -eq 'Port'
    }).Value
    MaxEnvelopeSizekb          = (Get-ChildItem -Path WSMan:\localhost\MaxEnvelopeSizekb -ErrorAction SilentlyContinue).Value
    MaxTimeoutms               = (Get-ChildItem -Path WSMan:\localhost\MaxTimeoutms -ErrorAction SilentlyContinue).Value
    MaxBatchItems              = (Get-ChildItem -Path WSMan:\localhost\MaxBatchItems -ErrorAction SilentlyContinue).Value
    MaxProviderRequests        = (Get-ChildItem -Path WSMan:\localhost\MaxProviderRequests -ErrorAction SilentlyContinue).Value
    MaxMemoryPerShellMB        = (Get-ChildItem -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -ErrorAction SilentlyContinue).Value
    HTTPSCertThumpprint = (Get-ChildItem -Path ('WSMan:\localhost\listener\' + $httpslistener.Name) -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Name -eq 'CertificateThumbprint'
    }).Value
    
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
    $HTTPSCertThumpprint = 'Self',

    [Boolean]
    $RestartService = $false
  )

  #Write-Verbose "Use this cmdlet to deliver information about command processing."

  #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

  #Include this line if the resource requires a system reboot.
  #$global:DSCMachineStatus = 1
  
  if ($Ensure -eq 'Present') 
  {
    Write-Verbose -Message 'Ensure is set to present'
    if ((Test-Path -Path WSMan:\localhost) -eq $false -or (Get-ChildItem -Path WSMan:\localhost\Listener) -eq $null) 
    {
      Write-Verbose -Message 'Could not find WinRM config... enabling'
      Enable-PSRemoting
    }
    else 
    {
      Write-Verbose -Message 'Found an existing WinRM config'
    }     
    if ($Protocol -eq 'HTTP') 
    {
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like 'Transport=HTTP'
      }
      Write-Verbose -Message 'Configuring Basic auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $Service_Basic
      Write-Verbose -Message 'Configuring Basic auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Basic -Value $Client_Basic

      Write-Verbose -Message 'Configuring Digest auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Digest -Value $Client_Digest

      Write-Verbose -Message 'Configuring Kerberos auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Kerberos -Value $Service_Kerberos
      Write-Verbose -Message 'Configuring Kerberos auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Kerberos -Value $Client_Kerberos

      Write-Verbose -Message 'Configuring Negotiate auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Negotiate -Value $Service_Negotiate
      Write-Verbose -Message 'Configuring Negotiate auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Negotiate -Value $Client_Negotiate
      
      Write-Verbose -Message 'Configuring Certificate auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $Service_Certificate
      Write-Verbose -Message 'Configuring Certificate auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Certificate -Value $Client_Certificate

      Write-Verbose -Message 'Configuring CredSSP auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\CredSSP -Value $Service_CredSSP
      Write-Verbose -Message 'Configuring CredSSP auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\CredSSP -Value $Client_CredSSP

      Write-Verbose -Message 'Configuring WinRM service encryption option'
      Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $Service_AllowUnencrypted
      Write-Verbose -Message 'Configuring WinRM client encryption option'
      Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $Client_AllowUnencrypted  
    
      Write-Verbose -Message 'Configuring Max Envelope Size'
      Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value $MaxEnvelopeSizekb

      Write-Verbose -Message 'Configuring Max timeout'
      Set-Item -Path WSMan:\localhost\MaxTimeoutms -Value $MaxTimeoutms
    
      Write-Verbose -Message 'Configuring Max batch items'
      Set-Item -Path WSMan:\localhost\MaxBatchItems -Value $MaxBatchItems

      Write-Verbose -Message 'Configuring Max provider requests'
      Set-Item -Path WSMan:\localhost\MaxProviderRequests -Value $MaxProviderRequests
    
      Write-Verbose -Message 'Configuring Max memory per shell'
      Set-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value $MaxMemoryPerShellMB

      Write-Verbose -Message "Configuring the HTTP listener: $($listener.Name) port to $HttpPort"
      Set-Item -Path ('WSMan:\localhost\listener\' + $($listener.Name) + '\Port') -Value $HttpPort -Force 
    
      # Check to see if service was specified to be restarted
      if ($RestartService -eq $true)
      {
        Write-Verbose -Message 'Stopping WinRM service'
        Stop-Service -Name WinRM -Force -NoWait

        Start-Sleep -Seconds 10

        $service = Get-Service -Name WinRM
        while ($service.Status -ne 'stopped') 
        {
          Write-Verbose -Message "Service hasn't stopped after 10 seconds. ending the process"
          $id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE 'WinRM'" | 
          Select-Object -ExpandProperty ProcessId
          Stop-Process -Id $id -Force
          Start-Sleep -Seconds 1
          $service = Get-Service -Name WinRM
        }
      
        $service = Get-Service -Name WinRM
        while ($service.Status -eq 'stopped') 
        {
          Write-Verbose -Message 'Starting WinRM service'
          Start-Service -Name WinRM
          Start-Sleep -Seconds 1
          $service = Get-Service -Name WinRM
        }
      }                                       
    }
    else 
    {
      Write-Verbose -Message 'Configuring Basic auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $Service_Basic
      Write-Verbose -Message 'Configuring Basic auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Basic -Value $Client_Basic

      Write-Verbose -Message 'Configuring Digest auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Digest -Value $Client_Digest

      Write-Verbose -Message 'Configuring Kerberos auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Kerberos -Value $Service_Kerberos
      Write-Verbose -Message 'Configuring Kerberos auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Kerberos -Value $Client_Kerberos

      Write-Verbose -Message 'Configuring Negotiate auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Negotiate -Value $Service_Negotiate
      Write-Verbose -Message 'Configuring Negotiate auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Negotiate -Value $Client_Negotiate
      
      Write-Verbose -Message 'Configuring Certificate auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $Service_Certificate
      Write-Verbose -Message 'Configuring Certificate auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Certificate -Value $Client_Certificate

      Write-Verbose -Message 'Configuring CredSSP auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\CredSSP -Value $Service_CredSSP
      Write-Verbose -Message 'Configuring CredSSP auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\CredSSP -Value $Client_CredSSP

      Write-Verbose -Message 'Configuring WinRM service encryption option'
      Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $Service_AllowUnencrypted
      Write-Verbose -Message 'Configuring WinRM client encryption option'
      Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $Client_AllowUnencrypted

      Write-Verbose -Message 'Configuring Max Envelope Size'
      Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value $MaxEnvelopeSizekb

      Write-Verbose -Message 'Configuring Max timeout'
      Set-Item -Path WSMan:\localhost\MaxTimeoutms -Value $MaxTimeoutms
    
      Write-Verbose -Message 'Configuring Max batch items'
      Set-Item -Path WSMan:\localhost\MaxBatchItems -Value $MaxBatchItems

      Write-Verbose -Message 'Configuring Max provider requests'
      Set-Item -Path WSMan:\localhost\MaxProviderRequests -Value $MaxProviderRequests
    
      Write-Verbose -Message 'Configuring Max memory per shell'
      Set-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value $MaxMemoryPerShellMB

      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like 'Transport=HTTPS'
      }
      if ($listener -ne $null -and $HTTPSCertThumpprint -ne 'Self') 
      {
        Write-Verbose -Message 'Configuring the HTTPS listener port'
        Write-Verbose -Message "Configuring the HTTP listener: $($listener.Name) port to $HttpPort"
        Set-Item -Path ('WSMan:\localhost\listener\' + $($listener.Name) + '\Port') -Value $HttpsPort -Force
        Write-Verbose -Message "Configuring the HTTP listener: $($listener.Name) certificate to $HTTPSCertThumpprint"
        Set-Item -Path ('WSMan:\localhost\listener\' + $($listener.Name) + '\CertificateThumbprint') -Value $HTTPSCertThumpprint         
      }
      elseif ($listener -eq $null -and $HTTPSCertThumpprint -eq 'Self') 
      {
        Write-Verbose -Message 'Removing old self signed certificate' 
        foreach ($item in (Get-ChildItem -Path cert:\LocalMachine\My -DnsName WinRM | Where-Object -FilterScript {
              $_.FriendlyName -eq 'WinRM Self-signed cert'
        })) 
        {
          Remove-Item -Path $item.PSPath -Force
        }   
        Write-Verbose -Message 'Generating new self signed certificate' 
        if ((Get-WmiObject -Class Win32_OperatingSystem).caption -like 'Microsoft Windows Server 2016*') 
        {
          $Cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName 'WinRM' -FriendlyName 'WinRM Self-signed cert' -KeyExportPolicy NonExportable -NotAfter (Get-Date).AddYears(10)
        }
        else 
        {
          . ("$PSScriptRoot"+ '\New-SelfSignedCertificateEx.ps1')
          New-SelfSignedCertificateEx -NotAfter (Get-Date).AddYears(10) -FriendlyName 'WinRM Self-signed cert' -StoreLocation LocalMachine -StoreName My -Subject 'CN=WinRM' -EKU "Server Authentication", "Client authentication" -SignatureAlgorithm sha256
          $Cert = Get-ChildItem -Path cert:\LocalMachine\My -DnsName WinRM
        }         
        Write-Verbose -Message 'Creating the HTTPS listener'
        New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force
        Write-Verbose -Message 'Configuring the HTTPS listener port'
        $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
          $_.Keys -like 'Transport=HTTPS'
        }
        Set-Item -Path ('WSMan:\localhost\listener\' + $($listener.Name) + '\Port') -Value $HttpsPort -Force        
      }
      elseif ($listener -ne $null -and $HTTPSCertThumpprint -eq 'Self') 
      {
        Write-Verbose -Message 'Removing old self signed certificate' 
        foreach ($item in (Get-ChildItem -Path cert:\LocalMachine\My -DnsName WinRM | Where-Object -FilterScript {
              $_.FriendlyName -eq 'WinRM Self-signed cert'
        })) 
        {
          Remove-Item -Path $item.PSPath -Force
        }       Write-Verbose -Message 'Generating new self signed certificate' 
        if ((Get-WmiObject -Class Win32_OperatingSystem).caption -like 'Microsoft Windows Server 2016*') 
        {
          $Cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName 'WinRM' -FriendlyName 'WinRM Self-signed cert' -KeyExportPolicy NonExportable -NotAfter (Get-Date).AddYears(10)
        }
        else 
        {
          . ("$PSScriptRoot"+ '\New-SelfSignedCertificateEx.ps1')
          New-SelfSignedCertificateEx -NotAfter (Get-Date).AddYears(10) -FriendlyName 'WinRM Self-signed cert' -StoreLocation LocalMachine -StoreName My -Subject 'CN=WinRM' -EKU "Server Authentication", "Client authentication" -SignatureAlgorithm sha256
          $Cert = Get-ChildItem -Path cert:\LocalMachine\My -DnsName WinRM
        } 
        Write-Verbose -Message 'Creating the HTTPS listener'
        Set-Item -Path ('WSMan:\localhost\listener\' + $($listener.Name) + '\CertificateThumbprint') -Value $Cert.Thumbprint -Force     
        Write-Verbose -Message 'Configuring the HTTPS listener port'
        $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
          $_.Keys -like 'Transport=HTTPS'
        }
        Set-Item -Path ('WSMan:\localhost\listener\' + $($listener.Name) + '\Port') -Value $HttpsPort -Force     
      }
      
      # Check to see if the service was specified to restart
      if ($RestartService -eq $true)
      {
        Write-Verbose -Message 'Stopping WinRM service'
        Stop-Service -Name WinRM -Force -NoWait -PassThru

        Start-Sleep -Seconds 10

        $service = Get-Service -Name WinRM
        while ($service.Status -ne 'stopped') 
        {
          Write-Verbose -Message "Service hasn't stopped after 10 seconds. ending the process"
          $id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE 'WinRM'" | 
          Select-Object -ExpandProperty ProcessId
          Stop-Process -Id $id -Force
          Start-Sleep -Seconds 1
          $service = Get-Service -Name WinRM
        }
      
        $service = Get-Service -Name WinRM
        while ($service.Status -eq 'stopped') 
        {
          Write-Verbose -Message 'Starting WinRM service'
          Start-Service -Name WinRM
          Start-Sleep -Seconds 1
          $service = Get-Service -Name WinRM
        }
      }
    }
  }
  else 
  {
    Write-Verbose -Message 'Ensure is set to absent'
    if ($Protocol -eq 'HTTP') 
    {
      Write-Verbose -Message 'Configuring Basic auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $Service_Basic
      Write-Verbose -Message 'Configuring Basic auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Basic -Value $Client_Basic

      Write-Verbose -Message 'Configuring Digest auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Digest -Value $Client_Digest

      Write-Verbose -Message 'Configuring Kerberos auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Kerberos -Value $Service_Kerberos
      Write-Verbose -Message 'Configuring Kerberos auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Kerberos -Value $Client_Kerberos

      Write-Verbose -Message 'Configuring Negotiate auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Negotiate -Value $Service_Negotiate
      Write-Verbose -Message 'Configuring Negotiate auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Negotiate -Value $Client_Negotiate
      
      Write-Verbose -Message 'Configuring Certificate auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $Service_Certificate
      Write-Verbose -Message 'Configuring Certificate auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Certificate -Value $Client_Certificate

      Write-Verbose -Message 'Configuring CredSSP auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\CredSSP -Value $Service_CredSSP
      Write-Verbose -Message 'Configuring CredSSP auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\CredSSP -Value $Client_CredSSP

      Write-Verbose -Message 'Configuring WinRM service encryption option'
      Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $Service_AllowUnencrypted
      Write-Verbose -Message 'Configuring WinRM client encryption option'
      Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $Client_AllowUnencrypted

      Write-Verbose -Message 'Configuring Max Envelope Size'
      Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value $MaxEnvelopeSizekb

      Write-Verbose -Message 'Configuring Max timeout'
      Set-Item -Path WSMan:\localhost\MaxTimeoutms -Value $MaxTimeoutms
    
      Write-Verbose -Message 'Configuring Max batch items'
      Set-Item -Path WSMan:\localhost\MaxBatchItems -Value $MaxBatchItems

      Write-Verbose -Message 'Configuring Max provider requests'
      Set-Item -Path WSMan:\localhost\MaxProviderRequests -Value $MaxProviderRequests
    
      Write-Verbose -Message 'Configuring Max memory per shell'
      Set-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value $MaxMemoryPerShellMB     
      
      Write-Verbose -Message 'Removing HTTP listener'
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like 'Transport=HTTP'
      }
      Remove-Item -Path ('WSMan:\localhost\listener\' + $($listener.Name) + '*') -Force -Recurse
      
      # Check to see if the service was specified to be restarted
      if ($RestartService -eq $true)
      {
      
        Write-Verbose -Message 'Stopping WinRM service'
        Stop-Service -Name WinRM -Force -NoWait -PassThru

        Start-Sleep -Seconds 10

        $service = Get-Service -Name WinRM
        while ($service.Status -ne 'stopped') 
        {
          Write-Verbose -Message "Service hasn't stopped after 10 seconds. ending the process"
          $id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE 'WinRM'" | 
          Select-Object -ExpandProperty ProcessId
          Stop-Process -Id $id -Force
          Start-Sleep -Seconds 1
          $service = Get-Service -Name WinRM
        }
      
        $service = Get-Service -Name WinRM
        while ($service.Status -eq 'stopped') 
        {
          Write-Verbose -Message 'Starting WinRM service'
          Start-Service -Name WinRM
          Start-Sleep -Seconds 1
          $service = Get-Service -Name WinRM
        }
      }
    }
    else 
    {
      Write-Verbose -Message 'Configuring Basic auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $Service_Basic
      Write-Verbose -Message 'Configuring Basic auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Basic -Value $Client_Basic

      Write-Verbose -Message 'Configuring Digest auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Digest -Value $Client_Digest

      Write-Verbose -Message 'Configuring Kerberos auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Kerberos -Value $Service_Kerberos
      Write-Verbose -Message 'Configuring Kerberos auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Kerberos -Value $Client_Kerberos

      Write-Verbose -Message 'Configuring Negotiate auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Negotiate -Value $Service_Negotiate
      Write-Verbose -Message 'Configuring Negotiate auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Negotiate -Value $Client_Negotiate
      
      Write-Verbose -Message 'Configuring Certificate auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $Service_Certificate
      Write-Verbose -Message 'Configuring Certificate auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\Certificate -Value $Client_Certificate

      Write-Verbose -Message 'Configuring CredSSP auth for the WinRM service'
      Set-Item -Path WSMan:\localhost\Service\Auth\CredSSP -Value $Service_CredSSP
      Write-Verbose -Message 'Configuring CredSSP auth for the WinRM client'
      Set-Item -Path WSMan:\localhost\Client\Auth\CredSSP -Value $Client_CredSSP

      Write-Verbose -Message 'Configuring WinRM service encryption option'
      Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $Service_AllowUnencrypted
      Write-Verbose -Message 'Configuring WinRM client encryption option'
      Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $Client_AllowUnencrypted

      Write-Verbose -Message 'Configuring Max Envelope Size'
      Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value $MaxEnvelopeSizekb

      Write-Verbose -Message 'Configuring Max timeout'
      Set-Item -Path WSMan:\localhost\MaxTimeoutms -Value $MaxTimeoutms
    
      Write-Verbose -Message 'Configuring Max batch items'
      Set-Item -Path WSMan:\localhost\MaxBatchItems -Value $MaxBatchItems

      Write-Verbose -Message 'Configuring Max provider requests'
      Set-Item -Path WSMan:\localhost\MaxProviderRequests -Value $MaxProviderRequests
    
      Write-Verbose -Message 'Configuring Max memory per shell'
      Set-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value $MaxMemoryPerShellMB      
      
      Write-Verbose -Message 'Removing HTTPS listener'   
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like 'Transport=HTTPS'
      }
      Remove-Item -Path ('WSMan:\localhost\listener\' + $($listener.Name) + '*') -Force -Recurse
      
      # Check to see if service was specified to be restarted
      if ($RestartService -eq $true)
      {
      
        Write-Verbose -Message 'Stopping WinRM service'
        Stop-Service -Name WinRM -Force -NoWait -PassThru

        Start-Sleep -Seconds 10

        $service = Get-Service -Name WinRM
        while ($service.Status -ne 'stopped') 
        {
          Write-Verbose -Message "Service hasn't stopped after 10 seconds. ending the process"
          $id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE 'WinRM'" | 
          Select-Object -ExpandProperty ProcessId
          Stop-Process -Id $id -Force
          Start-Sleep -Seconds 1
          $service = Get-Service -Name WinRM
        }
      
        $service = Get-Service -Name WinRM
        while ($service.Status -eq 'stopped') 
        {
          Write-Verbose -Message 'Starting WinRM service'
          Start-Service -Name WinRM
          Start-Sleep -Seconds 1
          $service = Get-Service -Name WinRM
        }
      }
    }
  }
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
    $HTTPSCertThumpprint = 'Self',

    [Boolean]
    $RestartService = $false
  )

  #Write-Verbose "Use this cmdlet to deliver information about command processing."

  #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


  if ($Ensure -eq 'Present') 
  {
    if ($Protocol -eq 'HTTP') 
    {
      Write-Verbose -Message "Attempting to find $Protocol listener"      
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like 'Transport=HTTP'
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
          $HttpPort -eq $target.HttpPort -and $MaxEnvelopeSizekb -eq $target.MaxEnvelopeSizekb -and
          $MaxTimeoutms -eq $target.MaxTimeoutms -and $MaxBatchItems -eq $target.MaxBatchItems -and $MaxProviderRequests -eq $target.MaxProviderRequests -and
          $MaxMemoryPerShellMB -eq $target.MaxMemoryPerShellMB
        ) 
        {
          Write-Verbose -Message 'Everything matches'          
          return $true
        }
        else 
        {
          Write-Verbose -Message 'Not everything matches'         
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
      if ($HTTPSCertThumpprint -ne 'Self') 
      {
        Write-Verbose -Message 'HTTPSCertThumpprint specified'        
        Write-Verbose -Message "Attempting to find $Protocol listener"
        $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
          $_.Keys -like 'Transport=HTTPS'
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
            $HttpsPort -eq $target.HttpsPort -and $MaxEnvelopeSizekb -eq $target.MaxEnvelopeSizekb -and
            $MaxTimeoutms -eq $target.MaxTimeoutms -and $MaxBatchItems -eq $target.MaxBatchItems -and $MaxProviderRequests -eq $target.MaxProviderRequests -and
            $MaxMemoryPerShellMB -eq $target.MaxMemoryPerShellMB -and $HTTPSCertThumpprint -eq $target.HTTPSCertThumpprint
          ) 
          {
            Write-Verbose -Message 'Everything matches'          
            return $true
          }
          else 
          {
            Write-Verbose -Message 'Not everything matches'         
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
        Write-Verbose -Message 'HTTPSCertThumpprint is set to self signed'                
        Write-Verbose -Message "Attempting to find $Protocol listener"
        $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
          $_.Keys -like 'Transport=HTTPS'
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
            $HttpsPort -eq $target.HttpsPort -and $MaxEnvelopeSizekb -eq $target.MaxEnvelopeSizekb -and
            $MaxTimeoutms -eq $target.MaxTimeoutms -and $MaxBatchItems -eq $target.MaxBatchItems -and $MaxProviderRequests -eq $target.MaxProviderRequests -and
            $MaxMemoryPerShellMB -eq $target.MaxMemoryPerShellMB -and $HTTPSCertThumpprint -eq 'Self'
          ) 
          {
            Write-Verbose -Message 'Everything matches'          
            return $true
          }
          else 
          {
            Write-Verbose -Message 'Not everything matches'         
            return $false
          }
        }
        else 
        {
          Write-Verbose -Message "Could not find $Protocol listener"      
          return $false
        } 
      }
    }
  }
  if ($Ensure -eq 'Absent') 
  {
    if ($Protocol -eq 'HTTP') 
    {
      Write-Verbose -Message "Attempting to find $Protocol listener"      
      $listener = Get-ChildItem -Path WSMan:\localhost\listener -ErrorAction SilentlyContinue | Where-Object -FilterScript {
        $_.Keys -like 'Transport=HTTP'
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
        $_.Keys -like 'Transport=HTTPS'
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
