#!/usr/bin/wish8.5

catch {console show}
set channel {stdin}
fconfigure $channel -buffering line -blocking 0

fileevent $channel readable { 
if {[eof $channel] || [catch {gets $channel line} ] } {
    exit
   } else {
       puts $line
   }
}
vwait forever
