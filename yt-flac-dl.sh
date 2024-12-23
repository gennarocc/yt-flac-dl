#!/bin/bash
if [ $# -eq 0 ]; then
    echo "No playlist URL provided"
    echo "Usage: yt-flac-dl [playlist url] [download directory (optional)]"
    exit;
fi

PLAYLIST=$1
# Set default download directory bellow.
DOWNLOAD_DIRECTORY=./

if [ -n $2 ]; then
    DOWNLOAD_DIRECTORY=$2
fi

yt-dlp -f 251/bestaudio \
-o "$DOWNLOAD_DIRECTORY%(artist)s - %(title)s.%(ext)s" \
-x --audio-format flac \
--parse-metadata "description:(?s)(?P<meta_comment>.+)" \
--parse-metadata "description:(?s)(?P<meta_year>\b\d{4}\b)" \
--parse-metadata "description:(?s)(?P<meta_date>\d{4}-\d{2}-\d{2})" \
--embed-metadata --embed-thumbnail \
--convert-thumbnails jpg --ppa "ffmpeg: -c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
$PLAYLIST
