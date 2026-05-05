param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    [switch]$UseSymlink
)

$RootDir = (Get-Item -Path ".\..\..").FullName
$ProjectDir = Join-Path $RootDir $ProjectName
$SharedCoreDir = Join-Path $RootDir "shared-ag-core"

Write-Host "Initializing Agent Project: $ProjectName"

# 1. プロジェクトフォルダ作成
if (-Not (Test-Path $ProjectDir)) {
    New-Item -ItemType Directory -Path $ProjectDir | Out-Null
    Write-Host "Created project folder: $ProjectDir"
} else {
    Write-Host "Project folder already exists."
}

# 2. 標準ディレクトリ構成作成
$folders = @("Application", "Documents", "Progress", "Project AI Rules", "AI")
foreach ($folder in $folders) {
    $targetFolder = Join-Path $ProjectDir $folder
    if (-Not (Test-Path $targetFolder)) {
        New-Item -ItemType Directory -Path $targetFolder | Out-Null
    }
}
Write-Host "Created standard folder structure."

# 3. .agent (AIルール) のセットアップ
$TargetAgentDir = Join-Path $ProjectDir ".agent"
$SourceAgentDir = Join-Path $SharedCoreDir "ai-rules\.agent"

if (Test-Path $TargetAgentDir) {
    Write-Host ".agent directory already exists. Skipping."
} else {
    if ($UseSymlink) {
        # Junction is better for directories on Windows without admin rights
        New-Item -ItemType Junction -Path $TargetAgentDir -Target $SourceAgentDir | Out-Null
        Write-Host "Created Junction (Symlink) for .agent"
    } else {
        Copy-Item -Path $SourceAgentDir -Destination $TargetAgentDir -Recurse
        Write-Host "Copied .agent rules."
    }
}

# 4. 必須ファイルテンプレートの作成
$ProjectRulesFile = Join-Path $ProjectDir "Project AI Rules\project_rules.md"
if (-Not (Test-Path $ProjectRulesFile)) {
    @"
# プロジェクト固有 AI ルール

## 1. プロジェクト概要
- ここにプロジェクトの目的を記載

## 2. 技術スタック
- Frontend: 
- Backend: 

## 3. ディレクトリ構成
- Application/: 
"@ | Out-File -FilePath $ProjectRulesFile -Encoding utf8
    Write-Host "Created project_rules.md template."
}

$PhaseFile = Join-Path $ProjectDir "Documents\phase_management.md"
if (-Not (Test-Path $PhaseFile)) {
    @"
# フェーズ管理

## 現在のフェーズ
- [x] Planning (企画)
- [ ] Prototyping (試作)
- [ ] Development (開発)
- [ ] Verification (検証)
- [ ] Closed (完了)
"@ | Out-File -FilePath $PhaseFile -Encoding utf8
    Write-Host "Created phase_management.md template."
}

$TaskFile = Join-Path $ProjectDir "task.md"
if (-Not (Test-Path $TaskFile)) {
    @"
- [ ] **【重要】すべての思考・出力・ドキュメントが日本語であることを確認**
- [ ] 初期要件の確認
"@ | Out-File -FilePath $TaskFile -Encoding utf8
    Write-Host "Created initial task.md."
}

# 5. Git初期化
Set-Location -Path $ProjectDir
if (-Not (Test-Path ".git")) {
    git init
    Write-Host "Initialized empty Git repository."
}

Write-Host "Done! Project setup is complete."
