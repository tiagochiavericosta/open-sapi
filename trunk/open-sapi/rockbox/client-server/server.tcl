#*******************************************************************************
#             __________               __   ___.
#   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
#   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
#   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
#   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
#                     \/            \/     \/    \/            \/
#
#   Copyright (C) 2009 by Thomas Lloyd
#
# All files in this archive are subject to the GNU General Public License.
# See the file COPYING in the source tree root for full license agreement.
#
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
# KIND, either express or implied.
#
#*******************************************************************************

# ------------------------------------------------------------------------------
#Application Name: Open SAPI Clip Generator v0.1 Alpha for Rockbox Utulity
# ------------------------------------------------------------------------------

package require tcom

set verboseText 0
# ------------------------------------------------------------------------------
# ProcName : bugClient
# Args     : 
# Usage    : 
# Accepts  : 
# Returns  :
# Called By: 
#-------------------------------------------------------------------------------
proc bugClient { value message sock } {
global errorArray
        puts $sock "$value$message"
} 
# ------------------------------------------------------------------------------
# ProcName : initErrorCodes
# Args     : None
# Usage    : Used to generate full list of system status codes
# Accepts  : None
# Returns  : $errorArray - array(code,message)
# Called By: Main on supported aduio formats request
#-------------------------------------------------------------------------------

proc initErrorCodes {} {

    set errorCodes [list {
        100.Trying.\
        101.Trying Synth.\
        102.Trying Settings.\
        103.Trying Test.\
        200.OK.\
        201.Synth OK.\
        202.Settings OK.\
        203.Test OK.\
        204.Server Ready.\
        299.Shutdown OK.\
        400.Bad Request.\
        500.Server Internal Error.\
        501.Not Implemented.\
        504.Time Out.\
        513.Message Too Large
    }]

    foreach element $errorCodes {
        set splitCode [split $element "."]
        set errorArray([lindex $splitCode 0],message) [lindex $splitCode 1] 
    }
    
return [array get errorArray]
}

# ------------------------------------------------------------------------------
# ProcName : initAudioFormats
# Args     : None
# Usage    : Used to generate full list of SAPI supported audio formats
# Accepts  : None
# Returns  : $audioFormats (list)
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
# Args     : $message to be output $logfile to be used for output
# Usage    : If verbose output is on this function will output debug info to
#            stdout or logfile
# Accepts  :
# Returns  :
# Called By: Any debug statement
#-------------------------------------------------------------------------------
proc bugMe {message} {

 global verboseText

    if {$verboseText} { puts stderr "Server : $message" }

}
#-------------------------------------------------------------------------------
# ProcName : getVolume
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc getVol {voice} {
   
   return [$voice Volume]    
}
#-------------------------------------------------------------------------------
# ProcName : setVolume
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc setVol {voice volume} {

   $voice Volume $volume    
}
#-------------------------------------------------------------------------------
# ProcName : getRate
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc getRate {voice} {

   return [$voice Rate] 

}
##------------------------------------------------------------------------------
# ProcName : setRate
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc setRate {voice rate} {

   $voice Rate $rate

}
#-------------------------------------------------------------------------------
# ProcName : getEngineArray
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc getEngineArray {voice} {

    if { [catch {set list [$voice GetVoices] } errmsg ]  } {
       puts stderr "No Speech Engines Available - $errmsg"
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
# ProcName : setEngine
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc setEngine {voice engine} {
 
   $voice Voice $engine
 
}
#-------------------------------------------------------------------------------
# ProcName : IdleServerTimeout
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc idleServerTimeout {} {

    set watchDog [after 60000 { 
        bugMe "Idle Timeout...Shutting Down Now. "
        file delete -force "$::env(HOME)sapiTMP/"
        exit
    }]
return $watchDog
}
#-------------------------------------------------------------------------------
# ProceName : testOutput
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc testOutput {voice flag message} {
   if { [catch { $voice Speak "Testing the SAPI speech engine & settings for\
   Rockbox Utility" $flag } errmsg ] } {
       puts "Speech initialisation failed - $errmsg"
       exit
   }  
}
#-------------------------------------------------------------------------------
# ProcName : genFiles
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc genFiles {voice filename text format} {
 
 set tmpFolder "$::env(HOME)sapiTMP"
 set tempFile "$tmpFolder/opensapitmp.wav"
 set fileStream [::tcom::ref createobject Sapi.SpFileStream]
 set audioFormat [::tcom::ref createobject Sapi.SpAudioFormat]
 
 
   if { ![file isdirectory $tmpFolder] } {
       file mkdir $tmpFolder
   }
 
   
   bugMe "tempFile = $tempFile" 
   bugMe "Genfiles : $filename : $text :$format"
    

# Set the audio format of the file stream.
 
    $audioFormat Type $format
    $fileStream Format $audioFormat

# Open the file and attach the stream to the voice.
    set SSFMCreateForWrite 3
    $fileStream Open "$tempFile" $SSFMCreateForWrite False
    $voice AudioOutputStream $fileStream

# Speak the text.
    bugMe "Synthesising : $text"
    $voice Speak $text 0
    $fileStream Close

# Rename the files from the tmp name used for creation due to a SAPI bug that
# all the files created by SAPI have to have .wav extension. 
    set fileTail [file tail $filename]
    if { [file exists $tempFile] } {
        bugMe "renaming $tempFile : $filename"
        file copy -force -- $tempFile $filename
    }
 
}
# ------------------------------------------------------------------------------
# ProcName : serverRead 
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc serverRead {sock voice} {
 
 global filename
 global timeoutID
 
 after cancel $timeoutID
 
 set textPending 0
 set runTest 0
 set skip 0
 set speechFlag 0
 set x 0
 set pitch 0
 set text ""
 set wavFormat 22
 set i 0
 set textPending 0
 set wineDir ""
 set basicFeedback 0
 set extendedFeedback 0
 
 
    if { [gets $sock message] == -1 || [eof $sock] } {
        if { [catch {close $sock} err ] } {
            bugMe "Connection killed by client - $err"
            return
        } else {
            bugMe "Connection killed by client"
        }        
     } else {
     bugMe "Message : $message"
     set message [split $message " "]
     
     foreach element $message {
         switch -exact -- $element {
             
             setFeedback {
	              
	              set feedbackLvl [lindex $message [expr $x + 1]]
	              bugMe "First Feeback Test : $feedbackLvl" 
	              if { $feedbackLvl == "1"} {
	                  set basicFeedback 1
	                  bugMe "basicFeedback"
	              }
	              
	              if { $feedbackLvl == "2"} {
	                  set extendedFeedback 1
	                  bugMe "extendedFeedback"
	              }
	          }
	          
	          default { }
	         
         }
         incr x  
     }
 
 set x 0 
 
     foreach element $message {
        if {$skip == 0} {
            switch -exact -- $element {
            
                readyServer {
                    bugMe "204 - Server ready"
                    puts $sock "204"
                }
                
                exitServer {
                    file delete -force "$::env(HOME)sapiTMP/"
                    bugMe "Cleaning Up & Shutdown"
                    exit
                }
	        
                setSystem {
                    set OS [lindex $message [expr $x + 1] ]
                    if { $OS != "win" } {
                        set $wineDir "Z:"
                    }
                }               
                
                getFormat {
                    bugMe "getFormat"
                    set format [lindex $message [expr $x + 1] ]
                    set audioFormats [initAudioFormats]
                    
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
                }
                
                setFormat {
                     set format [lindex $message [expr $x + 1] ]
                     set wavFormat [expr $format + 5]
                     bugMe "Format set : [lindex $audioFormats $format]"
                set skip 1
                }
                
                outFile {
                     
                     set i 1
	                  set filename [lindex $message [expr $x + $i]]
	                  incr i
	                  while {$i < [llength $message]} {
	                     set filename "$filename [lindex $message [expr $x + $i]]"
	                     incr i
	                 }
	                 set filename [encoding convertfrom utf-8 $filename]
	                 set skip $i 
	                 #[expr [lindex[split $message " "]] - 1]
	                 unset i
                    bugMe "Filename Set : $filename"
                }    
	          
	             getVol {
	                 set volume [getVol $voice]
	                 bugMe "getVol: $volume"
	             }
	             
	             setFeedback {
	                 bugMe "Feedback"
	                 set skip 1
	             }
             
                getEngine {
                    # Requires a regexpression to check for valid input here
                    set engineNum [lindex $message [expr $x + 1] ]
                    set engineList [getEngineArray $voice]
                    array set voicesArray $engineList
                    set i 0
                    set arraySize [array size voicesArray]
                    # Needed with Multi Dimentional Arrays as size counts
                    # the total entrites of the hash table 
                    set arraySize [expr $arraySize / 3]
                    set currentVoice [$voice Voice]  
                    while {$i < $arraySize} {
                        set voiceHandle $voicesArray($i,handle)
                     #  setEngine $voice $voiceHandle
                        
                        if { $extendedFeedback } {
                            bugMe "Extended Engine Feedback"
                            bugClient $i $voicesArray($i,name) $sock
                            bugMe "$i:$voicesArray($i,name):"
                        }
                        if { $basicFeedback } {
                            bugClient $i "" $sock
                        }
                        bugMe "$i - $voicesArray($i,name) and is\
                        $voicesArray($i,gender)"
                        incr i                      
                    }
                    setEngine $voice $currentVoice
                    bugMe "Got Engine List" 
                    unset i 
                }
                
                setEngine {
                    set engineNum [lindex $message [expr $x + 1] ]
                    set engineList [getEngineArray $voice]
                    array set voicesArray $engineList
                    set voiceHandle $voicesArray($engineNum,handle)
                    setEngine $voice $voiceHandle
                    bugMe "Set TTS Engine: $voicesArray($engineNum,name)"
                    set skip 1
                }
                
                getRate {
                    set rate [getRate $voice]
                    bugMe "getRate : $rate"
                }
                
	             speakMe {
	                 set textPending 1
	                 set i 1
	                 set text [lindex $message [expr $x + $i]]
	                 incr i
	                 while {$i < [llength $message]} {
	                    set text "$text [lindex $message [expr $x + $i]]"
	                    incr i
	                }
	                
	                set text [encoding convertfrom utf-8 $text]
	                set text [string trim $text "-"]
	                
	                set skip $i
	                unset i
                   bugMe "SpeakMe : $text"
	                
	              }
	             
	             speechFlag {
	                 set speechFlag [lindex $message [expr $x + 1] ]
	                 bugMe "speechFlags : $speechFlag"
	                 set skip 1
	             }

                testMe {
                    set runTest 1
                    set text [lindex $message [expr $x + $i]]
                    
                    while {$i < [llength $message]} {
	                    set text "$text [lindex $message [expr $x + $i]]"
	                    incr i
	                }
	               
	                set skip $i
	                unset i
      
                   bugMe "TestMe : $text"
                }
                
                closeMe {           
                   puts $sock "eos"
                   bugMe "Connection closed to client"
                   
               }
                
                verbose {}
                
                default {
                    bugMe "Unknown Option $element - Please type -h for usage help"
                }
         	
            } ; # End switch
        } else { set skip [expr $skip - 1]} ; # End if skip
    incr x
    };# End of for
    
    if {$runTest} {
        if {$textPending} {
            puts "Error: Testing overrides text output remove --test option"
        } 
        testOutput $voice $speechFlag $text
        
     } else {
         if {$textPending} {
             genFiles $voice $filename $text $wavFormat
         }
     }
     }; # end of socket if
 set timeoutID [idleServerTimeout] 
}
# ------------------------------------------------------------------------------
# ProcName : serverAccept 
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc serverAccept {sock addr port} {
global voice

 bugMe "New Client On: $sock"
 fconfigure $sock -buffering line -blocking 0 -encoding utf-8
 fileevent $sock readable [list serverRead $sock $voice]
 
}
# ------------------------------------------------------------------------------
# ProcName : sapiServer 
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc serverInit {port voice} {
    set sock [socket -server serverAccept $port]
    bugMe "Waiting for connections on port:$port"
}
#-------------------------------------------------------------------------------
# ProcName : main
# Args     :
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
 
 set port 5491
  
  # Loop through the argument supplied on the commandline checking for valid
  # switches 
    foreach element $argv {
        if { $element == "-v" || $element == "verbose" } {
            set verboseText 1
            bugMe "Verbose Output"
        } 
    }
 
    bugMe "Server Starting Up..."
   
#Generate the voice object reference for COM object
 set voice [::tcom::ref createobject Sapi.SpVoice]
    
  # Start the Idle Shutdown Timer in the event the client is not able to know
  # when it should signal the server to shutdown
    set timeoutID [idleServerTimeout]
    bugMe  "Idle Shutdown Timer Enabled"
    
    initErrorCodes
    
    if { [catch {set sock [serverInit $port $voice] } msg ]} { 
        bugMe "server error: $msg"
        exit
    }
    
    vwait forever 
 
 
