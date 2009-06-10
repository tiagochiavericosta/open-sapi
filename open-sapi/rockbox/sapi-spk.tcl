 #******************************************************************************
 #             __________               __   ___.
 #   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 #   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 #   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 #   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 #                     \/            \/     \/    \/            \/
 #
 #   Copyright (C) 2007 by Thomas Lloyd
 #
 # All files in this archive are subject to the GNU General Public License.
 # See the file COPYING in the source tree root for full license agreement.
 #
 # This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 # KIND, either express or implied.
 #
 #******************************************************************************

# ------------------------------------------------------------------------------
#Application Name: Open SAPI Clip Generator v0.1 Alpha for Rockbox Utulity
# ------------------------------------------------------------------------------

package require tcom

set verboseText 1

# ------------------------------------------------------------------------------
# ProcName : initAudioFormats
# Args : None
# Usage : Supplies the user with usage information when called through stdout
# Accepts: None
# Returns: None
# Called By: Main
#-------------------------------------------------------------------------------

proc helpMe {} {
   
   puts "Open SAPI Clip Generator v0.1 Alpha for Rockbox Utulity\n"

   puts "Usage: sapi-spk ...\[swithches\] -ehlortvx -t \"message\" @@ "
   puts "A command line interface providing access to the Microsoft Speech \
   Engine)\n"
   
   puts "Switches:"
   puts "\t -o <dir/filename.ext>  : Location & filename of output file"
   puts "\t -t, --text <text>      : Text to be spoken terminate with @@ "
   puts "\t -l, --volume <value>   : Sets Volume Level. Range Min 0 - 100 Max"
   puts "\t -r, --rate  <value>    : Sets Speech Rate. Range Min -10 - 10 Max"
   puts "\t --pitch <value>        : Sets Speech Rate. Range Min -10 - 10 Max"
   puts "\t --wavformat  <value>   : Sets Audio Format. ? for current list"

    puts "\t -e, --engine <value>   : Sets Default Engine"
#   puts "\t -d, --device <value>   : Sets Audio Device"
#   puts "\t -x, --noxml            : Turns on XML markup processing"
#   puts "\t --xml-global           : Enable XML markup globally"
#   puts "\t -i, --icon <file>      : Sound Icon to play"
#   puts "\t -a, --async            : Ayncronous Playback"
#   puts "\t     --purge            : Remove & replace all queued speech"
#   puts "\t -c, --config <file>    : Specify configuration file"
#   puts "\t -o, --save <file>      : Output current config to file"
#   puts "\t -s, --server <action>  : Server Actions - start, restart, stop"
#   puts "\t     --port <value>     : Server listing port. Default 5491"
   puts "\t  --test                : Tests components are present and configured"
   puts "\t -v, --verbose          : Verbose output"
#  puts "\t --pipemode             : Pipemode takes input on stdin to speak"
   puts "\t -h, --help             : This message\n"
   
   puts "*** Using ? instead of a numerical value will return the current\
    setting***\n"
   puts "For updates, guides and help please refer to the project page:" 
   puts "http://www.rockbox.org"
   puts "For bugs, comments and support please contact thomaslloyd@yahoo.com." 
}

# ------------------------------------------------------------------------------
# ProcName : initAudioFormats
# Args : None
# Usage : Used to generate full list of SAPI supported audio formats
# Accepts: None
# Returns: $audioFormats (list)
# Called By: Main on supported aduio formats request
#-------------------------------------------------------------------------------

proc initAudioFormats {} {

set audioFormats [list "SPSF_Default" "SPSF_NoAssignedFormat" "SPSF_Text"\
    "SPSF_NonStandardFormat" "SPSF_ExtendedAudioFormat" "SPSF_8kHz8BitMono"\
    "SPSF_8kHz8BitStereo" "SPSF_8kHz16BitMono" "SPSF_8kHz16BitStereo"\
    "SPSF_11kHz8BitMono" "SPSF_11kHz8BitStereo" "SPSF_11kHz16BitMono"\
    "SPSF_11kHz16BitStereo" "SPSF_12kHz8BitMono" "SPSF_12kHz8BitStereo"\
    "SPSF_12kHz16BitMono" "SPSF_12kHz16BitStereo" "SPSF_16kHz8BitMono"\
    "SPSF_16kHz8BitStereo" "SPSF_16kHz16BitMono" "SPSF_16kHz16BitStereo"\
    "SPSF_22kHz8BitMono" "SPSF_22kHz8BitStereo" "SPSF_22kHz16BitMono"\
    "SPSF_22kHz16BitStereo" "SPSF_24kHz8BitMono" "SPSF_24kHz8BitStereo"\
    "SPSF_24kHz16BitMono" "SPSF_24kHz16BitStereo" "SPSF_32kHz8BitMono"\
    "SPSF_32kHz8BitStereo" "SPSF_32kHz16BitMono" "SPSF_32kHz16BitStereo"\
    "SPSF_44kHz8BitMono" "SPSF_44kHz8BitStereo" "SPSF_44kHz16BitMono"\
    "SPSF_44kHz16BitStereo" "SPSF_48kHz8BitMono" "SPSF_48kHz8BitStereo"\
    "SPSF_48kHz16BitMono" "SPSF_48kHz16BitStereo" \
    "SPSF_TrueSpeech_8kHz1BitMono" "SPSF_CCITT_ALaw_8kHzMono"\
    "SPSF_CCITT_ALaw_8kHzStereo" "SPSF_CCITT_ALaw_11kHzMono"\
    "SPSF_CCITT_ALaw_11kHzStereo" "SPSF_CCITT_ALaw_22kHzMono"\
    "SPSF_CCITT_ALaw_22kHzStereo" "SPSF_CCITT_ALaw_44kHzMono"\
    "SPSF_CCITT_ALaw_44kHzStereo" "SPSF_CCITT_uLaw_8kHzMono"\
    "SPSF_CCITT_uLaw_8kHzStereo" "SPSF_CCITT_uLaw_11kHzMono"\
    "SPSF_CCITT_uLaw_11kHzStereo" "SPSF_CCITT_uLaw_22kHzMono"\
    "SPSF_CCITT_uLaw_22kHzStereo" "SPSF_CCITT_uLaw_44kHzMono"\
    "SPSF_CCITT_uLaw_44kHzStereo" "SPSF_ADPCM_8kHzMono"\
    "SPSF_ADPCM_8kHzStereo" "SPSF_ADPCM_11kHzMono" "SPSF_ADPCM_11kHzStereo"\
    "SPSF_ADPCM_22kHzMono" "SPSF_ADPCM_22kHzStereo" "SPSF_ADPCM_44kHzMono"\
    "SPSF_ADPCM_44kHzStereo" "SPSF_GSM610_8kHzMono" "SPSF_GSM610_11kHzMono"\
    "SPSF_GSM610_22kHzMono" "SPSF_GSM610_44kHzMono"]

return $audioFormats
}
# ------------------------------------------------------------------------------
# ProcName : bugMe 
# Args : $message to be output $logfile to be used for output
# Usage : If verbose output is on this function will output debug info to stdout 
# or logfile
# Accepts:
# Returns:
# Called By: Any debug statement
#-------------------------------------------------------------------------------
proc bugMe {message} {

 global verboseText

    if {$verboseText} { puts "$message" }

}
#-------------------------------------------------------------------------------
# Proceedure Name: getVolume
# Description: Returns the current engines volume setting.
# Accepts:
# Returns: Current Volume (0 - 100)
#-------------------------------------------------------------------------------
proc getVol {voice} {
   
   return [$voice Volume]    
}
#-------------------------------------------------------------------------------
# Proceedure Name: setVolume
# Description: Sets the specified engines volume.
# Accepts:
# Returns: NA
#-------------------------------------------------------------------------------
proc setVol {voice volume} {

   $voice Volume $volume    
}
#-------------------------------------------------------------------------------
# Proceedure Name: getRate
# Description:
# Accepts:
# Returns: Current Rate (+10 / -10)
#-------------------------------------------------------------------------------
proc getRate {voice} {

   return [$voice Rate] 

}
##------------------------------------------------------------------------------
# Proceedure Name: setRate
# Description:
# Accepts:
# Returns:
#-------------------------------------------------------------------------------
proc setRate {voice rate} {

   $voice Rate $rate

}
#-------------------------------------------------------------------------------
# Proceedure Name: getEngineArray
# Description:
# Accepts:
# Returns:
#-------------------------------------------------------------------------------
proc getEngineArray {voice} {

    if { [catch {set list [$voice GetVoices] } errmsg ]  } {
       puts "No Speech Engines Available - $errmsg"
       return
    }
    set howmany [$list Count]
    for {set i 0} {$i < $howmany} {incr i} {
        set engine [$list Item $i]
        set engineArray($i,name) [$engine GetDescription]
        set engineArray($i,gender) [$engine GetAttribute Gender]
        set engineArray($i,handle) $engine
    } 
return [array get engineArray]
}
#-------------------------------------------------------------------------------
# Proceedure Name: setEngine
# Description: Changes the current engine for the specified voice
#
# Returns: Nothing
#-------------------------------------------------------------------------------
proc setEngine {voice engine} {
 
   $voice Voice $engine
 
}
#-------------------------------------------------------------------------------
# Proceedure Name: testOutput
# Description: Test speech output with the given options 
#
# Returns: Nothing
#-------------------------------------------------------------------------------
proc testOutput {voice flag} {
   if { [catch { $voice Speak "Testing the SAPI speech engine & settings for\
   Rockbox Utility" $flag } errmsg ] } {
       puts "Speech initialisation failed - $errmsg"
       exit
   }  
}
#-------------------------------------------------------------------------------
# Proceedure Name: genFiles
# Description: Test speech output with the given options 
#
# Returns: Nothing
#-------------------------------------------------------------------------------


proc genFiles {voice filename text  format} {
  # Create the objects.
  
  set fileStream [::tcom::ref createobject Sapi.SpFileStream]
  set audioFormat [::tcom::ref createobject Sapi.SpAudioFormat]

  # Set the audio format of the file stream.
 
  $audioFormat Type $format
  $fileStream Format $audioFormat

  # Open the file and attach the stream to the voice.
  set SSFMCreateForWrite 3
  $fileStream Open $filename $SSFMCreateForWrite False
  $voice AudioOutputStream $fileStream

  # Speak the text.
  puts "processing : $text"
  $voice Speak $text 0
  $fileStream Close

}
#-------------------------------------------------------------------------------
# Proceedure Name: main
# Description: Test speech output with the given options 
#
# Returns: Nothing
#-------------------------------------------------------------------------------
 
 set voice [::tcom::ref createobject Sapi.SpVoice]
 
 set textPending 0
 set runTest 0
 set skip 0
 set flag 0
 set filename "[pwd]/sapi.wav"
 set x 0
 set pitch 0
 set text ""
 set wavFormat 22
 
   if {!$argc} {helpMe ; exit }
    
    foreach element $argv {
        if { $element == "-v" || $element == "--verbose" } { set verbose 1; bugMe "Verbose Output"}
        if { $element == "-h" || $element == "--help" } { helpMe ; exit }
    }
 
 set x 0
 
    foreach element $argv {
        if {$skip == 0} {
            switch -exact -- $element {
	        
                --wavformat {
                    set format [lindex $argv [expr $x + 1] ]
                    set audioFormats [initAudioFormats]
                    if { $format == "?"} {
                        set testStream [::tcom::ref createobject \
                        Sapi.SpFileStream]
                        set testFormat [::tcom::ref createobject \
                        Sapi.SpAudioFormat]
                        set testStreamFormat [$testStream Format]
                        
                        set i -1
                        foreach element $audioFormats {
                            if { $i > 5} {
                                $testFormat Type $i
                                $testStream Format $testFormat
                                set SSFMCreateForWrite 3
                                $testStream Open ./test.wav $SSFMCreateForWrite False
                                $voice AudioOutputStream $testStream
                                
                                if { [catch { $voice Speak " " 0 } err] } {
                                    bugMe "[expr $i-5] - Unsupported : $element"
                                } else {
                                    bugMe "[expr $i-5] - Passed      : $element"
                                }
                                $testStream Close
                            }

                            incr i
                         }
                    unset testFormat testStream testStreamFormat i
                    } else {
                        set wavFormat [expr $format + 5]
                        bugMe "Format set : [lindex $audioFormats $format]"
                    }
                    
                set skip 1
                }
                
                -o {
                    set filename [lindex $argv [expr $x + 1] ]
                    bugMe "Filename Set : $filename"
                    set skip 1
                }
                
                -a {
                    set flag [expr $flag | 1]
                    bugMe "Asy[expr $i-5]nc Mode" 
                }

                --async {
                    set flag [expr $flag | 1]
                    bugMe "Async Mode"
                }      
	          
	             -l {
                    # Requires a regexpression to check for valid input here 
                    set volume [lindex $argv [expr $x + 1] ]
                    if { $volume == "?"} {
                        set volume [getVol $voice]
                        bugMe "Current Volume: $volume " 
                    } else {
                        if { $volume < 0 } {
                            set volume 0
                            puts "Volume Range 0-100. Negative value detected, correcting to min 0"
                        }
                        if { $volume > 100 } { 
                            set volume 100
                            puts "Volume Range 0-100. Value too high, correcting to max 100"
                        }
                        setVol $voice $volume
                        bugMe "Volume Set: $volume"
                    }
	                 set skip 1
                }

                --volume {
                    # Requires a regexpression to check for valid input here 
                    set volume [lindex $argv [expr $x + 1] ]
                    if { $volume == "?"} {
                        set volume [getVol $voice]
                        bugMe "Current Volume: $volume " 
                    } else {
                        if { $volume < 0 } {
                            set volume 0
                            puts "Volume too low, correcting to min 0"
                        }
                        if { $volume > 100 } { 
                            set volume 100
                            puts "Volume too high, correcting to max 100"
                        }
                        setVol $voice $volume
                        bugMe "Volume Set: $volume"
                    }
	                 set skip 1
                }
              
                -e {
                    # Requires a regexpression to check for valid input here
                    set engineNum [lindex $argv [expr $x + 1] ]
                    set engineList [getEngineArray $voice]
                    array set voicesArray $engineList
                    if { $engineNum == "?"} {
                        set i 0
                        set arraySize [array size voicesArray]
                        # Needed with Multi Dimentional Arrays as size counts
                        # the total entrites of the hash table 
                        set arraySize [expr $arraySize / 3]
                        set currentVoice [$voice Voice]  
                        while {$i < $arraySize} {
                            set voiceHandle $voicesArray($i,handle)
                         #  setEngine $voice $voiceHandle
                            bugMe "Voice $i = $voicesArray($i,name) and is\
                            $voicesArray($i,gender)"
                            incr i                      
                        }
                        setEngine $voice $currentVoice
                        bugMe "Got Engine List"  
                    } else {
                        set voiceHandle $voicesArray($engineNum,handle)
                        setEngine $voice $voiceHandle
                        bugMe "Set TTS Engine: $voicesArray($engineNum,name)"
                    }  
	                 set skip 1
                }

                --engine {
                    # Requires a regexpression to check for valid input here
                    set engineNum [lindex $argv [expr $x + 1] ]
                    set engineList [getEngineArray $voice]
                    array set voicesArray $engineList
                    if { $engineNum == "?"} {
                        set i 0
                        set arraySize [array size voicesArray]
                        # Needed with Multi Dimentional Arrays as size counts
                        # the total entrites of the hash table 
                        set arraySize [expr $arraySize / 3]
                        set currentVoice [$voice Voice]  
                        while {$i < $arraySize} {
                            set voiceHandle $voicesArray($i,handle)
                       #    setEngine $voice $voiceHandle
                            bugMe "Voice $i = $voicesArray($i,name) and is\
                            $voicesArray($i,gender)"
                            incr i                      
                        }
                        setEngine $voice $currentVoice
                        bugMe "Got Engine List"  
                    } else {
                        set voiceHandle $voicesArray($engineNum,handle)
                        setEngine $voice $voiceHandle
                        bugMe "Set TTS Engine: $voicesArray($engineNum,name)"
                    }  
	                 set skip 1
                }

	             -r {
                    # Sanity check Requires a regexpression
                    set rate [lindex $argv [expr $x + 1] ]
                    if { $rate == "?"} {
                        set rate [getRate $voice] 
                        bugMe "Current Rate: $rate"
                    } else {
                        if { $rate < -10 } { set rate -10
                            puts "Rate too low, correcting to min 0"
                        }
                        if { $rate > 10 } { set rate 10
                            puts "Rate too high, correcting to max 10"
                        }
                        setRate $voice $rate
                        bugMe "Set Rate: $rate"
                    }
                    set skip 1           
                }

                --rate {
                    # Sanity check Requires a regexpression
                    set rate [lindex $argv [expr $x + 1] ]
                    if { $rate == "?"} {
                        set rate [getRate $voice] 
                        bugMe "Current Rate: $rate"
                    } else {
                        if { $rate < -10 } { set rate -10
                            puts "Rate too low, correcting to min 0"
                        }
                        if { $rate > 10 } { set rate 10
                            puts "Rate too high, correcting to max 10"
                        }
                        setRate $voice $rate
                        bugMe "Set Rate: $rate"
                    }
                    set skip 1    
                }

	             -t {
	                 set i 1
	                 set textPending 1
	                 set word [lindex $argv [expr $x + $i]]
	                 set text $word
	                 incr i
	                 while {$word != "@@"} {
	                     set word [lindex $argv [expr $x + $i]]
	                         if {$word != "@@"} {
	                             set text "$text $word"   
	                         }
	                 incr i
	                 }
	                 bugMe "Speak: $text"
	                 set skip [expr $i - 1]
                }

                --text {
                    set i 1
                    set textPending 1
	                 set word [lindex $argv [expr $x + $i]]
	                 set text $word
	                 incr i
	                 while {$word != "@@" ||} {
	                     set word [lindex $argv [expr $x + $i]]
	                     set text "$text $word"
	                     incr i
	                 }
	                 bugMe "Client: Send for speech  - $text"
	                 set skip [expr $i - 1]
                }

	             -x {
                    set flag [expr $flag | 8]
                    bugMe "Client: Speech Flag: $flag - XML" 
                }

                --xml {
                    set flag [expr $flag | 8]
                    bugMe "Client: Speech Flag: $flag - XML"  
                }

                --notxml {
                    set flag [expr $flag | 16]
                    bugMe "Client: Speech Flag: $flag - not XML"  
                }

                --test {
                    set runTest 1
                }
                
                --pitch {
                    set pitch [lindex $argv [expr $x + 1] ]
                    bugMe "Set Pitch: $pitch"
                    set skip 1
                }
                
                -v {}
                
                --verbose {}
                
                default {
                    puts "Unknown Option $element. Please type -h for usage help"
                }
         	
            } ; # End switch
        } else { set skip [expr $skip - 1]} ; # End if skip
    incr x
    };# End of foreach
    
    
      
    if {$runTest} {
        if {$textPending} {
            puts "Error: Testing overrides text output remove --test option first"
            testOutput $voice $flag
        } else {
            testOutput $voice $flag
        }
     } else {
         if {$textPending} {
             if {$pitch < 0 || $pitch > 0} {
                 set text "<pitch absmiddle=\"$pitch\"> $text </pitch>\
                 <pitchabsmiddle=\"0\"/>"
             }
             genFiles $voice $filename $text $wavFormat
         }
     }
 
 
