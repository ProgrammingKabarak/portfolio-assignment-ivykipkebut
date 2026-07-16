Add-Type -AssemblyName System.Drawing

function New-Canvas($width, $height) {
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $graphics.Clear([System.Drawing.Color]::Transparent)
  return @($bitmap, $graphics)
}

function New-Brush($hex) {
  return New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($hex))
}

function New-Pen($hex, $width) {
  $pen = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($hex), $width)
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  return $pen
}

function Add-DropletPath($scale, $offsetX, $offsetY) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddBezier(
    [System.Drawing.PointF]::new($offsetX + 256 * $scale, $offsetY + 72 * $scale),
    [System.Drawing.PointF]::new($offsetX + 124 * $scale, $offsetY + 236 * $scale),
    [System.Drawing.PointF]::new($offsetX + 124 * $scale, $offsetY + 403 * $scale),
    [System.Drawing.PointF]::new($offsetX + 256 * $scale, $offsetY + 460 * $scale)
  )
  $path.AddBezier(
    [System.Drawing.PointF]::new($offsetX + 256 * $scale, $offsetY + 460 * $scale),
    [System.Drawing.PointF]::new($offsetX + 388 * $scale, $offsetY + 403 * $scale),
    [System.Drawing.PointF]::new($offsetX + 388 * $scale, $offsetY + 236 * $scale),
    [System.Drawing.PointF]::new($offsetX + 256 * $scale, $offsetY + 72 * $scale)
  )
  $path.CloseFigure()
  return $path
}

function Draw-Mark($graphics, $scale, $offsetX, $offsetY, $mono) {
  $dropBrush = if ($mono) { New-Brush "#111827" } else { New-Brush "#0EA5E9" }
  $leafBrush = if ($mono) { New-Brush "#16A34A" } else { New-Brush "#16A34A" }
  $whiteBrush = New-Brush "#FFFFFF"
  $greenPen = New-Pen "#16A34A" (18 * $scale)
  $whitePenLarge = New-Pen "#FFFFFF" (22 * $scale)
  $whitePenSmall = New-Pen "#FFFFFF" (18 * $scale)
  $sunPen = New-Pen "#FACC15" (18 * $scale)

  $dropPath = Add-DropletPath $scale $offsetX $offsetY
  $graphics.FillPath($dropBrush, $dropPath)

  $leafPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $leafPath.AddBezier(
    [System.Drawing.PointF]::new($offsetX + 254 * $scale, $offsetY + 372 * $scale),
    [System.Drawing.PointF]::new($offsetX + 306 * $scale, $offsetY + 254 * $scale),
    [System.Drawing.PointF]::new($offsetX + 392 * $scale, $offsetY + 224 * $scale),
    [System.Drawing.PointF]::new($offsetX + 450 * $scale, $offsetY + 246 * $scale)
  )
  $leafPath.AddBezier(
    [System.Drawing.PointF]::new($offsetX + 450 * $scale, $offsetY + 246 * $scale),
    [System.Drawing.PointF]::new($offsetX + 436 * $scale, $offsetY + 317 * $scale),
    [System.Drawing.PointF]::new($offsetX + 377 * $scale, $offsetY + 384 * $scale),
    [System.Drawing.PointF]::new($offsetX + 254 * $scale, $offsetY + 372 * $scale)
  )
  $leafPath.CloseFigure()
  $graphics.FillPath($leafBrush, $leafPath)

  $graphics.DrawBezier($whitePenSmall,
    [System.Drawing.PointF]::new($offsetX + 259 * $scale, $offsetY + 368 * $scale),
    [System.Drawing.PointF]::new($offsetX + 291 * $scale, $offsetY + 317 * $scale),
    [System.Drawing.PointF]::new($offsetX + 335 * $scale, $offsetY + 286 * $scale),
    [System.Drawing.PointF]::new($offsetX + 398 * $scale, $offsetY + 265 * $scale)
  )
  $graphics.DrawArc($whitePenLarge, $offsetX + 164 * $scale, $offsetY + 168 * $scale, 184 * $scale, 128 * $scale, 205, 130)
  $graphics.DrawArc($whitePenSmall, $offsetX + 204 * $scale, $offsetY + 218 * $scale, 104 * $scale, 74 * $scale, 205, 130)
  $graphics.FillEllipse($whiteBrush, $offsetX + 242 * $scale, $offsetY + 286 * $scale, 28 * $scale, 28 * $scale)

  if (-not $mono) {
    $graphics.DrawLine($sunPen, $offsetX + 334 * $scale, $offsetY + 104 * $scale, $offsetX + 398 * $scale, $offsetY + 104 * $scale)
    $graphics.DrawLine($sunPen, $offsetX + 366 * $scale, $offsetY + 72 * $scale, $offsetX + 366 * $scale, $offsetY + 136 * $scale)
  }

  $graphics.DrawLine($greenPen, $offsetX + 80 * $scale, $offsetY + 400 * $scale, $offsetX + 166 * $scale, $offsetY + 400 * $scale)
  $graphics.DrawLine($greenPen, $offsetX + 166 * $scale, $offsetY + 400 * $scale, $offsetX + 166 * $scale, $offsetY + 348 * $scale)
  $graphics.DrawLine($greenPen, $offsetX + 166 * $scale, $offsetY + 400 * $scale, $offsetX + 224 * $scale, $offsetY + 400 * $scale)
  $graphics.FillEllipse($leafBrush, $offsetX + 66 * $scale, $offsetY + 386 * $scale, 28 * $scale, 28 * $scale)
  $graphics.FillEllipse($leafBrush, $offsetX + 210 * $scale, $offsetY + 386 * $scale, 28 * $scale, 28 * $scale)
}

function Save-Png($bitmap, $graphics, $path) {
  $graphics.Dispose()
  $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bitmap.Dispose()
}

$out = Split-Path -Parent $MyInvocation.MyCommand.Path

$canvas = New-Canvas 2048 640
Draw-Mark $canvas[1] 0.9 70 88 $false
$fontTitle = New-Object System.Drawing.Font("Segoe UI", 114, [System.Drawing.FontStyle]::Bold)
$fontTag = New-Object System.Drawing.Font("Segoe UI", 36, [System.Drawing.FontStyle]::Bold)
$canvas[1].DrawString("Smart", $fontTitle, (New-Brush "#111827"), 620, 132)
$canvas[1].DrawString("Drop", $fontTitle, (New-Brush "#16A34A"), 960, 132)
$canvas[1].DrawString("SOLAR IRRIGATION MONITORING", $fontTag, (New-Brush "#64748B"), 626, 302)
$canvas[1].DrawLine((New-Pen "#22C55E" 12), 626, 380, 1330, 380)
Save-Png $canvas[0] $canvas[1] (Join-Path $out "smart-drop-logo-full.png")

$canvas = New-Canvas 2048 640
Draw-Mark $canvas[1] 0.9 70 88 $true
$canvas[1].DrawString("Smart Drop", $fontTitle, (New-Brush "#111827"), 620, 132)
$canvas[1].DrawString("SOLAR IRRIGATION MONITORING", $fontTag, (New-Brush "#111827"), 626, 302)
$canvas[1].DrawLine((New-Pen "#111827" 12), 626, 380, 1330, 380)
Save-Png $canvas[0] $canvas[1] (Join-Path $out "smart-drop-logo-monochrome.png")

$canvas = New-Canvas 1024 1024
$canvas[1].FillRectangle((New-Brush "#FFFFFF"), 0, 0, 1024, 1024)
Draw-Mark $canvas[1] 1.72 72 70 $false
Save-Png $canvas[0] $canvas[1] (Join-Path $out "smart-drop-app-icon.png")

$canvas = New-Canvas 512 512
Draw-Mark $canvas[1] 1 0 0 $false
Save-Png $canvas[0] $canvas[1] (Join-Path $out "smart-drop-mark.png")

$canvas = New-Canvas 64 64
Draw-Mark $canvas[1] 0.12 1 0 $false
Save-Png $canvas[0] $canvas[1] (Join-Path $out "smart-drop-favicon.png")
