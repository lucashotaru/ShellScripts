Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;

function Test-Administrator  
{  
    [OutputType([bool])]
    param()
    process {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}

if(Test-Administrator){
    $usuarioGroup = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $usuarioSplit = $usuarioGroup.Split("\")
    $usuario = $usuarioSplit[1]

    function Set-VariavelAmbiente {
        Param($Caminho)
        $path = $env:Path += $Caminho
        $env:Path += $Caminho
        [System.Environment]::SetEnvironmentVariable('Path', $path, 'Machine')
        [System.Environment]::SetEnvironmentVariable('Path', $path, 'User')
    }

    if (-not(Test-Path -Path "C:\ProgramData\chocolatey")) {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    }

    try {
        node -v | Out-Null
        "Node ja esta instalado"
    }
    catch {
        choco install -y nodejs-lts
        $caminho = ';C:\Program Files\nodejs'
        Set-VariavelAmbiente -Caminho $caminho
    }

    try {
        ng version | Out-Null
        "Angular ja esta instalado"
    }catch {
        npm install -g @angular/cli
        npm install -g yarn
        $caminho = ';C:\Users\' + $usuario + '\AppData\Roaming\npm'
        Set-VariavelAmbiente -Caminho $caminho
    }

    try {
        dotnet | Out-Null
        "Dotnet ja esta instalado"
    }
    catch {
        choco install dotnet -y
        choco install dotnet-sdk -y
        choco install dotnet-runtime -y
        choco install dotnet-windowshosting -y
        choco install dotnet-desktopruntime -y
        choco install dotnet-aspnetruntime -y
    }

    try {
        docker | Out-Null
        "Docker ja esta instalado"
    }catch{
        choco install wsl2 --params "/Version:2 /Retry:true" -y
        choco install docker -y
        choco install docker-compose -y
        choco install docker-desktop -y
        net localgroup docker-users $usuarioNomeCompleto /ADD;
    }

    try {
        git | Out-Null
        "Git ja esta instalado"
    }
    catch {
        choco install git.install -y
        $caminho = ';C:\Program Files\Git\bin'
        Set-VariavelAmbiente -Caminho $caminho
        git config --global user.name $usuario
        git config --global user.email $"$usuario@grupobarigui.com.br"
    }

    try {
        python --version | Out-Null
        "Python ja esta instalado"
    }
    catch {
        choco install python -y
    }

    choco install vscode -y
    choco install 7zip -y
    choco install googlechrome -y
    choco install redis-64 -y
    choco install dbeaver -y
    choco install composer -y
    choco install gather -y
    choco install mobaxterm -y
    choco install discord -y
    choco install forticlientvpn -y
    choco install filezilla -y
    choco install wsl-ubuntu-2204 -y
    choco install putty -y
    choco install s3browser -y
    choco install virtualbox -y
    choco install libreoffice-fresh -y

    Import-Module WebAdministration

}else{
    echo "Execute como admin"
}