#!/usr/bin/tclsh
 
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

set verboseText 0

# ------------------------------------------------------------------------------
# ProcName : helpMe
# Args     : None
# Usage    : Supplies the user with usage information when called through stdout
# Accepts  : None
# Returns  : None
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
   puts "\t  --port <value>        : Value for server port. Default 5491"
   puts "\t  --test                : Tests components are present and configured"
   puts "\t -v, --verbose          : Verbose output"
#  puts "\t --pipemode             : Pipemode takes input on stdin to speak"
   puts "\t -h, --help             : This message\n"
   
   puts "*** Using ? instead of a numerical value will return the current\
    setting ***\n"
   puts "For updates, guides and help please refer to the project page:" 
   puts "http://www.rockbox.org"
   puts "For bugs, comments and support please contact thomaslloyd@yahoo.com." 
}
# ------------------------------------------------------------------------------
# ProcName : bugMe 
# Args     : $message to be output $logfile to be used for output
# Usage    : If verbose output is on this function will output debug info to \
             stdout or logfile
# Accepts  :
# Returns  :
# Called By: Any debug statement
#-------------------------------------------------------------------------------
proc bugMe {message} {
 
 global verboseText

    if {$verboseText} { puts stderr "Client : $message" }

}
#-------------------------------------------------------------------------------
# ProcName : startUpSever 
# Args     : $message to be output $logfile to be used for output
# Usage    : If verbose output is on this function will output debug info to\ 
             stdout or logfile
# Accepts  :
# Returns  :
# Called By: Any debug statement
#-------------------------------------------------------------------------------
proc startUpSever { port } {

set attempt 0

    bugMe "Attempting Server Start Up"
    
        exec wine /home/tom/open-sapi/tools/tcl/bin/tclsh85.exe\
         /home/tom/open-sapi/rockbox/client-server/server.tcl\
          > /dev/null 2> /dev/null &
    #   open "[info nameofexecutable] $tempFileName" r+]
    
    
    while { $attempt <= 6 } {  
        if { [catch {set sock [socket localhost $port] } err] } {
            after 10000
            incr attempt
            bugMe "Attempt No. $attempt"  
        } else {
            return $sock
        }
    }    
puts stderr " Client : Critical Error - unable to start Server on port:$port"
exit
}
#-------------------------------------------------------------------------------
# ProcName : sapiRead 
# Args     : 
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc sapiRead { sock } {
 
 global readyCheckerID
 set outChannel "stdout"
 set processedMessage "" 

   if { [gets $sock message] == -1 || [eof $sock] } {
        bugMe "Server closing client:socket closed"
        catch {flush $sock} err2
        catch {close $sock} err
        exit
   } else {
       if {$message == "eos"} {
           bugMe "Server closing client:eos"
           catch {flush $sock} err2
           catch {close $sock} err
           exit
       }
       
       foreach element $message {
           switch -exact -- $element {
               
               stderr {
                   set outChannel $element
               }
               
               204 {
                   foreach element $readyCheckerID {
                       bugMe "Cancelling Event: $element"
                       after cancel $element
                   }
                   bugMe "204 - Server Ready"
                   processCommands $sock
               }
               
               default {
                   bugMe "STDOUT - $element"
                   set processedMessage "$processedMessage $element"
               }
           }
       }
       set processedMessage [string trimleft $processedMessage]

# Bug: Never identified but the server socket would pass a \n to the clinet cauing 
#      problem unless handeled.

       if { [string len $processedMessage] } {
           puts $outChannel "$processedMessage"
       }
   }      
}
#------------------------------------------------------------------------------
# ProcName : processCommands
# Args     : 
# Usage    : 
# Accepts  :
# Returns  :
# Called By:
#-------------------------------------------------------------------------------
proc processCommands { sock } {
 global argv argc
 
 set textPending 0
 set runTest 0
 set skip 0
 set flag 0
 set filename "[pwd]/sapi.wav"
 set x 0
 set pitch 0
 set volume 100
 set rate 0
 set command ""
 set text ""
 set wavFormat 22
 set port 5491
 set attempt 0

 bugMe "Beginning of Prcessong"
foreach element $argv {
    bugMe "Arg = $element"
        if {$skip == 0} {
            switch -exact -- $element {
	        
                --wavformat {
                    set format [lindex $argv [expr $x + 1] ]
                    if { $format == "?"} { 
                    set command "$command getFormat" 
                    } else {
                    set command "$command setFormat"
                    }
                    
                set skip 1
                }
                
                -f {
                    set feedbackLvl [lindex $argv [expr $x + 1] ]
                    bugMe "Feeback Level : $feedbackLvl"
                    set command "$command setFeedback $feedbackLvl"
                    set skip 1
                }
                
                -o {
                    set filename [lindex $argv [expr $x + 1] ]
                    bugMe "Filename Set : $filename"
                    set skip 1
                }
                
                -a {
                    set flag [expr $flag | 1]
                    bugMe "Async Mode" 
                }

                --async {
                    set flag [expr $flag | 1]
                    bugMe "Async Mode"
                }      
	          
	             -l {
                    # Requires a regexpression to check for valid input here 
                    set volume [lindex $argv [expr $x + 1] ]
                    if { $volume == "?"} {
                        set command "$command getVol"
                        bugMe "Current Volume: $volume" 
                    } else {
                        if { $volume < 0 } {
                            set volume 0
                            bugMe "Volume Range 0-100. Negative value detected, correcting to min 0"
                        }
                        if { $volume > 100 } { 
                            set volume 100
                            bugMe "Volume Range 0-100. Value too high, correcting to max 100"
                        }
                        #Process XML Later
                        bugMe "Volume Set: $volume"
                    }
	                 set skip 1
                }

                --volume {
                    # Requires a regexpression to check for valid input here 
                    set volume [lindex $argv [expr $x + 1] ]
                    if { $volume == "?"} {
                        set command "$command getVol"
                        bugMe "Current Volume: $volume " 
                    } else {
                        if { $volume < 0 } {
                            set volume 0
                            bugMe "Volume too low, correcting to min 0"
                        }
                        if { $volume > 100 } { 
                            set volume 100
                            bugMe "Volume too high, correcting to max 100"
                        }
                        #Process XML Later
                        bugMe "Volume Set: $volume"
                    }
	                 set skip 1
                }
              
                -e {
                    # Requires a regexpression to check for valid input here
                    set engineNum [lindex $argv [expr $x + 1] ]
                    if { $engineNum == "?"} {
                        set command "$command getEngine"
                        bugMe "Got Engine List"  
                    } else {
                        set command "$command setEngine $engineNum"
                    }  
	                 set skip 1
                }

                --engine {
                    # Requires a regexpression to check for valid input here
                    set engineNum [lindex $argv [expr $x + 1] ]
                    if { $engineNum == "?"} {
                        set command "$command getEngine"
                        bugMe "Got Engine List"  
                    } else {
                        set command "$command setEngine $engineNum"
                    }  
	                 set skip 1
                }
                
	             -r {
                    # Sanity check Requires a regexpression
                    set rate [lindex $argv [expr $x + 1] ]
                    if { $rate == "?"} {
                        set command "$command getRate" 
                        bugMe "Current Rate: $rate"
                    } else {
                        if { $rate < -10 } { set rate -10
                            bugMe "Rate too low, correcting to min 0"
                        }
                        if { $rate > 10 } { set rate 10
                            bugMe "Rate too high, correcting to max 10"
                        }
                        #Process XML Later
                        bugMe "Set Rate: $rate"
                    }
                    set skip 1           
                }

                --rate {
                    # Sanity check Requires a regexpression
                    set rate [lindex $argv [expr $x + 1] ]
                    if { $rate == "?"} {
                        set command "$command getRate" 
                        bugMe "Current Rate: $rate"
                    } else {
                        if { $rate < -10 } { set rate -10
                            bugMe "Rate too low, correcting to min 0"
                        }
                        if { $rate > 10 } { set rate 10
                            bugMe "Rate too high, correcting to max 10"
                        }
                        #Process XML Later
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
                
                --pitch {
                    set pitch [lindex $argv [expr $x + 1] ]
                    #Process XML Later
                    bugMe "Set Pitch: $pitch"
                    set skip 1
                }
                
                -v {}
                
                --verbose {}
                
                --port {}
                
                default {
                    puts stderr "Unknown commandline switch $element.\
                     Please type -h for usage help"
                }
         	
            } ; # End switch
        } else { set skip [expr $skip - 1]} ; # End if skip
    incr x
    };# End of foreach    
     bugMe "End of Prcessing"
    
    set command "$command speechFlag $flag"
    set command [string trimleft $command]
    bugMe "Sending - $command"
    
    puts $sock $command
    
    if {$volume != "?"} {
        set text "<volume level=\"$volume\"/> $text"
    }
    if {$pitch != "?"} {
        set text "<pitch absmiddle=\"$pitch\"/> $text"
    }
    if {$rate != "?"} {
        set text "<rate absspeed=\"$rate\"/> $text"
    }
     
    if {$runTest} {
        if {$textPending} {
            bugMe "Error: Testing overrides text output remove --test option"
        } 
        puts $sock "testMe This is a test of the rockbox Utility speech output."
        
     } else {
         if {$textPending} {
         puts $sock "outFile $filename"  
         puts $sock "speakMe $text"
         }
     }
     
puts $sock closeMe
}

#-------------------------------------------------------------------------------
# Proceedure Name: main
# Description    : Test speech output with the given options 
#
# Returns        : Nothing
#-------------------------------------------------------------------------------
    bugMe "Starting up..."
    foreach element $argv {
        bugMe "Args: $element"
    }
    
  
 
# set textPending 0
# set runTest 0
# set skip 0
# set flag 0
# set filename "[pwd]/sapi.wav"
 set x 0
# set pitch 0
# set volume 100
# set rate 0
# set command ""
 
# set text ""
# set wavFormat 22
 set port 5491
 set attempt 0

# Process all arguments first to detect eleements that affect behaviour from
# startup

   if {!$argc} {helpMe ; exit }
    
     foreach element $argv {
         if { $element == "-v" || $element == "--verbose" } {
             set verboseText 1
             bugMe "Client: verbose output"
         }
         if { $element == "-h" || $element == "--help" } { 
             helpMe
             exit
         }
         if { $element == "--port"} {
             
             set port [lindex $argv [expr $x + 1] ]
             
             if { $port  == "?"} { 
                 puts stderr "Error: You can not query the server port number\
                  from the client."
             }    
         } 
     incr x
     }

     if {$port == 0 || $port == "?"} {
         set port 5491
         bugMe "Looking for server on localhost port 5491 by default"
     }
 
    
    if { [catch {set sock [socket localhost $port] } err] } {
        bugMe "Server unreachable attempting to start..."
        set sock [startUpSever $port]
    }
    
    fconfigure $sock -buffering line -blocking 0 -encoding utf-8
    fileevent $sock readable [list sapiRead $sock]
    
    bugMe "Client: Connected on $sock"
    
    while { $attempt < 6 } { 
        set x 0
            lappend readyCheckerID [after [expr {10000 * $attempt}] { 
                incr x
                puts $sock "readyServer"
                bugMe "Server Ready Test - Attempt No.$x"
                if { $x == 6} {
                    puts stderr "Server did not respond in reasonable time"
                    exit
                }
            }]
    incr attempt
    }    
    
    
 
    
vwait forever
 
