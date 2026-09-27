Add-Type -AssemblyName System.Drawing

$size = 512
$bmp = New-Object System.Drawing.Bitmap $size, $size
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# Clear transparent background
$g.Clear([System.Drawing.Color]::Transparent)

# Outer rounded rectangle card background (soft off-white)
$cardPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$rect = New-Object System.Drawing.Rectangle 16, 16, 480, 480
$radius = 140
$cardPath.AddArc(16, 16, $radius, $radius, 180, 90)
$cardPath.AddArc(480 - $radius, 16, $radius, $radius, 270, 90)
$cardPath.AddArc(480 - $radius, 480 - $radius, $radius, $radius, 0, 90)
$cardPath.AddArc(16, 480 - $radius, $radius, $radius, 90, 90)
$cardPath.CloseAllFigures()

$cardBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#FFFFFF'))
$g.FillPath($cardBrush, $cardPath)

# Clip to rounded card for drawing landscape inside
$g.SetClip($cardPath)

# Sky gradient (Lavender to Mint)
$skyRect = New-Object System.Drawing.Rectangle 16, 16, 480, 480
$skyBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $skyRect,
    [System.Drawing.ColorTranslator]::FromHtml('#E8E0FF'),
    [System.Drawing.ColorTranslator]::FromHtml('#D4EAD9'),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
)
$g.FillRectangle($skyBrush, $skyRect)

# Sun (Yellow)
$sunBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#FFD98E'))
$g.FillEllipse($sunBrush, 320, 120, 110, 110)

# Back lavender mountain
$backMtn = New-Object System.Drawing.Drawing2D.GraphicsPath
$backMtn.AddLine(16, 380)
$backMtn.AddLine(180, 190)
$backMtn.AddLine(330, 380)
$backMtn.CloseAllFigures()
$backMtnBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#C8B8FF'))
$g.FillPath($backMtnBrush, $backMtn)

# Front sage mountain
$frontMtn = New-Object System.Drawing.Drawing2D.GraphicsPath
$frontMtn.AddLine(130, 496)
$frontMtn.AddLine(300, 220)
$frontMtn.AddLine(480, 496)
$frontMtn.CloseAllFigures()
$frontMtnBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#8BC9A8'))
$g.FillPath($frontMtnBrush, $frontMtn)

# Foreground grass strip
$grassBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#A8D8B9'))
$g.FillRectangle($grassBrush, 16, 410, 480, 86)

$g.ResetClip()

# Save PNG
$bmp.Save('assets/logo.png', [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Host "assets/logo.png generated successfully"
