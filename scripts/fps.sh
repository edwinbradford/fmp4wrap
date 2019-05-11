#!/bin/bash

# Echo current directory
pwd
echo

# Script title
echo "This script re-encodes video at a constant frame rate using libx264 and saves it as *.mp4"
echo

echo "Checking for FFmpeg..."
echo

# Check if FFmpeg exists
ffmpeg -version >/dev/null 2>&1 || { echo >&2 "FFmpeg is not installed. Please install it then try again.";
read -n1 -r -p "Press any key to exit..."
exit 1; }

echo "FFmpeg is installed."
echo

echo "Drag and drop the folder containing the video(s) to be re-encoded into this window and press enter..."
echo

# Assign selected directory path to variable
IFS="" read -r input
echo

# Evaluate path for spaces and escaped characters
eval "files=( $input )"

# Change directory to selected directory
cd "${files}"

# Disable case sensitivity and don't print errors for missing file types
shopt -s nullglob
shopt -s nocaseglob

# List all files with supported video formats
echo "The following files will be re-encoded:"
echo

ls -l *.{avi,mkv,mov,mp4,mxf}
echo

# Reset shell options
# shopt -u nullglob
# shopt -u nocaseglob

# Pause for input
read -n1 -r -p "Press any key to continue..."
echo

# Make directory
if [ ! -d mp4 ]; then
  mkdir mp4;
fi

# Re-encode supported video files with FFmpeg
for i in *.{avi,mkv,mov,mp4,mxf}
do

  # Skip file if it is a system file or symlink
  [ -f "$i" ] || break

  # Remove file extension
  j="${i%.*}"

  # Re-encode with FFmpeg
  ffmpeg -i "$i" \
  -r 60 \
  -c:v libx264 \
  -preset slow \
  -crf 18 \
  -y mp4/"$j".mp4
  echo

  echo "$i" was re-encoded and saved as "$j".mp4 in 'mp4'
  echo

done

echo "The following files were saved in an 'mp4' folderin the same directory as your videos:"
echo
ls -l mp4/*.mp4
echo

# Pause
read -n1 -r -p "Finished re-encoding all files. Press any key to exit..."
echo

exit 0