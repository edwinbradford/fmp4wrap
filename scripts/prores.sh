#!/bin/bash

# Echo current directory
echo; pwd; echo

# Script title
echo "This script uses FFmpeg to encode media in Apple ProRes format and save it as *.mov."; echo;

# Check if FFmpeg exists
echo "Checking for FFmpeg..."; echo;
if command -v ffmpeg >/dev/null 2>&1 ; then
  echo "FFmpeg is installed."; echo;
else
  echo >&2 "FFmpeg is not installed. Please install it then try again."; echo;
  read -n 1 -s -r -p "Press any key to exit... ";
  exit 1;
fi

# Source media
echo "Drag and drop the folder containing the media into this window and press enter..."; echo;

# Disable case sensitivity and error reporting for missing file types
shopt -s nullglob
shopt -s nocaseglob

# Check for supported media files
while :; do
  # Assign selected directory path to variable
  IFS="" read -r input
  echo

  # Evaluate path variable for quotes and spaces for cd command
  eval "input=( $input )"

  # Use wslpath to convert Windows paths to Unix paths for WSL on Windows
  if command -v wslpath >/dev/null 2>&1; then
    input="$( wslpath "$input" )"
  fi

  # Change directory to selected directory
  cd "${input}"

  if [[ -n $(echo *.{avi,mkv,mov,mp4,mxf}) ]]; then
    echo "The following supported media files were found... "; echo;
    ls -l *.{avi,mkv,mov,mp4,mxf}; echo; break
  else
    echo "No supported media files found. Please try again... "; echo; continue
  fi

done

# Reset shell options
# shopt -u nullglob
# shopt -u nocaseglob

# Pause for input
read -n 1 -s -r -p "Press any key to continue... "
echo

# Make directory

if [ -d "mov" ]; then
  echo; echo "The existing 'mov' folder in your directory will be deleted."; echo;
  while true; do
    read -p "Delete? [y] / [n] " yn
    case $yn in
      [Yy]* ) rm -rf "mov"; break;;
      [Nn]* ) exit 0;;
      * ) echo; echo "Please enter 'y' for yes or 'n' for no... " ; echo;;
    esac
  done
fi

mkdir "mov";


# Re-encode supported video files with FFmpeg
for i in *.{avi,mkv,mov,mp4,mxf}
do

  # Skip file if it is a system file or symlink
  [ -f "$i" ] || break

  # Remove file extension
  j="${i%.*}"

  # qscale 0-32 where zero is maximum quality and 9-13 are sane values
  ffmpeg -probesize 5000000 \
  -i "$i" \
  -r 30 \
  -c:v prores_ks \
  -profile:v 2 \
  -pix_fmt yuv422p10le \
  -qscale:v 11 \
  -c:a pcm_s16le \
  -y "mov/${j}.mov" || { echo; echo "FFmpeg could not finish for some reason."; echo; read -n 1 -s -r -p "Press any key to exit... "; exit 1; }

  echo; echo "${i} was re-encoded and saved as ${j}.mov in 'mov/'."; echo;

done

echo "The following files were saved in a folder called 'mov' in the same directory as your source files:"
echo
ls -l mov/*.mov
echo

# Pause
read -n 1 -s -r -p "Finished re-encoding all files. Press any key to exit... "
echo

exit 0