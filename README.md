# ffshell
ffshell is a collection of bash scripts that re-encode media to a different format using FFmpeg. They will check to see if FFmpeg is installed and warn you if it isn't. The scripts have been tested on macOS and Windows and should work on Unix. Windows users need to install bash to run the scripts, the easiest way to run bash on Windows is to install Git for Windows which includes Git Bash.

The scripts are:

fMP4\
MP4 CRF 20\
MP4 CFR 60\
DNxHD 90

fMP4\
Re-encodes media as fragmented MP4 (FMP4) and packages it for adaptive bitrate streaming both as MPEG-DASH and HLS. Currently the streams generated by FMP4 validate but do not play back with consistent results in both MPEG-DASH and HLS players. I'm unable to find any errors and put the inconsistency results down to the immaturity of FMP4, MPEG-DASH and HLS formats and lack of mature media players.

MP4 CRF 20\
Re-encodes video as H264 MP4 using a Constant Rate Factor (CRF) of 20 which generates high quality video with a reasonable level of compression. This script is suitable for generating online videos that will be self hosted and don't require adaptive bitrate streaming over HTTP. Four resolutions are supported 1080p, 720p, 480p and 360p.

MP4 CFR 60\
Re-encodes source video at a constant frame rate (CFR) of 60 frames per second whilst maintaining audio sync. At the time of writing, variable frame rate (VFR) MP4s such as those commonly generated by phones and portable cameras have missing frame issues when exported from video editors. Converting the video to a constant frame rate fixes missing these issues.

DNxHD 90\
Re-encodes media using the industry standard and open source codec DNxHD. DNxHD uses intraframe (spatial) compression and is an ideal codec for source footage in video editors. DNxHD is open source, natively cross platfrom and does not require the installation of any software such as Apple Quicktime. This script uses DNxHD 90 which generates 1080p at 60 frames per second. Files are saved in MXF format also natively supported on all platforms.
