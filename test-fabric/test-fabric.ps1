## 🚀 Summarize URLs using Fabric

$Urls = @(
    "https://www.youtube.com/watch?v=oo9c9HC-pmM", # Title: The Incredible Wildlife of Hidden Forests (Nature Documentary)
    "https://www.youtube.com/watch?v=Z_5CiV7WyEA", # Title: Nature's Greatest Talents - Smart And Smarter (Wildlife/Education)
    "https://www.youtube.com/watch?v=Qps9woUGkvI", # Title: Beautiful Relaxing Soothing Music, Peaceful Music (Meditation/Music)
    "https://www.youtube.com/watch?v=lQm-LbSJarQ", # Title: 77k mysterious clips uploaded to YouTube - why? (BBC News explanation of Webdriver Torso)
    "https://www.youtube.com/watch?v=cEnLUV1lcsk"  # Title: Best Of Family Friendly (Family-friendly compilation/entertainment)
)

# 2. Loop through each URL and call the 'fabric' command
foreach ($Url in $Urls) {
    Write-Host "--- Processing URL: $Url ---"

    # Construct and execute the command
    # The `&` (Call operator) is used to execute a command or script block.
    # The command is passed the arguments: -y, the current URL, -p, and summarize.
    try {
        & fabric -y $Url -p summarize
    }
    catch {
        Write-Error "Error executing fabric for ${Url}: $($_.Exception.Message)"
    }

    Write-Host "" # Add a blank line for readability
}

Write-Host "--- Processing complete. ---"