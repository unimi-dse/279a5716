# musicdahboaRd2

musicdahboaRd is an R package for live lyrics analytics.
It get's the currently played song on spotify and returns a lyric analysis
Powered by Genius and Spotify API.

## Installation
Install all the dependencies(if you run these commands below and get an error citing a specific package,maybe you should install it).And then run these:
```R
Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS="true")
devtools::install_github('unimi-dse/279a5716')
```
## Usage
Run these:
```R
library(musicdashboaRd2)
run_app()
```
Then click on the 'Get currently playing song' button and let the magic happen! 
(follow on screen instruction during the first time to give the first time auth to the spotify api. After pressing the button "Get currently playing song", you should return to console and make the selction for saving to a local file the Oauth info, I suggest to save them. After that the browser will open and it will appear the spotify login page. After you login give the permission to access your account data and it's ready to use!)

PS: if you do not have any spotify instance open/playing something you will get this error:
```
Error in : parse error: premature EOF
                                       
                     (right here) ------^
```
When you want to exit the shiny app press ESC on terminal
## Use suggestions
- Listen to songs that defenitely are on Genius (mainly american rap songs: so go with Kanye West, Kendrick Lamar or some other great contemporary Lyricist).
- The analysis are english based (so try with english language songs).
## Known bugs
- Album cover don't shows sometimes(related to shiny, a bug)
- Sometimes the search works poorly (maybe rate limits of the genius api?)
- It takes a while to load for artist with a long discography(geniusr package is very slow in fetching, maybe it scapes data?).
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.