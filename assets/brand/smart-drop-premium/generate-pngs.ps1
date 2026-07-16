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

function Draw-SmartDropMark($g, $s, $ox, $oy, $mono = $false, $dark = $false) {
  $drop = if ($mono) { "#111827" } elseif ($dark) { "#22C55E" } else { "#0EA5E9" }
  $leaf = if ($mono) { "#FFFFFF" } elseif ($dark) { "#22C55E" } else { "#15803D" }
  $leafLine = if ($mono) { "#111827" } else { "#FFFFFF" }
  $sun = if ($mono) { "#111827" } else { "#FACC15" }
  $circuit = if ($mono) { "#111827" } elseif ($dark) { "#86EFAC" } else { "#15803D" }

  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddBezier(
    [System.Drawing.PointF]::new($ox + 256 * $s, $oy + 48 * $s),
    [System.Drawing.PointF]::new($ox + 92 * $s, $oy + 252 * $s),
    [System.Drawing.PointF]::new($ox + 92 * $s, $oy + 428 * $s),
    [System.Drawing.PointF]::new($ox + 256 * $s, $oy + 532 * $s)
  )
  $path.AddBezier(
    [System.Drawing.PointF]::new($ox + 256 * $s, $oy + 532 * $s),
    [System.Drawing.PointF]::new($ox + 420 * $s, $oy + 428 * $s),
    [System.Drawing.PointF]::new($ox + 420 * $s, $oy + 252 * $s),
    [System.Drawing.PointF]::new($ox + 256 * $s, $oy + 48 * $s)
  )
  $path.CloseFigure()
  $g.FillPath((Brush $drop), $path)

  $g.DrawBezier((Pen "#FFFFFF" (27 * $s)), $ox + 136 * $s, $oy + 340 * $s, $ox + 212 * $s, $oy + 233 * $s, $ox + 289 * $s, $oy + 176 * $s, $ox + 411 * $s, $oy + 149 * $s)
  $g.DrawArc((Pen $sun (25 * $s)), $ox + 166 * $s, $oy + 190 * $s, 240 * $s, 154 * $s, 202, 132)

  $leafPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $leafPath.AddBezier(
    [System.Drawing.PointF]::new($ox + 166 * $s, $oy + 342 * $s),
    [System.Drawing.PointF]::new($ox + 250 * $s, $oy + 329 * $s),
    [System.Drawing.PointF]::new($ox + 330 * $s, $oy + 338 * $s),
    [System.Drawing.PointF]::new($ox + 409 * $s, $oy + 386 * $s)
  )
  $leafPath.AddBezier(
    [System.Drawing.PointF]::new($ox + 409 * $s, $oy + 386 * $s),
    [System.Drawing.PointF]::new($ox + 346 * $s, $oy + 461 * $s),
    [System.Drawing.PointF]::new($ox + 256 * $s, $oy + 503 * $s),
    [System.Drawing.PointF]::new($ox + 142 * $s, $oy + 491 * $s)
  )
  $leafPath.AddBezier(
    [System.Drawing.PointF]::new($ox + 142 * $s, $oy + 491 * $s),
    [System.Drawing.PointF]::new($ox + 143 * $s, $oy + 434 * $s),
    [System.Drawing.PointF]::new($ox + 151 * $s, $oy + 385 * $s),
    [System.Drawing.PointF]::new($ox + 166 * $s, $oy + 342 * $s)
  )
  $leafPath.CloseFigure()
  $g.FillPath((Brush $leaf), $leafPath)
  $g.DrawBezier((Pen $leafLine (24 * $s)), $ox + 170 * $s, $oy + 489 * $s, $ox + 222 * $s, $oy + 417 * $s, $ox + 287 * $s, $oy + 369 * $s, $ox + 379 * $s, $oy + 332 * $s)

  $g.DrawArc((Pen "#FFFFFF" (20 * $s)), $ox + 139 * $s, $oy + 166 * $s, 234 * $s, 166 * $s, 205, 130)
  $g.DrawArc((Pen "#FFFFFF" (17 * $s)), $ox + 188 * $s, $oy + 224 * $s, 136 * $s, 100 * $s, 205, 130)
  $g.FillEllipse((Brush "#FFFFFF"), $ox + 242 * $s, $oy + 278 * $s, 28 * $s, 28 * $s)

  $g.DrawLine((Pen $sun (17 * $s)), $ox + 382 * $s, $oy + 98 * $s, $ox + 448 * $s, $oy + 98 * $s)
  $g.DrawLine((Pen $sun (17 * $s)), $ox + 415 * $s, $oy + 65 * $s, $ox + 415 * $s, $oy + 131 * $s)
  $g.DrawLine((Pen $circuit (17 * $s)), $ox + 92 * $s, $oy + 392 * $s, $ox + 44 * $s, $oy + 392 * $s)
  $g.DrawLine((Pen $circuit (17 * $s)), $ox + 44 * $s, $oy + 392 * $s, $ox + 44 * $s, $oy + 349 * $s)
  $g.DrawLine((Pen $circuit (17 * $s)), $ox + 44 * $s, $oy + 392 * $s, $ox + 16 * $s, $oy + 392 * $s)
  $g.FillEllipse((Brush $circuit), $ox + 3 * $s, $oy + 379 * $s, 26 * $s, 26 * $s)
  $g.FillEllipse((Brush $circuit), $ox + 79 * $s, $oy + 379 * $s, 26 * $s, 26 * $s)
}

function Draw-Wordmark($g, $x, $y, $scale, $dark = $false, $mono = $false, $center = $false) {
  $titleSize = 92 * $scale
  $tagSize = 28 * $scale
  $fontTitle = New-Object System.Drawing.Font("Segoe UI", $titleSize, [System.Drawing.FontStyle]::Bold)
  $fontTag = New-Object System.Drawing.Font("Segoe UI", $tagSize, [System.Drawing.FontStyle]::Bold)
  $smart = if ($dark) { "#FFFFFF" } else { "#111827" }
  $drop = if ($mono) { $smart } elseif ($dark) { "#86EFAC" } else { "#15803D" }
  $muted = if ($dark) { "#CBD5E1" } else { "#64748B" }
  $sf = [System.Drawing.StringFormat]::GenericDefault
  if ($center) { $sf.Alignment = [System.Drawing.StringAlignment]::Center }
  if ($center) {
    $g.DrawString("Smart Drop", $fontTitle, (Brush $smart), [System.Drawing.PointF]::new($x, $y), $sf)
    $g.DrawString("INTELLIGENT IRRIGATION", $fontTag, (Brush $muted), [System.Drawing.PointF]::new($x, $y + 106 * $scale), $sf)
  } else {
    $g.DrawString("Smart", $fontTitle, (Brush $smart), $x, $y)
    $g.DrawString("Drop", $fontTitle, (Brush $drop), $x + 430 * $scale, $y)
    $g.DrawString("SOLAR-POWERED IOT IRRIGATION", $fontTag, (Brush $muted), $x + 6 * $scale, $y + 118 * $scale)
    $lineColor = "#22C55E"
    if ($mono) { $lineColor = $smart }
    if ($dark) { $lineColor = "#22C55E" }
    $linePen = Pen $lineColor (9 * $scale)
    $g.DrawLine($linePen, $x + 6 * $scale, $y + 168 * $scale, $x + 640 * $scale, $y + 168 * $scale)
    if (-not $mono) {
      $g.FillEllipse((Brush "#0EA5E9"), $x + 330 * $scale, $y + 159 * $scale, 18 * $scale, 18 * $scale)
      $g.FillEllipse((Brush "#0EA5E9"), $x + 442 * $scale, $y + 159 * $scale, 18 * $scale, 18 * $scale)
    }
  }
}

function Save($bitmap, $graphics, $path) {
  $graphics.Dispose()
  $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bitmap.Dispose()
}

$out = Split-Path -Parent $MyInvocation.MyCommand.Path

$canvas = New-Canvas 2200 640
Draw-SmartDropMark $canvas[1] 0.62 68 44
Draw-Wordmark $canvas[1] 660 174 1
Save $canvas[0] $canvas[1] (Join-Path $out "smart-drop-primary.png")

$canvas = New-Canvas 2200 640 "#FFFFFF"
Draw-SmartDropMark $canvas[1] 0.62 68 44
Draw-Wordmark $canvas[1] 660 174 1
Save $canvas[0] $canvas[1] (Join-Path $out "smart-drop-light.png")

$canvas = New-Canvas 2200 640 "#111827"
Draw-SmartDropMark $canvas[1] 0.62 68 44 $false $true
Draw-Wordmark $canvas[1] 660 174 1 $true
Save $canvas[0] $canvas[1] (Join-Path $out "smart-drop-dark.png")

$canvas = New-Canvas 2200 640
Draw-SmartDropMark $canvas[1] 0.62 68 44 $true
Draw-Wordmark $canvas[1] 660 174 1 $false $true
Save $canvas[0] $canvas[1] (Join-Path $out "smart-drop-monochrome.png")

$canvas = New-Canvas 900 1024
Draw-SmartDropMark $canvas[1] 0.88 226 34
Draw-Wordmark $canvas[1] 450 790 0.78 $false $false $true
Save $canvas[0] $canvas[1] (Join-Path $out "smart-drop-stacked.png")

$canvas = New-Canvas 512 512
Draw-SmartDropMark $canvas[1] 0.9 26 -22
Save $canvas[0] $canvas[1] (Join-Path $out "smart-drop-icon.png")

$canvas = New-Canvas 1024 1024 "#FFFFFF"
Draw-SmartDropMark $canvas[1] 1.66 86 -26
Save $canvas[0] $canvas[1] (Join-Path $out "smart-drop-app-icon.png")

$canvas = New-Canvas 64 64 "#FFFFFF"
Draw-SmartDropMark $canvas[1] 0.112 3 -1
Save $canvas[0] $canvas[1] (Join-Path $out "smart-drop-favicon.png")

$canvas = New-Canvas 1600 1100 "#F8FAFC"
$g = $canvas[1]
$g.FillRectangle((Brush "#FFFFFF"), 64, 64, 1472, 972)
$title = New-Object System.Drawing.Font("Segoe UI", 62, [System.Drawing.FontStyle]::Bold)
$sub = New-Object System.Drawing.Font("Segoe UI", 25, [System.Drawing.FontStyle]::Regular)
$h = New-Object System.Drawing.Font("Segoe UI", 34, [System.Drawing.FontStyle]::Bold)
$body = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$g.DrawString("Smart Drop", $title, (Brush "#111827"), 120, 96)
$g.DrawString("Brand guidelines preview for intelligent solar irrigation monitoring", $sub, (Brush "#64748B"), 120, 206)
Draw-SmartDropMark $g 0.42 130 252
Draw-Wordmark $g 420 302 0.6
$g.FillRectangle((Brush "#111827"), 930, 244, 456, 228)
Draw-SmartDropMark $g 0.24 970 270 $false $true
Draw-Wordmark $g 1136 304 0.28 $true
$g.DrawString("Logo System", $h, (Brush "#111827"), 120, 532)
$g.DrawString("Palette", $h, (Brush "#111827"), 1160, 532)
Draw-SmartDropMark $g 0.35 176 610
$g.DrawString("Icon only", $body, (Brush "#111827"), 196, 884)
Draw-SmartDropMark $g 0.28 548 610
Draw-Wordmark $g 610 805 0.22 $false $false $true
$g.DrawString("Stacked", $body, (Brush "#111827"), 548, 884)
Draw-SmartDropMark $g 0.30 860 626
$g.DrawString("App icon", $body, (Brush "#111827"), 902, 884)
$colors = @("#22C55E", "#15803D", "#0EA5E9", "#111827")
$labels = @("#22C55E", "#15803D", "#0EA5E9", "#111827")
for ($i = 0; $i -lt $colors.Length; $i++) {
  $y = 584 + ($i * 116)
  $g.FillRectangle((Brush $colors[$i]), 1160, $y, 90, 90)
  $g.DrawString($labels[$i], $body, (Brush "#111827"), 1275, $y + 24)
}
$footer = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Regular)
$g.DrawString("Solar-powered IoT irrigation for precise, sustainable water use.", $footer, (Brush "#64748B"), 120, 976)
Save $canvas[0] $canvas[1] (Join-Path $out "brand-guidelines.png")
