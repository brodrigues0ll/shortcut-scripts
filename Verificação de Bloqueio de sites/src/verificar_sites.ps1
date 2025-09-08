$sites = @(
    @{Nome="Netflix"; URL="https://www.netflix.com"},
    @{Nome="YouTube"; URL="https://www.youtube.com"},
    @{Nome="Amazon Prime Video"; URL="https://www.primevideo.com"},
    @{Nome="Disney Plus"; URL="https://www.disneyplus.com"},
    @{Nome="HBO Max"; URL="https://www.max.com"},
    @{Nome="Hulu"; URL="https://www.hulu.com"},
    @{Nome="Apple TV Plus"; URL="https://tv.apple.com"},
    @{Nome="Peacock"; URL="https://www.peacocktv.com"},
    @{Nome="Spotify"; URL="https://www.spotify.com"},
    @{Nome="Twitch"; URL="https://www.twitch.tv"},
    @{Nome="BBC iPlayer"; URL="https://www.bbc.co.uk/iplayer"},
    @{Nome="Discovery Plus"; URL="https://www.discoveryplus.com"},
    @{Nome="YouTube Music"; URL="https://music.youtube.com"},
    @{Nome="SoundCloud"; URL="https://soundcloud.com"},
    @{Nome="Facebook"; URL="https://www.facebook.com"},
    @{Nome="Instagram"; URL="https://www.instagram.com"},
    @{Nome="Twitter"; URL="https://www.twitter.com"},
    @{Nome="X"; URL="https://www.x.com"},
    @{Nome="TikTok"; URL="https://www.tiktok.com"},
    @{Nome="LinkedIn"; URL="https://www.linkedin.com"},
    @{Nome="Reddit"; URL="https://www.reddit.com"},
    @{Nome="Snapchat"; URL="https://www.snapchat.com"},
    @{Nome="Pinterest"; URL="https://www.pinterest.com"}
)

$timeout = 5000 # Timeout em milissegundos (5 segundos)

Write-Host "Verificando sites..." -ForegroundColor Cyan

function Test-Site {
    param([string]$nome, [string]$url, [int]$timeout)

    try {
        $request = [System.Net.HttpWebRequest]::Create($url)
        $request.Method = "GET"
        $request.Timeout = $timeout
        $request.AllowAutoRedirect = $true
        $request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        $response = $request.GetResponse()
        $status = $response.StatusCode
        $response.Close()

        if ($status -ge 200 -and $status -lt 400) {
            Write-Host "${nome}: Acessivel (Status: $status)" -ForegroundColor Green
        } else {
            Write-Host "${nome}: Responde mas status inesperado ($status)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "${nome}: BLOQUEADO ou sem resposta HTTP" -ForegroundColor Red
    }
}

foreach ($s in $sites) {
    Test-Site -nome $s.Nome -url $s.URL -timeout $timeout
}

Write-Host "`nTeste concluido!" -ForegroundColor Cyan
Pause
