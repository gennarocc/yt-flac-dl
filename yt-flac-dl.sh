#!/bin/bash

# Set default download directory
DEFAULT_DOWNLOAD_DIRECTORY="/hdd/music/.tmp/complete/yt-dl/"

# Function for displaying usage information
show_usage() {
    echo "Usage: yt-flac-dl [playlist url] [download directory (optional)]"
    echo "Downloads YouTube playlist audio in FLAC format with metadata"
}

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    echo "Error: yt-dlp is not installed. Please install it first."
    exit 1
fi

# Check for required argument
if [ $# -eq 0 ]; then
    echo "Error: No playlist URL provided"
    show_usage
    exit 1
fi

PLAYLIST="$1"

# Handle download directory
if [ $# -ge 2 ]; then
    DOWNLOAD_DIRECTORY="$2"
    # Ensure directory ends with a slash
    [[ "${DOWNLOAD_DIRECTORY}" != */ ]] && DOWNLOAD_DIRECTORY="${DOWNLOAD_DIRECTORY}/"
else
    DOWNLOAD_DIRECTORY="$DEFAULT_DOWNLOAD_DIRECTORY"
fi

# Create download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIRECTORY"

# Log start of download
echo "Starting download from: $PLAYLIST"
echo "Files will be saved to: $DOWNLOAD_DIRECTORY"

# Run the download with error handling
yt-dlp -f 251/bestaudio \
    -o "$DOWNLOAD_DIRECTORY%(artist)s - %(title)s.%(ext)s" \
    -x --audio-format flac \
    --parse-metadata "description:(?s)(?P<meta_comment>.+)" \
    --parse-metadata "description:(?s)(?P<meta_year>\b\d{4}\b)" \
    --parse-metadata "description:(?s)(?P<meta_date>\d{4}-\d{2}-\d{2})" \
    --embed-metadata --embed-thumbnail \
    --convert-thumbnails jpg --ppa "ffmpeg: -c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
    "$PLAYLIST"

# Check exit status
if [ $? -eq 0 ]; then
    echo "Download completed successfully!"
    echo "Files saved to: $DOWNLOAD_DIRECTORY"
else
    echo "Error occurred during download. Please check the output above."
fi
