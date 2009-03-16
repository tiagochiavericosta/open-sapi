
# @@ Meta Begin
# Package snit 2.2.1
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta category        Snit's Not Incr Tcl, OO system
# Meta description     Snit's Not Incr Tcl
# Meta platform        tcl
# Meta recommend       Tk
# Meta require         {Tcl 8.4}
# Meta subject         {object oriented} C++ type {widget adaptors} widget
# Meta subject         BWidget object {Incr Tcl} class Snit adaptors
# Meta subject         {mega widget}
# Meta summary         snit
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.4]} return

package ifneeded snit 2.2.1 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require Tcl 8.4

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            source [file join {@} snit2.tcl]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide snit 2.2.1

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
