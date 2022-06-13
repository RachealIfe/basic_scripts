#!/user/bin/bash

ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.*}.jpg"'

zip vintagepng.zip *.png
