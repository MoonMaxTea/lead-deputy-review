param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot,
    [string]$SkillsSourceRoot = ""
)

$ErrorActionPreference = "Stop"

$BundleSkills = @(
    "executing-plans",
    "test-driven-development",
    "finishing-a-development-branch",
    "verification-before-completion",
    "systematic-debugging"
)

function Resolve-SuperpowersSkillsRoot {
    param([string]$Override)

    if ($Override -and (Test-Path $Override)) {
        return (Resolve-Path $Override).Path
    }

    $cacheBase = Join-Path $env:USERPROFILE ".cursor\plugins\cache\cursor-public\superpowers"
    if (-not (Test-Path $cacheBase)) {
        throw "Superpowers plugin cache not found at $cacheBase. Install Superpowers plugin first or pass -SkillsSourceRoot."
    }

    $candidates = Get-ChildItem -Path $cacheBase -Directory | Sort-Object Name -Descending
    foreach ($dir in $candidates) {
        $skillsPath = Join-Path $dir.FullName "skills"
        if (Test-Path $skillsPath) {
            return $skillsPath
        }
    }

    throw "No skills folder found under $cacheBase"
}

$sourceRoot = Resolve-SuperpowersSkillsRoot -Override $SkillsSourceRoot
$destRoot = Join-Path (Resolve-Path $ProjectRoot).Path ".cursor\skills\superpowers"

New-Item -ItemType Directory -Force -Path $destRoot | Out-Null

foreach ($skill in $BundleSkills) {
    $src = Join-Path $sourceRoot $skill
    $dst = Join-Path $destRoot $skill

    if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
        throw "Missing SKILL.md for $skill at $src"
    }

    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
    }

    Copy-Item -Path $src -Destination $dst -Recurse
    Write-Host "Copied $skill -> $dst"
}

$manifestSrc = Join-Path $PSScriptRoot "..\deputy-superpowers-bundle\MANIFEST.md"
$manifestDst = Join-Path $destRoot "MANIFEST.md"
Copy-Item -Path $manifestSrc -Destination $manifestDst -Force

$syncedAt = Get-Date -Format "yyyy-MM-dd"
Add-Content -Path $manifestDst -Value "`nsynced_at: $syncedAt`nsource_skills_root: $sourceRoot`n"

Write-Host "Deputy Superpowers bundle ready at $destRoot"
