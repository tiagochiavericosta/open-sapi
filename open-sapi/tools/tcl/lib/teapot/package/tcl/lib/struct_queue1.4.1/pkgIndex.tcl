
# @@ Meta Begin
# Package struct::queue 1.4.1
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta category        Tcl Data Structures
# Meta description     Create and manipulate queue objects
# Meta platform        tcl
# Meta recommend       tcllibc
# Meta require         {Tcl 8.2}
# Meta subject         list set tree matrix pool graph stack skiplist
# Meta subject         record prioqueue
# Meta summary         struct::queue
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.2]} return

package ifneeded struct::queue 1.4.1 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require Tcl 8.2

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            source [file join {@} queue.tcl]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide struct::queue 1.4.1

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
