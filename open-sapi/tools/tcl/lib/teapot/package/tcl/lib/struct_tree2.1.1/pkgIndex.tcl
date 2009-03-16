
# @@ Meta Begin
# Package struct::tree 2.1.1
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
# Meta category        Tcl Data Structures
# Meta description     Create and manipulate tree objects
# Meta platform        tcl
# Meta recommend       tcllibc
# Meta require         {Tcl 8.2}
# Meta require         struct::list
# Meta subject         in-order pre-order tree depth-first node
# Meta subject         serialization breadth-first post-order
# Meta summary         struct::tree
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.2]} return

package ifneeded struct::tree 2.1.1 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require Tcl 8.2
        package require struct::list

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            source [file join {@} tree.tcl]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide struct::tree 2.1.1

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
