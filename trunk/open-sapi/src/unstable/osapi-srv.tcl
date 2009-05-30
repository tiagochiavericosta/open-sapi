# ------------------------------------------------------------------------------
#Application Hame: Open SAPI Sever
# ------------------------------------------------------------------------------
lappend ::auto_path ./

# Needed by freewrao to unpackage required files before calling them, called
# with catch so  when not using freewrap the system still loads correctly as 
#zvfs is freewrap specific.
  
# catch [ lappend ::auto_path [file dirname [zvfs::list */pkgIndex.tcl]] ] err
# catch [ lappend ::auto_path [file dirname [zvfs::list */tcom.tcl]] ] err
# catch [ lappend ::auto_path [file dirname [zvfs::list */tcom.dll]] ] err

# tcom package required to communicate across the windows COM in Windoed to the 
# MS Speech API 

package require tcom

# Read config file
# Output config file
# Setup listening server
# Process control


set verboseText 1
set verboseSpeech 0

# ------------------------------------------------------------------------------
# ProcName : bugMe 
# Args : $message to be output $logfile to be used for output
# Usage : If verbose output is on this function will output debug info to stdout 
# or logfile  
# Called By: Any debug statement
#-------------------------------------------------------------------------------
proc bugMe {message sock} {

global verboseText
global verboseSpeech
global voice

    if {$verboseText} { puts "$message" }
    if {$verboseSpeech} { $voice Speak "$message" 0 }

}
#-------------------------------------------------------------------------------
# Proceedure Name: getVolume
# Description: Returns the current engines volume setting.
#
# Returns:
#-------------------------------------------------------------------------------
proc getVol {voice} {
   
   return [$voice Volume]    
}
#-------------------------------------------------------------------------------
# Proceedure Name: setVolume
# Description: Sets the specified engines volume.
#
# Returns:
#-------------------------------------------------------------------------------
proc setVol {voice volume} {

   $voice Volume $volume    
}
#-------------------------------------------------------------------------------
# Proceedure Name: getRate
# Description:
#
# Returns:
#-------------------------------------------------------------------------------
proc getRate {voice} {

   return [$voice Rate] 

}
##------------------------------------------------------------------------------
# Proceedure Name: setRate
# Description:
#
# Returns:
#-------------------------------------------------------------------------------
proc setRate {voice rate} {

   $voice Rate $rate

}
#-------------------------------------------------------------------------------
# Proceedure Name: getEngineArray
# Description:
#
# Returns:
#-------------------------------------------------------------------------------
proc getEngineArray {voice} {

   #set list [$voice GetVoices]
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
   puts "set engine"
 
}
#-------------------------------------------------------------------------------
# Proceedure Name: getSoundDeviceArray
# Description: Populates the array with the sound device details
# Returns: deviceArray
#-------------------------------------------------------------------------------
proc getSoundDeviceArray {voice} {

 #set devices [$voice GetAudioOutputs]
 if { [catch {set devices [$voice GetAudioOutputs] } errmsg] } {
       puts "Only One Sound Device Available - $errmsg"
       return
    } else {
    }
 set howmany [$devices Count]
 for {set i 0} {$i < $howmany} {incr i} {
     set thisdevice [$devices Item $i]
     set deviceArray($i,name) [$thisdevice GetDescription]
     set deviceArray($i,handle) $thisdevice
 }
 return [array get deviceArray]
 
}
#-------------------------------------------------------------------------------
# Proceedure Name: setSoundDevice
# Description: Changes the audio device.
#
# Returns: Nothing
#-------------------------------------------------------------------------------
proc setSoundDevice {voice device} {
   
   $voice AudioOutput $device
   
}
# ------------------------------------------------------------------------------
# ProcName : sapiServer 
# Args :
# Usage :  
# Called By:
#-------------------------------------------------------------------------------
proc sapiServer {port} {
 global voice
 global sock
      
 set sock [socket -server sapiAccept $port]
 fconfigure $sock -buffering line -blocking 0 
 bugMe "SAPI Server Listening for connections on port:$port" $sock
 
 
 if { [catch { $voice Speak "Ready" 1 } errmsg ] } {
       puts "Speech initialisation failed - $errmsg"
       exit
    }
 
 puts "SAPI Server Ready"  
}
# ------------------------------------------------------------------------------
# ProcName : sapiAccept 
# Args :
# Usage :  
# Called By:
#-------------------------------------------------------------------------------
proc sapiAccept {sock addr port} {
global voice

 bugMe "New connection on $sock" $sock
 $voice Speak " " 3
 fileevent $sock readable [list sapiRead $sock]

}
# ------------------------------------------------------------------------------
# ProcName : sapiRead 
# Args : sock
# Usage :  
# Called By:
#-------------------------------------------------------------------------------
proc sapiRead {sock} {
 
 
 
 bugMe "sapiRead" $sock
 
 global voice
 global voicesArray
 global deviceArray
 global speechFlags
 global clientSock
 global maxint
   
 set x 0
 set skip 0
 set text ""
 set pipemode 1 
 set pitch 0
 set clientSock $sock
 
 fconfigure $clientSock -encoding utf-8
 
 
 ::tcom::bind $voice voiceEvent
 $voice EventInterests 4
 
 if { [gets $sock message] == -1 } {
     catch {close $sock} err
     bugMe "Connection closed from $sock - $err" $sock
#     $voice Skip Sentence $maxint
     $voice Speak " " 3
     return        
 } else {
     
     bugMe "Message from $sock" $sock
     
     set message [split $message " "]
     
     foreach element $message {
         if {$skip == 0} {
             switch -exact -- $element {
           
               appName {
                   set skip 1
               }
                   
               getVolume { 
                   set volume [getVol $voice] 
                   bugMe "Get volume $volume" $sock
               }
           
               setVolume {
                   set volume [lindex $message [expr $x + 1]]
                   setVol $voice $volume
                   bugMe "Set volume $volume" $sock
                   set skip 1
               }
           
               getRate {
                   set rate [getRate $voice] 
                   bugMe "Get rate $rate" $sock
               }
           
               setRate {
                   set rate [lindex $message [expr $x + 1]]
                   setRate $voice $rate
                   bugMe "Set speech rate $rate" $sock
                   set skip 1
               }
           
               getVoice {
                  set i 0
                  set arraySize [array size voicesArray]
                  # Needed with Multi Dimentional Arrays as size counts the \
                   total entrites of the hash table 
                  set arraySize [expr $arraySize / 3]
                  set currentVoice [$voice Voice]  
                  while {$i < $arraySize} {
                      set voiceHandle $voicesArray($i,handle)
                      setEngine $voice $voiceHandle
                      bugMe "Voice $i = $voicesArray($i,name) and is\
                      $voicesArray($i,gender)" $sock
                      incr i                      
                  }
                  setEngine $voice $currentVoice
               }
           
               setVoice {
                   set engineNum [lindex $message [expr $x + 1]]
                   set voiceHandle $voicesArray($engineNum,handle)
                   setEngine $voice $voiceHandle
                   bugMe "Set Voice $voicesArray($engineNum,name)" $sock
                   set skip 1
               }
           
               getDevice {
                   set i 0
                   set arraySize [array size deviceArray]
                   # Needed with Multi Dimentional Arrays as size counts the \
                   total entrites of the hash table 
                   set arraySize [expr $arraySize / 2]
                   while {$i < $arraySize} {
                       bugMe "Engine $i = $deviceArray($i,name)" $sock
                       incr i   
                   }
               }
           
               setDevice {
                   set deviceNum [lindex $message [expr $x + 1]]
                   set deviceHandle $deviceArray($deviceNum,handle)
                   setSoundDevice $voice $deviceHandle
                   bugMe "Set device $deviceArray($deviceNum,name)" $sock
                   set skip 1
               }
           
               setFlags {
                   set speechFlags [lindex $message [expr $x + 1]]
                   bugMe "Set speechFlags to $speechFlags" $sock
                   set skip 1
               }
           
               soundIcon {
                   bugMe " Sound Icon" $sock
                   set skip 1
               }
           
               say {
                   set i 1
                   set word [lindex $message [expr $x + $i]]
                   set text "$text $word"
                   incr i
                   while {$word != "@@"} {
	               set word [lindex $message [expr $x + $i]]
	               if {$word != "@@"} {set text "$text $word"}
	                   incr i
	               }
	               set skip [expr $i -1]   
                   }
                   
               saveConfig {
                   bugMe "Save Config" $sock
                   set skip 1
               }
           
               loadConfig {
                   bugMe "Save Config" $sock
                   set skip 1
               }
                   
               serverAction {
                   set action [lindex $message [expr $x + 1]]
                   if {$action == "shutdown"} { 
                       exit
                   }
                   set skip 1
               }
                   
               getPitch {
                   bugMe "Pitch = $pitch" $sock 
               }
                   
               setPitch {
                  set pitch [lindex $message [expr $x + 1]]
               #  bugMe "setPitch = $pitch" $sock 
                  set skip 1
               }
                   
               pipeMode { 
                   bugMe "PipeMode" $sock
                   set pipemode 0
               }
                   
               default { 
               bugMe "Unknown Option $element. Malformed comand line. Please \
               see manual for help" $sock
               }
           
           }; # End switch
       } else { set skip [expr $skip - 1]} ; # End if skip
   incr x    
   }; # End of foreach
 }; # End of socket else

 
 if {$text == ""} { return } else {
     if {$pitch < 0 || $pitch > 0} {
         bugMe "setting pitch on message" $sock
         set text "<pitch absmiddle=\"$pitch\"> $text </pitch><pitch \
         absmiddle=\"0\"/>"
     }
     puts "what i am speaking : $text"
     set $text [encoding convertfrom utf-8 $text]
     puts "after conversion : $text"
     $voice Speak $text $speechFlags
 }
 
}
# ------------------------------------------------------------------------------
# ProcName : voiceEvent 
# Args :
# Usage :   
# Called By:
#-------------------------------------------------------------------------------
proc voiceEvent { event args } {

global clientSock
global voice
 if {$event == "EndStream"} {
     catch { close $clientSock } err
     bugMe "Voice events - $event : $err" $clientSock
     ::tcom::unbind $voice
 }

}
# ------------------------------------------------------------------------------
# ProcName : main 
# Args :
# Usage :   
# Called By:
#-------------------------------------------------------------------------------   
 global sock
 set port 5491
 
 set sock 0
 set clientSock 0  
 # Create the default voice object 
 
 # ::tcom::configure -concurrency multithreaded
 set voice [::tcom::ref createobject Sapi.SpVoice]
 
 
 # Grab the list of SAPI engines and sound devices to save duplicated effort
 set engineList [getEngineArray $voice]
 array set voicesArray $engineList
 set deviceList [getSoundDeviceArray $voice]
 array set deviceArray $deviceList
   
# set debug [open debug.log "w"]
   
 set maxint [expr 0x7[string range [format %X -1] 1 end]]
   
 # Start the Listening Server
 if { [catch {set sock [sapiServer $port] } msg ]} { puts stderr "osapi-srv\
 error: $msg"; exit } 
 vwait forever 


