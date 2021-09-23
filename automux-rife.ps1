#Gets video files from current directory
$vList = (Get-ChildItem *.avi, *.divx, *.dvx, *.f4p, *.f4v, *.fli, *.flv,
 *.mp4, *.mov, *.m4v, *.mpg, *.mpeg, *.wmv, *.mkv, *.xvid -File)
 $patternEx = '^((?!RIFE).)*$'
 $patternIn = '-\dx-RIFE-RIFE\d\.\d-\d*(?:.\d*)?fps$'
 $outputDir = 'E:/'
 #Parses each video file
 foreach($video in $vList)
 {
    $vPattern = $video.BaseName.Replace("(", "\(").replace(")", "\)").replace("[", "\[").replace("]", "\]") + $patternIn
    #Searches for matching RIFE video file
    foreach($rife in $vList)
    {
        if($rife.BaseName -match $vPattern)
        {
            $vTrack = $rife
            $aTrack = $video
            $outputFile = $outputDir + $aTrack.BaseName + $vTrack.Extension
            #Mux video and audio track from source files
            mkvmerge -o $outputFile $vTrack -D -B -T -M --no-global-tags -a 1 $aTrack
            #Deletes sources files if mkvmerge is successful
            if($LASTEXITCODE -eq 0)
            {
                $vTrack.Delete()
                $aTrack.Delete()
            }
            #Ends search for matching RIFE video file(expects only one)
            break
        }
    }
 }