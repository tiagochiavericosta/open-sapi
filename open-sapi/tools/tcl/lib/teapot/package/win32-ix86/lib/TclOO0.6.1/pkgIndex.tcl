if {[catch {package require Tcl 8.5b1}]} return
package ifneeded TclOO 0.6.1 \
    [list load [file join $dir TclOO061.dll] TclOO]
