Add-Type -AssemblyName System.Drawing

function New-Canvas($width, $height, $whiteBg = $false) {
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $graphics.Clear([System.Drawing.Color]::Transparent)
  if ($whiteBg) { $graphics.Clear([System.Drawing.Color]::White) }
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

function Draw-NexusIcon($g, $scale, $ox, $oy) {
  $indigo = Brush "#6366F1"
  $emerald = Brush "#10B981"
  $dark = Brush "#111827"
  $white = Brush "#FFFFFF"
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddString("N", (New-Object System.Drawing.FontFamily "Segoe UI"), [System.Drawing.FontStyle]::Bold, 330 * $scale, [System.Drawing.PointF]::new($ox + 92 * $scale, $oy + 72 * $scale), [System.Drawing.StringFormat]::GenericDefault)
  $g.FillPath($indigo, $path)
  $g.DrawBezier((Pen "#FFFFFF" (30 * $scale)), $ox + 150 * $scale, $oy + 360 * $scale, $ox + 252 * $scale, $oy + 242 * $scale, $ox + 318 * $scale, $oy + 206 * $scale, $ox + 436 * $scale, $oy + 140 * $scale)
  $g.DrawLine((Pen "#111827" (12 * $scale)), $ox + 148 * $scale, $oy + 360 * $scale, $ox + 246 * $scale, $oy + 360 * $scale)
  $g.DrawLine((Pen "#111827" (12 * $scale)), $ox + 246 * $scale, $oy + 360 * $scale, $ox + 436 * $scale, $oy + 140 * $scale)
  $g.FillEllipse($indigo, $ox + 100 * $scale, $oy + 344 * $scale, 56 * $scale, 56 * $scale)
  $g.FillEllipse($emerald, $ox + 232 * $scale, $oy + 232 * $scale, 48 * $scale, 48 * $scale)
  $g.FillEllipse($indigo, $ox + 428 * $scale, $oy + 112 * $scale, 56 * $scale, 56 * $scale)
}

function Save($bitmap, $graphics, $path) {
  $graphics.Dispose()
  $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bitmap.Dispose()
}

$out = Split-Path -Parent $MyInvocation.MyCommand.Path
$title = New-Object System.Drawing.Font("Segoe UI", 118, [System.Drawing.FontStyle]::Bold)
$tag = New-Object System.Drawing.Font("Segoe UI", 36, [System.Drawing.FontStyle]::Bold)

$canvas = New-Canvas 1800 560
Draw-NexusIcon $canvas[1] 0.82 80 70
$canvas[1].DrawString("Nexus", $title, (Brush "#111827"), 560, 130)
$canvas[1].DrawString("PERSONAL ANALYTICS PLATFORM", $tag, (Brush "#64748B"), 568, 300)
$canvas[1].DrawLine((Pen "#6366F1" 12), 568, 378, 950, 378)
$canvas[1].FillEllipse((Brush "#10B981"), 980, 366, 24, 24)
$canvas[1].DrawLine((Pen "#6366F1" 12), 1024, 378, 1220, 378)
Save $canvas[0] $canvas[1] (Join-Path $out "nexus-logo-horizontal.png")

$canvas = New-Canvas 512 512
Draw-NexusIcon $canvas[1] 1 0 0
Save $canvas[0] $canvas[1] (Join-Path $out "nexus-icon.png")

$canvas = New-Canvas 64 64 $true
Draw-NexusIcon $canvas[1] 0.125 0 0
Save $canvas[0] $canvas[1] (Join-Path $out "nexus-favicon.png")
