$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8080/')
$listener.Start()
Write-Host 'Server started on http://localhost:8080'
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $url = $context.Request.Url.LocalPath
    if ($url -eq '/') { $url = '/index.html' }
    $path = 'd:\77\ai web' + $url
    if (Test-Path $path) {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $ext = [System.IO.Path]::GetExtension($path)
        $mime = switch ($ext) {
            '.html' { 'text/html; charset=utf-8' }
            '.css'  { 'text/css' }
            '.js'   { 'application/javascript' }
            '.jpg'  { 'image/jpeg' }
            '.png'  { 'image/png' }
            default { 'application/octet-stream' }
        }
        $context.Response.ContentType = $mime
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $context.Response.StatusCode = 404
    }
    $context.Response.Close()
}
