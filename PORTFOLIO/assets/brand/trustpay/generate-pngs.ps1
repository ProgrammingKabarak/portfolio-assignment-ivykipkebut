Add-Type -AssemblyName System.Drawing

function New-Canvas($width, $height, $bg = $null) {
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $graphics.Clear([System.Drawing.Color]::Transparent)
  if ($bg) { $graphics.Clear([System.Drawing.ColorTranslator]::FromHtml($bg)) }
  return @($bitmap, $graphics)
}

function Brush($hex) { New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($hex)) }
function Pen($hex, $width) {
  $pen = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($hex), $width)
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  return $pen
}

function Draw-TrustPayIcon($g, $scale, $ox, $oy) {
  $blue = Brush "#2563EB"
  $white = Brush "#FFFFFF"
  $greenPen = Pen "#10B981" (34 * $scale)
  $shield = New-Object System.Drawing.Drawing2D.GraphicsPath
  $shield.AddPolygon([System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new($ox + 256 * $scale, $oy + 72 * $scale),
    [System.Drawing.PointF]::new($ox + 410 * $scale, $oy + 132 * $scale),
    [System.Drawing.PointF]::new($ox + 410 * $scale, $oy + 260 * $scale),
    [System.Drawing.PointF]::new($ox + 390 * $scale, $oy + 358 * $scale),
    [System.Drawing.PointF]::new($ox + 256 * $scale, $oy + 484 * $scale),
    [System.Drawing.PointF]::new($ox + 122 * $scale, $oy + 358 * $scale),
    [System.Drawing.PointF]::new($ox + 102 * $scale, $oy + 260 * $scale),
    [System.Drawing.PointF]::new($ox + 102 * $scale, $oy + 132 * $scale)
  ))
  $g.FillPath($blue, $shield)
  $g.FillRectangle($white, $ox + 174 * $scale, $oy + 164 * $scale, 54 * $scale, 54 * $scale)
  $g.FillRectangle($white, $ox + 284 * $scale, $oy + 164 * $scale, 54 * $scale, 54 * $scale)
  $g.FillRectangle($white, $ox + 174 * $scale, $oy + 274 * $scale, 54 * $scale, 54 * $scale)
  $g.FillRectangle($white, $ox + 284 * $scale, $oy + 274 * $scale, 32 * $scale, 32 * $scale)
  $g.FillRectangle($white, $ox + 326 * $scale, $oy + 316 * $scale, 36 * $scale, 36 * $scale)
  $g.DrawLines($greenPen, [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new($ox + 184 * $scale, $oy + 392 * $scale),
    [System.Drawing.PointF]::new($ox + 242 * $scale, $oy + 446 * $scale),
    [System.Drawing.PointF]::new($ox + 354 * $scale, $oy + 304 * $scale)
  ))
}

function Save($bitmap, $graphics, $path) {
  $graphics.Dispose()
  $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bitmap.Dispose()
}

$out = Split-Path -Parent $MyInvocation.MyCommand.Path
$title = New-Object System.Drawing.Font("Segoe UI", 116, [System.Drawing.FontStyle]::Bold)
$tag = New-Object System.Drawing.Font("Segoe UI", 36, [System.Drawing.FontStyle]::Bold)

$canvas = New-Canvas 1800 560
Draw-TrustPayIcon $canvas[1] 0.82 80 70
$canvas[1].DrawString("Trust", $title, (Brush "#111827"), 560, 130)
$canvas[1].DrawString("Pay", $title, (Brush "#2563EB"), 880, 130)
$canvas[1].DrawString("SECURE QR PAYMENTS", $tag, (Brush "#64748B"), 568, 300)
$canvas[1].DrawLine((Pen "#2563EB" 12), 568, 378, 1030, 378)
$canvas[1].FillEllipse((Brush "#10B981"), 1060, 366, 24, 24)
$canvas[1].DrawLine((Pen "#2563EB" 12), 1104, 378, 1240, 378)
Save $canvas[0] $canvas[1] (Join-Path $out "trustpay-logo.png")

$canvas = New-Canvas 1800 560 "#111827"
Draw-TrustPayIcon $canvas[1] 0.82 80 70
$canvas[1].DrawString("Trust", $title, (Brush "#FFFFFF"), 560, 130)
$canvas[1].DrawString("Pay", $title, (Brush "#60A5FA"), 880, 130)
$canvas[1].DrawString("SECURE QR PAYMENTS", $tag, (Brush "#CBD5E1"), 568, 300)
$canvas[1].DrawLine((Pen "#60A5FA" 12), 568, 378, 1030, 378)
$canvas[1].FillEllipse((Brush "#10B981"), 1060, 366, 24, 24)
$canvas[1].DrawLine((Pen "#60A5FA" 12), 1104, 378, 1240, 378)
Save $canvas[0] $canvas[1] (Join-Path $out "trustpay-logo-dark.png")

$canvas = New-Canvas 512 512
Draw-TrustPayIcon $canvas[1] 1 0 0
Save $canvas[0] $canvas[1] (Join-Path $out "trustpay-icon.png")

$canvas = New-Canvas 64 64 "#FFFFFF"
Draw-TrustPayIcon $canvas[1] 0.125 0 0
Save $canvas[0] $canvas[1] (Join-Path $out "trustpay-favicon.png")
