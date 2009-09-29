#!/usr/bin/tclsh

#    $argc - number items of arguments passed to a script.
#    $argv - list of the arguments.
#    $argv0 - name of the script.

# ------------------------------------------------------------------------------
# ProcName : bugMe 
# Args : $message to be output $logfile to be used for output, $verbose on or off
# Usage : If verbose output is on this function will output debug info to log 
# Called By: Any debug statement
#-------------------------------------------------------------------------------

proc bugMe {message} { 
global verbose
if {$verbose} { puts stderr "$message" } 
}

# ------------------------------------------------------------------------------
# ProcName : helpMe 
# Args : None
# Usage : Displays help and usage information to stdout  
# Called By: main
#-------------------------------------------------------------------------------
proc helpMe {} {
   
   puts "Open-SAPI Commandline Interface v0.1 Alpha\n"

   puts "Usage: osapi-cli ...\[swithches\] -adihloprsvx -t \"message\""
   puts "A command line interface providing access to the text to speech\
   \(TTS\) capabilities of the Microsoft Speech Engine \(SAPI\)\n"
   
   puts "Optional switches:"
   puts "\t -t, --text <text>      : Text to be spoken"
   puts "\t -l, --volume <value>   : Sets Volume Level. Range Min 0 - 100 Max"
   puts "\t -r, --rate  <value>    : Sets Speech Rate. Range Min 0 - 20 Max"
   puts "\t -p, --person <value>   : Sets Default Person"
   puts "\t -d, --device <value>   : Sets Audio Device"
#   puts "\t -x, --xml              : Turns on XML markup processing"
#   puts "\t     --xml-global       : Enable XML markup globally"
#   puts "\t -i, --icon <file>      : Sound Icon to play"
#   puts "\t -a, --async            : Ayncronous Playback"
#   puts "\t     --purge            : Remove & replace all queued speech"
#   puts "\t -c, --config <file>    : Specify configuration file"
#   puts "\t -o, --save <file>      : Output current config to file"
#   puts "\t -s, --server <action>  : Server Actions - start, restart, stop"
#   puts "\t     --port <value>     : Server listing port. Default 5491"
#   puts "\t -t, --test             : Tests components are present and configured"
   puts "\t -v, --verbose          : Verbose output"
   puts "\t --pipemode             : Pipemode takes input on stdin to speak"
   puts "\t -h, --help             : This message\n"
   
   puts "*** Using ? instead of a numerical value will return the server setting ***\n"
   puts "For updates, guides and help please refer to the project page found at:" 
   puts "http://code.google.com/p/open-sapi/w/list"
   puts "For bugs, comments and support please contact thomaslloyd@yahoo.com." 
}

#-------------------------------------------------------------------------------
# Proceedure Name: monitorMe
# Description: Set and Cancel timeout events for events that can fail on the 
#              server
# Returns: Generated eventID for tracking and passing to the server
#-------------------------------------------------------------------------------
proc monitorMe {eventName timeout eventID} {

global eventArray

    if {$timeout == "cancel"} {
        after cancel $eventArray($eventName,$eventID)
        bugMe "Event : $eventName - $eventArray($eventName,$eventID) : OK "
        return
    }
     
    set eventID [after $timeout {
        bugMe "Client timeout - exit"
        exit
        }]

    set eventArray($eventName,eventID) $eventID

return $eventID
}
#----------------------------------------------------------------
# Proceedure Name: serverControl
# Description: Performs Global changes to the servers behaviour
#
# Returns: Nothing
#----------------------------------------------------------------
proc serverControl {action sock} {
# Will needed reinplementing when Wrapped as final app
 switch -exact -- $action {
     force { 
         exec killall wish85.exe
         }
     
     restart {
         puts $sock "serverAction shutdown"
         
         after 5000 {
             exec /usr/bin/wine /home/tom/.wine/drive_c/Tcl/bin/wish85.exe /home/tom/speech/dev/osapi-srv.tcl
             set sock [socket localhost $port]
             fconfigure $sock -buffering line -blocking 0
             fileevent $sock readable [list sapiRead $sock]} 
         }
     
     shutdown {
          puts $sock "serverAction $action"
        # exec killall wish85.exe
         close $sock
         exit 
         }

     start {
         exec "wine /home/tom/.wine/drive_c/Tcl/bin/wish85.exe /home/tom/speech/dev/osapi-srv.tcl"
         }
         
     default {puts "The server does not know how to perform: $action. Please type -h for usage help"}
 }
return $sock
}
# ----------------------------------------------------------------------------------
# ProcName : sapiRead 
# Args : sock
# Usage :  
# Called By:
#-----------------------------------------------------------------------------------
proc sapiRead {sock} {
puts "Data Received"
set skip 0
set x 0
   
   if { [gets $sock message] == -1 || [eof $sock] } {
        puts "Server closing client:socket closed"
      # flush $sock
        close $sock
        exit
   } else {
   
       set message [split $message " "]
   
       foreach element $message {
           if {$skip == 0} {
               switch -exact -- $element {
                 
                   closeClient {
                       bugMe "Server asked us to close"
                    #  flush $sock
                       close $sock
                       exit
                   }
                 
                   eventFeedback {
                       set eventName [lindex $message [expr $x + 1]]
                       set eventID [lindex $message [expr $x + 2]]
                       set eventStatus [lindex $message [expr $x + 3]]
                       bugMe "eventFeedback : $eventName - $eventID - $eventStatus"
                       monitorMe $eventName cancel eventID
                       set skip 3
                   }
            
               }; # End of Switch 
           } else { set skip [expr $skip - 1] }; # End of If 
       incr x 
       }; # End of foreach
     bugMe "Server Callback: $message" 
     } ; # End of Else
 
}
# ----------------------------------------------------------------------------------
# ProcName : Script Init (run once)
# Args : argv argc
# Usage : Runs SAPI client  
# Called By:
#-----------------------------------------------------------------------------------
 proc init {} {
 
 global argv 
 global argc
 global command
 global verbose
 global sock
 global eventArray
 set flag 0
 set verbose 0
 set x 0
 set port 0
 
 foreach element $argv {
     if { $element == "-v" || $element == "--verbose" } { set verbose 1; bugMe "Client: verbose output"}
     if { $element == "-h" || $element == "--help" } { helpMe ; exit }
     if { $element == "--port"} {
         set port [lindex $argv [expr $x + 1] ]
         if { $port  == "?" || $port == 0} { 
             puts "Error: You can not query the server port number from the \
             client."
         } else {
             set port 5491 
             bugMe "Client: Server Port is set to: $port by default"
         }      
     } 
 incr x
 }

 if {$port == 0 || $port == "?"} {set port 5491
     bugMe "Client: Looking for server on localhost port 5491 by default"
 }

 if { [catch {set sock [socket localhost $port] } err] } {
 puts "300"
 bugMe "Client: Critical - Unable to establish connection with server : Exitting"
 after 1000 [ exit 300 ]
 }
 bugMe "Client: Connected on $sock"
 
fconfigure $sock -buffering line -blocking 0 -encoding utf-8
fconfigure stdin -buffering line -blocking 0 -encoding utf-8


 
 set x 0
 set skip 0
 set eventTimeout 5000
 # Maybe this timeout value needs to be dependant on the current rate?  
 set averageWordTime 4000
 set command "appName osapi-cli"
 set pipeMode 0
 
 foreach element $argv {
     if {$skip == 0} {
         switch -exact -- $element {
	        
             -a {
                 set flag [expr $flag | 1]
                 bugMe "Client: Option - async  - flag : $flag"
             }

             --async {
                 set flag [expr $flag | 1]
                 bugMe "Client: Option - async - flag : $flag"
             }

	          -d {
                  # Requires a regexpression to check for valid input here
                  set device [lindex $argv [expr $x + 1] ]
                  if { $device == "?"} {
                      set eventID [monitorMe getDevice $eventTimeout 0]
                      set command "$command getDevice $eventID" 
                      bugMe "$eventID - Client: getDevice"
                 } else {
                      set eventID [monitorMe setDevice $eventTimeout 0]
                      bugMe "$eventID - Client: setDevice to $device"
                      set command "$command setDevice $device $eventID"
                 } 
	              set skip 1 
             }
                
         --device {
                  # Requires a regexpression to check for valid input here
                  set device [lindex $argv [expr $x + 1] ]
                  if { $device == "?"} {
                      set eventID [monitorMe getDevice $eventTimeout 0]
                      set command "$command getDevice $eventID"
                      bugMe "$eventID - Client: getDevice"
               } else {
                      set eventID [monitorMe setDevice $eventTimeout 0]
                      bugMe "$eventID - Client: setDevice to $device"
                      set command "$command setDevice $device $eventID"
                  } 
         	  set skip 1
         }

	      -i {bugMe "Client: sound icon"
                  # Check to see if this references a file or a sound icon from server library
	          set skip 1
         }

         --icon {bugMe "Client: icon"
                  set skip 1
         }

	      -l {
             # Requires a regexpression to check for valid input here 
             set volume [lindex $argv [expr $x + 1] ]
             if { $volume == "?"} {
                 set eventID [monitorMe getVolume $eventTimeout 0]
                 bugMe "$eventID - Client: Sending getVolume" 
                 set command "$command getVolume $eventID"
             } else {
                 if { $volume < 0 } {set volume 0
                     puts "Volume Range 0-100. Negative value detected, correcting to min 0"
                 }
                 if { $volume > 100 } { set volume 100
                     puts "Volume Range 0-100. Value too high, correcting to max 100"
                 }
                 set eventID [monitorMe setVolume $eventTimeout 0]
                 bugMe "$eventID - Client: set Server Volume to $volume"
                 set command "$command setVolume $volume $eventID"
             }
	          set skip 1
         }

         --volume {
             # Requires a regexpression to check for valid input here 
             set volume [lindex $argv [expr $x + 1] ]
             if { $volume == "?"} {
                 set eventID [monitorMe getVolume $eventTimeout 0]
                 bugMe "$eventID - Client: Sending getVolume" 
                 set command "$command getVolume $eventID"
            } else {
                 if { $volume < 0 } {set volume 0
                     puts "Volume Range 0-100. Negative value detected, correcting to min 0"
                 }
                 if { $volume > 100 } { set volume 100
                     puts "Volume Range 0-100. Value too high, correcting to max 100"
                 }
                 set eventID [monitorMe setVolume $eventTimeout 0]
                 bugMe "$eventID - Client: set Server Volume to $volume"
                 set command "$command setVolume $volume $eventID"
             }
	          set skip 1
         }

	      -o {bugMe "Client: save settings"
	          set skip 1
              }
     
              -p {
                  # Requires a regexpression to check for valid input here
                  set person [lindex $argv [expr $x + 1] ]
                  if { $person == "?"} {
                      set eventID [monitorMe getVoice $eventTimeout 0]
                      bugMe "$eventID - Client: Sending getVoice" 
                      set command "$command getVoice $eventID" 
                  } else {
                      set eventID [monitorMe setVoice $eventTimeout 0]
                      set command "$command setVoice $person $eventID"
                      bugMe "$eventID - Client: Sending setVoices $person"
                  } 
	               set skip 1
              }

              --person {
                   # Requires a regexpression to check for valid input here
                  set person [lindex $argv [expr $x + 1] ]
                  if { $person == "?"} {
                      set eventID [monitorMe getVoice $eventTimeout 0]
                      bugMe "$eventID - Client: Sending getVoice" 
                      set command "$command getVoice $eventID" 
                 } else {
                     set eventID [monitorMe setVoice $eventTimeout 0]
                      set command "$command setVoice $person $eventID"
                      bugMe "$eventID - Client: Sending setVoices $person"
                  } 
                  set skip 1
              }

	      -r {
                  # Sanity check Requires a regexpression to check for valid input here
                  set rate [lindex $argv [expr $x + 1] ]
                  if { $rate == "?"} {
                      set eventID [monitorMe getRate $eventTimeout 0]
                      bugMe "$eventID - Client: Sending getRate" 
                      set command "$command getRate $eventID" 
                  } else {
                      if { $rate < -10 } { set rate 0
                          puts "Min Rate Range -10. Bad value detected, correcting to defaukt 0"
                      }
                      if { $rate > 10 } { set rate 0
                          puts "Max Rate Range +10. Bad value detected, correcting to defaukt 0"
                      }
                      set eventID [monitorMe setRate $eventTimeout 0]
                      set command "$command setRate $rate $eventID"
                      bugMe "$eventID - Client: set Server Rate to $rate"
                  }
              set skip 1           
              }

              --rate {
                  # Sanity check Requires a regexpression to check for valid input here
                  set rate [lindex $argv [expr $x + 1] ]
                  if { $rate == "?"} {
                      set eventID [monitorMe getRate $eventTimeout 0]
                      bugMe "$eventID - Client: Sending getRate" 
                      set command "$command getRate $eventID" 
                 } else {
                      if { $rate < -10 } {set rate 0
                          puts "Min Rate Range -10. Bad value detected, correcting to defaukt 0"
                      }
                      if { $rate > 10 } { set rate 0
                          puts "Max Rate Range +10. Bad value detected, correcting to defaukt 0"
                      }
                      set eventID [monitorMe setRate $eventTimeout 0]
                      set command "$command setRate $rate $eventID"
                      bugMe "$eventID - Client: set Server Rate to $rate"
                  }
              set skip 1
              }

	      -s {puts "Server closing client"
        flush $sock
        close $sock
        exit
                  set action [lindex $argv [expr $x + 1]]
                  set sock [serverControl $action $sock]
                  bugMe "Client: Requesting server to $action"
                  set skip 1
              }

              --server {
                  set action [lindex $argv [expr $x + 1]]
                  set sock [serverControl $action $sock]
                  bugMe "Client: Requesting server to $action"
                  set skip 1
              }

              --save-config {bugMe "save-config"
         	  set skip 1
              }

	      -t {
	          set i 1
	          set word [lindex $argv [expr $x + $i]]
	          set text $word
	          incr i
	          while {$word != "@@" ^ $i > $argc} {
	              set word [lindex $argv [expr $x + $i]]
	              set text "$text $word"
	              puts "i = $i : mess = $argc"
	              incr i
	          }
	          set eventID [monitorMe say [expr $i * $averageWordTime]  0]
	          set command "$command say $text $eventID"
	          bugMe "$eventID - Client: Send for speech  - $text"
	          set skip [expr $i - 1]
         }

         --text {
             set i 1
	          set word [lindex $argv [expr $x + $i]]
	          set text $word
	          incr i
	          while {$word != "@@" ^ $i > $argc} {
	              set word [lindex $argv [expr $x + $i]]
	              set text "$text $word"
	              incr i
	          }
	          set eventID [monitorMe say [expr $i * $averageWordTime]  0]
             set command "$command say $text $eventID"
	          bugMe "$eventID - Client: Send for speech  - $text"
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

              --xml-global {
                  set flag [expr $flag | 32]
                  bugMe "Client: Speech Flag: $flag - Global XML"  
              }

              --purge {
                  set flag [expr $flag | 2]
                  bugMe "Client: Speech Flag: $flag - purge"  
              }
                
               --punct {
                  set flag [expr $flag | 64]
                  bugMe "Client: Speech Flag: $flag - All Punctuation" 
              }

              --config {
                  set skip 1
              }

              --test {bugMe "test"
              }
                
              --pitch {
                  set pitch [lindex $argv [expr $x + 1] ]
                  if { $pitch == "?"} {
                      set eventID [monitorMe getPitch $eventTimeout 0]
                      bugMe "$eventID - Client: Sending getPitch" 
                      set command "$command getPitch $eventID" 
                  } else {
                      set command "$command setPitch $pitch $eventID"
                      set eventID [monitorMe setPitch $eventTimeout 0]
                      bugMe "$eventID - Client: Sending setPitch $pitch"
                  } 
                  set skip 1
              }
                
              -v {}
                
              --verbose {}
                
              --port { bugMe "Client: Set Port"
              set skip 1}
                
              --pipemode { 
                  bugMe "Pipe Mode"
                  set pipeMode 1
                  set command "$command pipeMode"
              }
                
              default { 
                  puts stdout "Unknown Option $element. Please type -h for usage help !!"
              }
         	
         } ; # End switch
     } else { set skip [expr $skip - 1]} ; # End if skip
 incr x
 };# End of foreach

 set command "$command setFlags $flag"

# bugMe "Client: command = $command"
 if {!$pipeMode} {
    puts $sock $command
    exit
 }
 
fileevent stdin readable [list stdinRead $sock $command]
fileevent $sock readable [list sapiRead $sock]

}
# ------------------------------------------------------------------------------
# ProcName : stdinRead 
# Args : argv argc (global)
# Usage : Runs SAPI client  
# Called By:
#-------------------------------------------------------------------------------
proc stdinRead { sock command } {
set averageWordTime 4000

    if { [gets stdin line] == -1 || [eof stdin] } {
        catch {
            close stdin
        } err
        set forever 1
        bugMe "closed stdin - $err"
        return
    } else {
            set message [split $line " "]
            set eventID [monitorMe say [expr [llength $line] * $averageWordTime]  0]
            if {$line == "" } { return } else {
                puts $sock "$command say $line @@ $eventID"
            }
        }
}
# ------------------------------------------------------------------------------
# ProcName : main 
# Args : argv argc (global)
# Usage : Runs SAPI client  
# Called By:
#-------------------------------------------------------------------------------
#    SpeechVoiceSpeakFlags
#    SpVoice flags
#    SVSFDefault = 0
#    SVSFlagsAsync = 1
#    SVSFPurgeBeforeSpeak = 2
#    SVSFIsFilename = 4
#    SVSFIsXML = 8
#    SVSFIsNotXML = 16
#    SVSFPersistXML = 32
#    SVSFNLPSpeakPunc = 64

global verbose
global sock
global command

monitorMe globalClient 5000 0

if {$argc > 0} { init } else {helpMe; exit }
vwait forever
