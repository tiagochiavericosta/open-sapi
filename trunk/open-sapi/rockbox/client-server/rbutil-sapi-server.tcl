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
# ------------------------------------------------------------------------------
# ProcName : initDebugLvls
# Args     : None
# Usage    : Generates an array each procedure and their log levels from 0 - 5
#          : 0 None - 5 Everything (Not recommended)
# Accepts  : None
# Returns  : $audioFormats (list)
# Called By: sysHealthCheck at startup
#-------------------------------------------------------------------------------
proc initDebugLvls {} {
   bugMe "proc initDebugLvls\{\}"
   foreach {procName logLvl} {\
       initDebugLvls          0
       helpMe                 0
       bugClient              0
       initErrorCodes         0
       initAudioFormats       0
       bugMe                  0
       errorControl           0
       extCmdExeErrWrapper    0
       getVolume              0
       setVolume              0
       getRate                0
       setRate                0
       getEngineArray         0
       setEngine              0
       testAudioFormat        0
       IdleServerTimeout      0
       testOutput             0
       genSpeech              0
       genFiles               0
       cleanUp                0
       serverRead             0
       serverAccept           0
       serverInit             0
       speechThreadInit       0
       sysHealthCheck         0
       sysHealthCheck         0}\
       {set procDebugLvlsArray($procName) $logLvl}      
   }
}
# ------------------------------------------------------------------------------
# ProcName : helpMe
# Usage    : Supplies the user with usage information when called through stdout
# Accepts  : None
# Returns  : None
# Called By: Main
#-------------------------------------------------------------------------------
proc helpMe {} {
   bugMe "proc helpMe\{\}"
   puts "Open SAPI Clip Generator Server v0.1 Alpha for Rockbox Utulity\n"

   puts "Usage: opensapi-srv.exe...\[swithches\] -vh " 
   puts "Server component of the text to speech file generation tool for use\
   with MS SAPI"
   
   puts "Switches:"
   puts "\t --debug                : Provides full debug/error infromation"
   puts "\t --port <value>         : Sets Port Number to use for communicatoin"
   puts "\t --timeout <mins>       : Sets period before the server auto closes"
   puts "\t -v, --verbose          : Verbose output"
   puts "\t --version              : Outputs the current Server version"
   puts "\t -h, --help             : This message\n"
   
   puts "For updates, guides and help see http://www.rockbox.org"
   puts "For bugs, comments and support please contact thomaslloyd@yahoo.com."  
}
# ------------------------------------------------------------------------------
# ProcName : bugClient
# Usage    : Called whenever an event needs to pass feedback to the client
# Accepts  : errorCode - calls on the errorArray to supply the description
#          : message - extra information to be passed with feedback
#          : sock - socket to pass the information to
# Returns  : None
# Called By: All functions that provide feedback to the client
#-------------------------------------------------------------------------------
proc bugClient { errorCode message sock } {
global errorArray
    bugMe "proc bugClient \{$errorCode $message $sock\}"
    puts $sock "$errorCode:$errorArray($errorCode,message):$message"
}
# ------------------------------------------------------------------------------
# ProcName : initErrorCodes
# Usage    : Generates a full list of system status codes into a global araay
# Accepts  : None
# Returns  : None
# Called By: sysHealthCheck at startup
#-------------------------------------------------------------------------------

proc initErrorCodes {} {
 global errorArray
    bugMe "proc initErrorCodes \{\}"
    set errorCodes [list \
        "100:Trying"\
        "101:Trying Synth"\
        "102:Trying Setting"\
        "103:Trying Test"\
        "200:OK"\
        "201:Synth OK"\
        "202:Setting OK"\
        "203:Test OK"\
        "204:Server Ready"\
        "293:End of List"\
        "294:Close Client"\
        "295:Volume"\
        "296:Rate"\
        "297:Voice List"\
        "298:Format List"\
        "299:Shutdown OK"\
        "400:Bad Request"\
        "500:Server Internal Error"\
        "501:Not Implemented"\
        "504:Time Out"\
        "513:Message Too Large"\
        "590:COM Error"\
        "591:Core Component Missing"\
        "592:Unexpected SAPI Error"\
        "593:Unsupported Wav Format"\
        "594:No Speech Engines Match That Request"\
        "595:Shutdown Failure"\
        "596:Startup Failure"\
        "597:Server Port Busy"\
        "598:MS Visual C++ DLL Load Failure"\
        "599:Unable to Initalise SAPI"\
    ]
    
    foreach element $errorCodes {
        set splitCode [split $element ":"]
        set errorArray([lindex $splitCode 0],message) [lindex $splitCode 1] 
        unset splitCode
    } 
}
# ------------------------------------------------------------------------------
# ProcName : initAudioFormats
# Args     : None
# Usage    : Generates a full list of SAPI supported audio formats
# Accepts  : None
# Returns  : $audioFormats (list)
# Called By: sysHealthCheck at startup
#-------------------------------------------------------------------------------

proc initAudioFormats {} {
    bugMe "proc initAudioFormats \{\}"

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
# Usage    : If verbose output is on this function will output debug info to
#            stdout or logfile
# Accepts  : $message to output
# Returns  : None
# Called By: Any debug statement
#-------------------------------------------------------------------------------
proc bugMe {message loglvl } {
 global verboseText
 set current [expr [info level] - 1]
 set self [info level]
 set caller toplevel
 set timestamp [clock format [clock seconds] -format "%b %d %H:%M:%S"
 
 
     catch {
         set caller [lindex [info level $current] 0]
     }
 
     if {$verboseText} {
         
     } else {
         return
     }
     
     # if {$verboseText} { puts stdout "Server:$caller:$message" }
     
     thread::send -async $::debugThread "logMe \"Server:\$caller:\$message\" "
    
}
#-------------------------------------------------------------------------------
# ProcName : errorControl
# Usage    : Called by extCmdExeErrWrapper to help handle & report errors
#          : handles timeouts, files, SAPI & network error codes
# Accepts  : caller - the proc that called the command to be watched
# Returns  : None
# Called By: extCmdExeErrWrapper on error
#-------------------------------------------------------------------------------
proc errorControl {caller} {
 bugMe "proc errorControl \{$caller\}"
 global errorArray
 global clientSock
   
   bugMe "errorControl"
   bugMe "caller:$caller"
   set errorCategory [lindex $::errorCode 0]
   switch -exact -- $errorCategory {
   
       COM {
           set errorSubject [lindex $::errorCode 1]
           switch -exact -- $errorSubject {
       
               0x80004005 {
                   bugMe "Error:COM:Missing DLL \(0x80004005\)"
                   if { $caller == "genFiles" } {
                       set missingDLL "wmspdmod.dll"
                   }
               
                   set ::errorCode [lreplace $::errorCode 2 2 \
                   "$errorArray(590,message) $errorArray(591,message) $missingDLL"]
               
                   puts $clientSock "590:$errorArray(590,message)\
                   $errorArray(591,message) - $missingDLL"
               }
               
               default {
                  bugMe "Error:COM:default"
                  if { [info exists errorArray($errorSubject,message)] } {
                      
                      # ::errorInfo is a string and we must do a find/replace command on it
                  
                      set ::errorCode [lreplace $::errorCode 2 2 \
                       "$errorArray(590,message) $errorArray($errorSubject,message)"]
                   
                      puts stdout "590:$errorArray(590,message)\
                      $errorArray($errorSubject,message)"
                  
                  } else {
                      bugMe "Error:COM:Unknown" 
                      # ::errorInfo is a string and we must do a find/replace command on it
                      # make sure we remove duplicated code, and set error messge.
                      
                       set checkClient [after 1000 { close $sock }]          
                       set ::errorCode [lreplace $::errorCode 2 2 \
                       "$errorArray(590,message) Unknown \
                       Error $errorSubject. Please report details online at:\n \
                       \thttp://code.google.com/p/open-sapi/issues/list\n \
                       Stack Trace: \n$::errorInfo"]
                       
                       puts stdout "$errorArray(590,message) Unknown \
                       Error $errorSubject. Please report details online at:\n \
                       \thttp://code.google.com/p/open-sapi/issues/list\n \
                       Stack Trace: \n$::errorInfo"
                  }
                             
               }
               
           }
       }
       
       POSIX {
           bugMe "Error:POSIX"
           set errorSubject [lindex $::errorCode 1] 
           switch -exact -- $errorSubject {
               
               EADDRINUSE {
                   puts stdout "596:$errorArray(596,message)\
                   $errorArray(597,message) [lindex $::errorCode 2]."
                   exit
               }
               
               default {
                  puts stdout "$errorArray(590,message) Unknown \
                  Error $errorSubject. Please report details online at:\n \
                  \thttp://code.google.com/p/open-sapi/issues/list\n \
                  Stack Trace: \n$::errorInfo" 
                  
               } 
                
           }   
       }
         
   }        
}
#-------------------------------------------------------------------------------
# ProcName : extCmdExeErrWrapper 
# Usage    : Called by any command that accesses an external resources will 
#          : handles timeouts and error codes returned by files, SAPI or network 
# Accepts  : args - This holds the command to be executed by eval
# Returns  : msg - expected feedback from a properly executed command
# Called By: All commands that rely on external resources
#-------------------------------------------------------------------------------
proc extCmdExeErrWrapper { args } {
bugMe "proc extCmdExeErrWrapper \{$args\}"
global stackTrace   
    
    if { [catch { eval $args } msg ] } {
        set current [expr [info level] - 1]
        set self [info level]
        set caller toplevel
        catch {
            set caller [lindex [info level $current] 0]
        }
        
        # errorControl is called here to populate the SAPI error message for TCL
        errorControl $caller
        
        bugMe "Error in proc $caller" 1
        bugMe "Executed through Error Wrapper extCmdExeErrWrapper" 1
        if {$stackTrace} {
            bugMe "$::errorCode" 1
            bugMe "$::errorInfo" 1
        } else {
            bugMe "Please run server with --debug option for more information" 1
        }
    exit    
    } else {
        return $msg
    }
}
#-------------------------------------------------------------------------------
# ProcName : getVolume
# Usage    : Called when the client wants to know the current volume
# Accepts  : voice - tcom reference to the SAPI com object for this client
# Returns  : volume (0 - 100 int)
# Called By: serverRead
#-------------------------------------------------------------------------------
proc getVol {voice} {
   bugMe "proc getVol \{$voice\}"
   return [extCmdExeErrWrapper $voice Volume]   
}
#-------------------------------------------------------------------------------
# ProcName : setVolume
# Usage    : This command is not longer used due to XML Markup
# Accepts  : voice - tcom ref to SAPI voice object
#          : volume - the volume that is required 
# Returns  : None
# Called By: None
#-------------------------------------------------------------------------------
proc setVol {voice volume} {
   bugMe "proc setVol\{$voice $volume\}"
   extCmdExeErrWrapper $voice Volume $volume   
}
#-------------------------------------------------------------------------------
# ProcName : getRate
# Usage    : This command is not longer used due to XML Markup
# Accepts  : voice - tcom ref to SAPI voice object
# Returns  : rate - the current rate 
# Called By: None
#-------------------------------------------------------------------------------
proc getRate {voice} {
   bugMe "proc getRate \{$voice\}"
   return [extCmdExeErrWrapper $voice Rate] 
}
##------------------------------------------------------------------------------
# ProcName : setRate
# Usage    : This command is no longer used due to XML Makrkup
# Accepts  : voice - tcom ref to SAPI voice object
#          : rate - the required rate
# Returns  : None
# Called By: None
#-------------------------------------------------------------------------------
proc setRate {voice rate} {
    bugMe "proc setRate \{$voice $rate\}"
    extCmdExeErrWrapper $voice Rate $rate

}
#-------------------------------------------------------------------------------
# ProcName : getEngineArray
# Usage    : Queries SAPI for the list of currently installed voices
# Accepts  : voice - tcom ref to SAPI voice object
# Returns  : engineArray (name, gender and SAPI ref by number index)
# Called By: serverRead
#-------------------------------------------------------------------------------
proc getEngineArray {voice} {
    bugMe "proc getEngineArray \{$voice\}"
    set list [extCmdExeErrWrapper $voice GetVoices]
    if { [llength list] == 0 } {
        puts stderr "No Speech Engines Available"
        return
    }
    set howmany [$list Count]
    for {set i 0} {$i < $howmany} {incr i} {
        set engine [$list Item $i]
       # set engineArray($i,name) [extCmdExeErrWrapper $engine GetDescription]
        set engineArray($i,name) [extCmdExeErrWrapper $engine GetAttribute \
        Name]
        set engineArray($i,gender) [extCmdExeErrWrapper $engine GetAttribute \
        Gender]
        set engineArray($i,lang) [extCmdExeErrWrapper $engine GetAttribute \
        Language]
        set engineArray($i,vendor) [extCmdExeErrWrapper $engine GetAttribute \
        Vendor]
        set engineArray($i,age) [extCmdExeErrWrapper $engine GetAttribute \
        Age]
        set engineArray($i,handle) $engine
    } 
return [array get engineArray]
}
#-------------------------------------------------------------------------------
# ProcName : setEngine
# Usage    : Sets the current voice for the SAPI reference
# Accepts  : voice - tcom ref to SAPI voice object
#          : engine - SAPI reference to the specified voice 
# Returns  : None
# Called By: serverRead
#-------------------------------------------------------------------------------
proc setEngine {voice engine} {
    bugMe "proc setEngine \{$voice $engine\}"
    extCmdExeErrWrapper $voice Voice $engine 
}
#-------------------------------------------------------------------------------
# ProcName : testAudioFormat
# Usage    : Test each format SAPI supports to make sure the OS also supports it
# Accepts  : voice - tcom ref to SAPI voice object
# Returns  : supportedFormats (list)
# Called By: sysHealthCheck at startup
#-------------------------------------------------------------------------------
proc testAudioFormat {voice} {
 bugMe "testAudioFormat"
 bugMe "voice:$voice"
 global stackTrace
 global supportedFormats
 global tmpFolder
 
 set SSFMCreateForWrite 3
 set audioFormats [initAudioFormats]
 set testStream [::tcom::ref createobject Sapi.SpFileStream]
 set testFormat [::tcom::ref createobject Sapi.SpAudioFormat]
 set testStreamFormat [$testStream Format]
 set i -1
 set tempFile "$tmpFolder/opensapitmp.wav"  
                  
    foreach element $audioFormats {
        if { $i > 5} {
            $testFormat Type $i
            extCmdExeErrWrapper $testStream Format $testFormat
            $testStream Open $tempFile $SSFMCreateForWrite False 
            
            $voice AudioOutputStream $testStream
                                
            if { [catch { $voice Speak " " 0 } err] } {
                 if {$stackTrace} {
                    bugMe "[expr $i-5] - Unsupported : $element :$err" 5
                 }
            } else {
                if {$stackTrace} {
                    bugMe "[expr $i-5] - Passed      : $element" 5
                }
                set supportedFormats([expr $i-5],format) $element
            }
        $testStream Close
        }
    incr i
    }
    unset testFormat testStream testStreamFormat i
    return [array get supportedFormats]  
}
#-------------------------------------------------------------------------------
# ProcName : IdleServerTimeout
# Usage    : This is a global timeout that if the client for any reason does not
#          : close the server this function will.
# Accepts  : None
# Returns  : None
# Called By: main on startup
#-------------------------------------------------------------------------------
proc idleServerTimeout { timeout} {
    bugMe "idleServerTimeout"
    bugMe "timeout"
    set watchDog [after $timeout { 
        bugMe "Idle Timeout...Shutting Down Now" 0
        closeMe idleServerTimeout
    }]
return $watchDog
}
#-------------------------------------------------------------------------------
# ProcName : testOutput
# Usage    : Not currently implemented
# Accepts  : voice - tcom ref to SAPI voice object 
#          : flag - speechFlag for sapi changes output behaviour
#          : message - test message - not implemented
# Returns  : None
# Called By: None
#-------------------------------------------------------------------------------
proc testOutput {voice flag message} {
    bugMe "testOutput"
    bugMe "voice:$voice\nflag:$flag\nmessage:$message"
    if { [catch { $voice Speak "Testing the SAPI speech engine & settings for\
    Rockbox Utility" $flag } errmsg ] } {
        puts "Speech initialisation failed - $errmsg"
        exit
   }  
}
#-------------------------------------------------------------------------------
# ProcName : genSpeech
# Usage    : Outputs speech using the speech thread straight to the sound server
# Accepts  : voice - tcom ref to SAPI voice object 
#          : flag - speechFlag for sapi changes output behaviour
#          : message - test message - not implemented
# Returns  : None
# Called By: None
#-------------------------------------------------------------------------------
proc genSpeech {voice text} {
    bugMe "genSpeech"
    bugMe "voice:$voice\ntext:$text"
    extCmdExeErrWrapper thread::send -async $::speechThread \
    "\$voice Speak \"$text\" 1"
}
#-------------------------------------------------------------------------------
# ProcName : genFiles
# Usage    : Outputs test to file in the specified format
# Accepts  : voice - tcom ref to SAPI voice object 
#          : filename - the location and filename for output
#          : text - The text to be synthesised
#          : format - the wav format see initAudioFormats
# Returns  : None
# Called By: serverRead
#-------------------------------------------------------------------------------
proc genFiles {voice filename text format} {
 bugMe "genfiles"
 bugMe "voice:$voice\nfilename:$filename\ntext:$text\nformat:$format"
 global tmpFolder
 
 set tempFile "$tmpFolder/opensapitmp.wav"
 set fileStream [extCmdExeErrWrapper ::tcom::ref createobject Sapi.SpFileStream]
 set audioFormat [extCmdExeErrWrapper ::tcom::ref createobject Sapi.SpAudioFormat]
 
# If the tmp direcotry does not currently exist we create it for this session    
   if { ![file isdirectory $tmpFolder] } {
       extCmdExeErrWrapper file mkdir $tmpFolder
   }
    
# Set the audio format of the file stream.
    extCmdExeErrWrapper $audioFormat Type $format
    extCmdExeErrWrapper $fileStream Format $audioFormat

# Open the file and attach the stream to the voice.
    set SSFMCreateForWrite 3
    extCmdExeErrWrapper $fileStream Open "$tempFile" $SSFMCreateForWrite False
    extCmdExeErrWrapper $voice AudioOutputStream $fileStream

# Speak the text.
    bugMe "Synthesising : $text" 3
    extCmdExeErrWrapper $voice Speak $text 0
#   extCmdExeErrWrapper thread::send -async $::speechThread "\$voice Speak \"$text\" 1" 

 return $fileStream
}
# ------------------------------------------------------------------------------
# ProcName : cleanUp 
# Usage    : Copy File and Close the Filestream, a simple rename could be 
#          :faster? Just foce a .wav extention on the file wanted.
# Accepts  : sock - client socket reference
#          : voice - tcom ref to SAPI voice object
# Returns  : None
# Called By: serverAccept
#-------------------------------------------------------------------------------
proc cleanUp {filename fileStream} {
    bugMe "cleanUp"
    bugMe "filename:$filename\nfileStream:$filestream"
global tmpFolder

set tempFile "$tmpFolder/opensapitmp.wav"

# Close the fileStream    
 #  extCmdExeErrWrapper $fileStream Close
    
# Rename the files from the tmp name used for creation due to a SAPI bug that
# all the files created by SAPI have to have .wav extension. 
    set fileTail [file tail $filename]
    if {$filename != "Startup Test"} {
      
        if { [file exists $tempFile] } {
            file copy -force -- $tempFile $filename
        }
    }
}
# ------------------------------------------------------------------------------
# ProcName : serverRead 
# Usage    : Automatically called on data being received from new or existing
#          : clients
# Accepts  : sock - client socket reference
#          : voice - tcom ref to SAPI voice object
# Returns  : None
# Called By: serverAccept
#-------------------------------------------------------------------------------
proc serverRead {sock voice} {
 
 global filename
 global timeoutID
 global wavFormat
 global stackTrace
 global supportedFormats
 global errorArray
 global pitch
 global langArray
     bugMe "serverRead"
     bugMe "sock:$sock\nvoice:$voice"
 
 
# Cancel the global server timeout as there has been a new request from a client
# indicating the server is still needed. 
     after cancel $timeoutID
 
 set textPending 0
 set runTest 0
 set skip 0
 set speechFlag 0
 set x 0
 
 set text ""
 set i 0
 set textPending 0
 set basicFeedback 0
 set extendedFeedback 0
 
 
    if { [gets $sock message] == -1 || [eof $sock] } {
        extCmdExeErrWrapper thread::send -async $::speechThread "\$voice Speak \" \" 3"
        if { [catch {close $sock} err ] } {
            bugMe "Connection killed by client - $err" 3
            
            return
        } else {
            bugMe "Connection killed by client" 3
            return
        }
                
    } else {
    bugMe "Message : $message"
    set message [split $message " "]
 
    foreach element $message {
        if {$skip == 0} {
            switch -exact -- $element {
             
                readyServer {
                    bugMe "ReadyServer from $sock" 5
                    bugMe "204:$errorArray(204,message)" 4
                    bugClient 204 "" $sock
                    return
                }
                
                closeClient {
                    bugMe "CloseClient from $sock" 5
                    bugMe "294::$errorArray(294,message)" 4
                    bugClient 294 "" $sock
                    return
                }
                
                killServer {
                    bugMe "killServer from $sock" 5
                    closeMe client $sock
                }
	                          
                getFormat {
                    bugMe "getFormat from $sock" 5
                    set formatList [array get supportedFormats *]
                    foreach {ID formatDesc} $formatList {
                        set ID [split $ID ","]
                        set ID [lindex $ID 0]
                        lappend tempFormatList "$ID $formatDesc"
                    }
                    set formatList $tempFormatList
                    set formatList [lsort -dictionary $formatList]
                   
                    foreach {ID} $formatList {
                        set tmpID [split $ID " "]
                        set ID [lindex $tmpID 0]
                        set format [lindex $tmpID 1]
                        bugMe "298:$errorArray(298,message):$ID:$format" 4
                        bugClient 298 "$ID:$format" $sock
                    }
                    bugClient 293 "" $sock
                }
                
                setFormat {
                    bugMe "setFormat from $sock" 5
                    set formatID [lindex $message [expr $x + 1] ]
                    if { [catch {info exists \
                    $supportedFormats($formatID,format)}] } {
                        bugMe "593:$errorArray(593,message) - $formatID"
                        bugClient 593 "$formatID" $sock
                    } else {
                        set audioFormats [initAudioFormats]
                        bugMe "202:$errorArray(202,message)\
                        - $supportedFormats($formatID,format)"
                        bugClient 202 "setFormat" $sock
                    }
                    set skip 1
                }
                
                outFile {
                    bugMe "outFile cmd from client:$sock"
                    set i 1
	                set filename [lindex $message [expr $x + $i]]
	                bugMe "filename set: $filename" 5
	                incr i
	                while {$i < [llength $message]} {
	                   set filename "$filename [lindex $message [expr $x + $i]]"
	                   incr i
	                }
	                set filename [encoding convertfrom utf-8 $filename]
	                set skip $i
	                unset i
                    bugMe "202:$errorArray(202,message):Filename Set - $filename"
                    # Could improve this to check the filename
                    bugClient 202 "outFile" $sock
                }    
	          
	             getVol {
	                 bugMe "getVol cmd from client:$sock"
	                 set volume [getVol $voice]
	                 bugMe "getVol:$volume"
	                 bugClient 295 "$volume" $sock
	             }
	             
	             setVol {
	                bugMe "setVol cmd from client:$sock"
	                set vol [lindex $message [expr $x + 1] ]
	                if {$vol != ""} {
	                    setVol $voice $vol
	                    bugClient 202 "setVol" $sock
	                    set skip 1 
	                } else {
	                }    
	             }
	             
	             setRate {
	                 bugMe "setRate cmd from client:$sock"
	                 set rate [lindex $message [expr $x + 1] ]
	                 bugMe "Rate = $rate" 
	                 setRate $voice $rate
	                 bugClient 202 "setRate" $sock
	                 set skip 1
	             }
	             
	             setPitch {
	                 set pitch [lindex $message [expr $x + 1] ]
	                 bugMe "setPitch cmd from client:$sock"
	                 bugMe "Pitch = $pitch"
	                 bugClient 202 "setPitch" $sock
	                 set skip 1
	             }
	             
	             setFeedback {
	                 bugMe "Feedback cmd from client:$sock"
	                 set skip 1
	             }
             
                getEngine {
                    # Requires a regexpression to check for valid input here
                    # set engineNum [lindex $message [expr $x + 1] ]
                    bugMe "getEngine  cmd from client:$sock"
                    set engineList [getEngineArray $voice]
                    array set voicesArray $engineList
                    set i 0
                    set arraySize [array size voicesArray]
                    # Needed with Multi Dimentional Arrays as size counts
                    # the total entrites of the hash table 
                    set arraySize [expr $arraySize / 6]
                    set currentVoice [$voice Voice]  
                    while {$i < $arraySize} {
                        set voiceHandle $voice 
                        # tempLangListesArray($i,handle)
                        set tempLangList [split $voicesArray($i,lang) ";"]
                        set voicesArray($i,lang) [lindex $tempLangList 0]
                        set voicesArray($i,lang) $langArray($voicesArray($i,lang))
                        bugClient 297 "$i:$voicesArray($i,name):$voicesArray($i,gender):$voicesArray($i,lang):$voicesArray($i,vendor):$voicesArray($i,age)" $sock
                        bugMe "297:$errorArray(297,message)$i -\
                        $voicesArray($i,name) and is $voicesArray($i,gender) $voicesArray($i,age)"
                        incr i                      
                    }
                    bugClient 293 "" $sock
                    bugMe "293:$errorArray(293,message)
                    unset i 
                }
                
                setEngine {
                    set engineNum [lindex $message [expr $x + 1] ]
                    bugMe "getEngine from $sock"
                    bugMe "engineNum  = $engineNum"
                    set engineList [getEngineArray $voice]
                    set engineCount [expr [llength engineList] / 3]
                    array set voicesArray $engineList
                    set arraySize [expr [array size voicesArray] / 6 - 1]
                    if { $engineNum > $arraySize} {
                        bugMe "594:$errorArray(594,message) - $engineNum"
                        bugClient 594 "$engineNum" $sock
                        return
                    }
                    set voiceHandle $voicesArray($engineNum,handle)
                    setEngine $voice $voiceHandle
                    bugMe "TTS Engine = $voicesArray($engineNum,name)"
                    bugClient 202 "setEngine:$voicesArray($engineNum,name)" $sock
                    set skip 1
                }
                
                getRate {
                    set rate [getRate $voice]
                    bugMe "getRate from $sock
                    bugMe "Rate       = $rate"
                    bugClient 296 "$rate" $sock
                }
                
	             speakMe {
	                  bugMe
	                  set textPending 1
	                  set i 1
	                  set text [lindex $message [expr $x + $i]]
	                  incr i
	                  while {$i < [llength $message]} {
	                     set text "$text [lindex $message [expr $x + $i]]"
	                     incr i
	                 }
	                # This needs to be converted from always using utf-8 to system encoding
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
                
                setDebug {
                    set stackTrace 1
                    bugClient 202 "setDebug" $sock
                }
                
                verbose {}
                
                default {
                    bugMe "Unknown Option $element - Please type -h for usage help"
                    bugClient 501 "Server does not support command $element" $sock 
                }
         	
            } ; # End switch
        } else { set skip [expr $skip - 1]} ; # End if skip
    incr x
    };# End of for
    
    if {$pitch} {
        set text "<pitch absmiddle=\"$pitch\"/> $text"
    }
    
    if {$runTest} {
        if {$textPending} {
            puts "Error: Testing overrides text output remove --test option"
        } 
        testOutput $voice $speechFlag $text
        bugClient 203 "" $sock
        
     } else {
         if {$textPending} {
             thread::send -async $::speechThread "vwait voiceEvent" speechMonitor
             if { $pitch } {
                 set $text "<pitch absmiddle=\"$pitch\"/> $text"
             }
             if {$filename} {
                 set fileStream [genFiles $voice $filename $text $wavFormat]
                 cleanUp $filename $fileStream
             } else {
                 genSpeech $voice $text
                 vwait speechMonitor
             }
             
             bugClient 201 "" $sock
             bugClient 294 "" $sock
         } else {
         #    bugClient 294 "" $sock
         }
     }
 }; # end of socket if
 if { $::timeout } {
     set timeoutID [idleServerTimeout $::timeout]
  }
}
# ------------------------------------------------------------------------------
# ProcName : serverAccept 
# Usage    : This function s called on each new client connecting to the server
# Accepts  : sock - client socket reference
#          : addr - client connected on address
#          : port - port the client is connected on
# Returns  : None
# Called By: sapiServer
#-------------------------------------------------------------------------------
proc serverAccept {sock addr port} {
 global voice
 global clientSock
    
    bugMe "serverAccept"
    bugMe "sock:$sock\naddr:$addr\nport:$port"
    bugMe "New Client On: $sock"
    fconfigure $sock -buffering line -blocking 0 -encoding utf-8
    set clientSock $sock
    fileevent $sock readable [list serverRead $sock $voice]    
}
# ------------------------------------------------------------------------------
# ProcName : sapiServer 
# Usage    : Start the listening server waiting for clients
# Accepts  : port - the port to listen for connections onh
# Returns  : None
# Called By: main on startup
#-------------------------------------------------------------------------------
proc serverInit {port} {
    bugMe "serverInit"
    bugMe "port:$port"
    set sock [extCmdExeErrWrapper socket -server serverAccept $port]
    
}
# ------------------------------------------------------------------------------
# ProcName : closeMe 
# Usage    : This command is called before the server closes
# Accepts  : caller - the proc that has called the close command
#          : args - extra message information to pass back to client
# Returns  : None
# Called By: idleServerTimeout & serverRead
#-------------------------------------------------------------------------------
proc closeMe {caller args } {
  global tmpFolder
  bugMe "closeMe"
  bugMe "caller:$caller\nargs:$args"
  
    if {$caller == "client"} {
        # Notify Client
        bugClient 299 "" $args
    }
    if { [file isdirectory "$tmpFolder"] } {
        if { [catch {file delete -force "$tmpFolder"} msg ]} {
            bugMe "Cleaning Up..........FAILED"
            puts stdout "$::errorInfo"
            exit 1
        } else {
            bugMe "Cleaning Up..............OK"
            exit 0
        }
    }
 exit 0
}
#-------------------------------------------------------------------------------
# ProcName : speechThreadInit
# Usage    : Init SAPI worker thread, all functionality required can be define
# Accepts  : None
# Returns  : None
# Called By: 
#-------------------------------------------------------------------------------
proc speechThreadInit { } {
 package require Thread
 global speechMonitor
 
 bugMe "speechThreadInit"
 
 set speechThreadInit {
 package require tcom
    
    ::tcom::configure -concurrency multithreaded
    set voice [::tcom::ref createobject Sapi.SpVoice]  
       #------------------------------------------------------------------------
       proc setSoundDevice {voice device} {
           $voice AudioOutput $device
       }
       #------------------------------------------------------------------------       
       proc getSoundDeviceArray {voice} {
           #set devices [$voice GetAudioOutputs]
           if { [catch {set devices [$voice GetAudioOutputs] } errmsg] } {
               puts "Only One Sound Device Available - $errmsg"
               return
           }
           set howmany [$devices Count]
           for {set i 0} {$i < $howmany} {incr i} {
               set thisdevice [$devices Item $i]
               set deviceArray($i,name) [$thisdevice GetDescription]
               set deviceArray($i,handle) $thisdevice
           }
       return [array get deviceArray] 
       }
       #------------------------------------------------------------------------       
       proc setEngine {voice engine} {
           $voice Voice $engine
       }
       #------------------------------------------------------------------------
       proc setRate {voice rate} {
           $voice Rate $rate
           puts [$voice Rate]
       }
       #------------------------------------------------------------------------
       proc setVol {voice volume} {
           $voice Volume $volume    
       }
       #------------------------------------------------------------------------
       proc watchVoiceEvent {event args} {
           global voice
           global voiceEvent
           if {$event == "EndStream" && [$voice WaitUntilDone 500] } {
               puts "Speech Output ended : close clientSock"
               set voiceEvent 1
           }
           
       }
       #------------------------------------------------------------------------
       ::tcom::bind $voice watchVoiceEvent
       $voice EventInterests 4
       thread::wait
   }; # End of speechThreadInit
      
   set speechThread [thread::create $speechThreadInit]
   # Sets up event monitoring on the thread notifying when speech is finished
return $speechThread
}
#-------------------------------------------------------------------------------
# ProcName : debugThreadInit
# Usage    : Init debug worker thread, all functionality defined here
# Accepts  : None
# Returns  : None
# Called By: 
#-------------------------------------------------------------------------------
proc debugThreadInit { } {
package require Thread
    bugMe 
    switch -exact -- $loglvl {
         
        0 {return}
        1 {}
        2 {}
        3 {}
        4 {}
        5 {}
    }
}
# ------------------------------------------------------------------------------
# ProcName : sysHealthCheck 
# Usage    : Tests the all components are present and working before startup,
#          : performs a test synthesis on the default speech engine and opens 
#          : ports for clients to connect.
# Accepts  : port - The port the server should listen for new connections
# Returns  : None
# Called By: main on startup
#-------------------------------------------------------------------------------
proc sysHealthCheck { port } {
 global voice
 global errorArray
 global stackTrace
 global langArray
 global filename

# sets up the debugging error code array        
    initErrorCodes
    
# Set the local directory in startkit VFS 
    set dir "[file dirname [info script]]"

# Try to load external files in Startkit    
    set errorList [source [file join $dir sapi_error_array.init]]
    array set errorArray $errorList
    bugMe  "Error System............OK"
    
    set langList [source [file join $dir lang_codes.init]]
    array set langArray $langList
    bugMe  "Language System.........OK"

# If not in Startkit try to load files in Development Mode   
    if { [info exists $errorList] && [info exists $langList] } {
    # Loads both internal and external error code references
        
        set errorList [extCmdExeErrWrapper source \
        $::env(HOME)/open-sapi/rockbox/client-server/lib/sapi_error_array.init]
        array set errorArray $errorList
        bugMe  "Error System............OK"
    
        # Loads the MS Language ID reference file
        set langList [extCmdExeErrWrapper source \
        $::env(HOME)/open-sapi/rockbox/client-server/lib/lang_codes.init]
        array set langArray $langList
        bugMe  "Language System.........OK"
    }
    

# Attempt to start the listening server on the given port
    extCmdExeErrWrapper serverInit $port
    bugMe "Server Listening:$port...OK"
    
# Checks that the TCOM Package and components is available and starts the debug\
  thread ready for work
         
    if { [catch { package require Thread } msg ] } {
        puts "stdout "590:$errorArray(590,message).\
        $errorArray(598,message) - Thread package"
        if {$stackTrace} { extCmdExeErrWrapper package missing Thread }
        exit
    }
    
    if ( [catch {set ::debugThread [thread::create $debugThreadInit]}msg ] } {
        puts "stdout "590:$errorArray(590,message).\
        $errorArray(598,message) - Unable to start Threads, you must use wine\
        version 1.1.32 or greater"
    }
    
    bugMe "Debug Thread Initalised.OK"

# Checks that the TCOM Package and components is available and generates \
    the SAPI voice COM object.       
    if { [catch { package require tcom } msg ] } {
        puts stdout "590:$errorArray(590,message).\
                   $errorArray(598,message) - msvcp60.dll"
        if {$stackTrace} { extCmdExeErrWrapper package require tcom }
        exit
    }
    
    bugMe "TCOM Initalised.........OK"
        
    set voice [extCmdExeErrWrapper ::tcom::ref createobject Sapi.SpVoice] 
    bugMe "SAPI Initalised.........OK"
        
# Only run the format check if we are outputting to the filesystem
    if {$filename} {
        array set supportedFormats [testAudioFormat $voice]
        bugMe "Output Format Check.....OK"
        bugMe "File Generation.........OK"
    }
        
# Starts a new thread to deal with synthesis requests. Only needed for direct\
  synthesis.
  
    if {!$filename} {
       set ::speechThread [extCmdExeErrWrapper speechThreadInit]
       bugMe "Speech Thread Init......OK"
    }
    
    bugMe "Waiting for Clients.....OK"

# return $speechThread
}
#-------------------------------------------------------------------------------
# ProcName : main
# Usage    : This is the main loop the script begins executing here
# Accepts  : None
# Returns  : None
# Called By: None
#-------------------------------------------------------------------------------
 
 set verboseText 0
 set port 5491
 set wavFormat 22
 set stackTrace 0
 set pitch 0
 set skip 0
 set x 0
 set filename 0
 set tmpFolder "$::env(HOME)sapiTMP"
 set speechMonitor 0
 set timeout 60000
 set checkClient 0
 set timeoutID 0
 
    # Loop through the argument supplied on the commandline checking for valid
    # switches 
    foreach element $argv {
        if {$skip == 0} {
            switch -exact -- $element {
            
                -h {
                    helpMe
                    closeMe main
                }
                
                --help {
                    helpMe
                    closeMe main
                }
                
                --tmp {
                    set folder [lindex $argv [expr $x + 1] ]
                    if { [file isdirectory $folder] } {
                        set tmpFolder
                    }
                    set skip 1
                }
                
                --timeout {
                    set timeout [lindex $argv [expr $x + 1] ]
                    set timeout [expr $timeout * 1000 * 60]
                    set skip 1
                }
        
                -v {
                   set verboseText 1
                   bugMe "Verbose Output" 1
                }
            
                --verbose {
                    set verboseText 1
                    bugMe "Verbose Output" 1
                }
            
                --debug {
                    set verboseText 1
                    set stackTrace 1
                    bugMe "Debug Mode" 1
                }
            
                --port {
                    set port [lindex $argv [expr $x + 1] ]
                    set skip 1
                }    
                
                --version {
                    puts "Version 0.1 Alpha"
                    exit 0 
                }
            
                default {
                    puts "Unknown option $element try -h for more help or visit\
                     the open-sapi website for more details"
                }
        
            }; # End of switch
        } else { set skip [expr $skip - 1]}; # End of Skip
    incr x
    }; # End of foreach
    
    bugMe "System Health Check:"
    
    # Start the Idle Shutdown Timer in the event the client is not able to
    # signal the server to shutdown or the server crashes. 
    if {$timeout} {
        set timeoutID [idleServerTimeout $timeout]
    }
    
    bugMe "Idle Shutdown Timer.....OK"
    
    if { $filename && ![file isdirectory $tmpFolder] } {
        extCmdExeErrWrapper file mkdir $tmpFolder
    }
    
    # Tests essential external resources are present and functioning.   
    sysHealthCheck $port    
   
    # Forces the script to wait for new events, normally a new client trying to 
    # connect.  
    vwait forever 
     

 
 
