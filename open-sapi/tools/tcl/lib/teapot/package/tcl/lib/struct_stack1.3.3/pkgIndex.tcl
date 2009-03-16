
# @@ Meta Begin
# Package struct::stack 1.3.3
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
# Meta description     Create and manipulate stack objects
# Meta platform        tcl
# Meta recommend       tcllibc
# Meta require         {Tcl 8.2}
# Meta subject         tree matrix queue graph
# Meta summary         struct::stack
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.2]} return

package ifneeded struct::stack 1.3.3 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require Tcl 8.2

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            source [file join {@} stack.tcl]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide struct::stack 1.3.3

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
