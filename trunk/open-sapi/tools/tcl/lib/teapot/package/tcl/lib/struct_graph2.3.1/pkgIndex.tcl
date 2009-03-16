
# @@ Meta Begin
# Package struct::graph 2.3.1
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib ActiveTcl Public Tcllib
# Meta activestatetags ActiveTcl Public Tcllib
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
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta category        Tcl Data Structures
# Meta description     Create and manipulate directed graph objects
# Meta platform        tcl
# Meta recommend       tcllibc
# Meta require         {Tcl 8.4}
# Meta require         struct::list
# Meta require         struct::set
# Meta subject         cgraph graph
# Meta summary         struct::graph v1
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.4]} return

package ifneeded struct::graph 2.3.1 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require Tcl 8.4
        package require struct::list
        package require struct::set

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            source [file join {@} graph.tcl]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide struct::graph 2.3.1

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
