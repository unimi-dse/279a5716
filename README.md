# musicdahboaRd2

musicdahboaRd is an R package for live lyrics analytics.
It get's the currently played song on spotify and returns a lyric analysis
Powered by Genius and Spotify API.

## Installation

```R
devtools::install_github('unimi-dse/279a5716')
```
## Usage

```R
library(musicdashboaRd2)
run_app()
```
Then click on the 'Get currently playing song' button and let the magic happen! 
(follow on screen instruction during the first time to give the first time auth to the spotify api)

PS: if you do not have any spotify instance open/playing something you will get this error:
```
Error in : parse error: premature EOF
                                       
                     (right here) ------^
```
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.