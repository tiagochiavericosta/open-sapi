package require Thread

# ------------------------------------------------------------------------------
# ProcName : voiceEvent 
# Args :
# Usage :   
# Called By:
#-------------------------------------------------------------------------------
proc voiceEvent { event args } {

global clientSock
global voice

 if {$event == "EndStream" && [$voice WaitUntilDone 500] } {
     puts "Speech Output ended : close clientSock"
     puts $clientSock "eos"
#    flush $clientSock
     catch { close $clientSock } err
     bugMe "Voice events - $event : $err" $clientSock
    ::tcom::unbind $voice
 }

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
# Proceedure Name: setRate
# Description:
#
# Returns:
#-------------------------------------------------------------------------------
proc setRate {voice rate} {

   $voice Rate $rate

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
# Proceedure Name: getVolume
# Description: Returns the current engines volume setting.
#
# Returns:
#-------------------------------------------------------------------------------
proc getVol {voice} {
   return [$voice Volume]    
}

proc speechThreadInit { } {
 
    
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
       thread::wait
}



    
    
    set initSpeechThread {
       
       package require tcom
       ::tcom::configure -concurrency multithreaded
       set voice [::tcom::ref createobject Sapi.SpVoice]
       
       proc setSoundDevice {voice device} {
           $voice AudioOutput $device
       }
       
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
       
       proc setEngine {voice engine} {
           $voice Voice $engine
       }
       
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
       
       proc setRate {voice rate} {
           $voice Rate $rate
           puts [$voice Rate]
       }
       
       proc setVol {voice volume} {
           $voice Volume $volume    
       }

       thread::wait
    }

   
    
    set watchVoiceEvents {
        # set voiceEvent 0
        
        proc voiceEvent {event args } {
           global voice
           global voiceEvent
           if {$event == "EndStream" && [$voice WaitUntilDone 1000] } {
               puts "Speech Output ended : close clientSock"
               # puts $clientSock "eos"
               # flush $clientSock
               # catch { close $clientSock } err
           
               # ::tcom::unbind $voice
           }
           puts "Voice events - $event : $args"
          #set voiceEvent 1
       }
    
       ::tcom::bind $voice voiceEvent
       $voice EventInterests 4
       vwait voiceEvent
    }
    
    set threadTest {
         puts [$voice Rate]
         setRate $voice 6
    }
    
# Create new threads
    set speechThread [thread::create $initSpeechThread]
    
    thread::send -async $speechThread $watchVoiceEvents forever
    
    thread::send -async $speechThread "\$voice Speak \"please speak me and more and \
    more\" 1"
    
    thread::send -async $speechThread "\$voice Speak \"please speak me and more and \
    more\" 1"
    
   #thread::send -async $speechThread $threadTest result
  #thread::send -async $speechThread "puts \$voice Speak \" \" 3" forever
   
   vwait forever
   
   vwait forever

# Stop the main thread from closing before we are done    
     
    
    
# Volume    
    set getVol  { }
    set setVol  { }
# Rate    
    set getRate { }
    set setRate { }
# Voices
    set getEngineArray      { getEngineArray $voice }
    set setEngine           { setEngine $voice $engine }
# Device
    set getSoundDeviceArray { getSoundDeviceArray $voice }
    set setSoundDevice      { setSoundDevice $voice $device }
# Synthesis
    set speakMe             { $voice Speak $text $speechFlags }
    set purgeMe             { $voice Speak "" 3 }
    
    

  


# set speechFlags 0
# set maxint [expr 0x7[string range [format %X -1] 1 end]]



# Create the default voice object 
# ::tcom::configure -concurrency multithreaded
# set voice [::tcom::ref createobject Sapi.SpVoice]
 
# Grab the list of SAPI engines and sound devices to save duplicated effort
# set engineList [getEngineArray $voice]
# array set voicesArray $engineList
# set deviceList [getSoundDeviceArray $voice]
# array set deviceArray $deviceList
