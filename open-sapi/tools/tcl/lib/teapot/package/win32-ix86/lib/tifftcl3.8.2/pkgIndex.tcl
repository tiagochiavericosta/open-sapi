
# @@ Meta Begin
# Package tifftcl 3.8.2
# Meta activestatetags ActiveTcl Public
# Meta as::author      {Jan Nijtmans}
# Meta as::origin      http://sourceforge.net/projects/tkimg
# Meta description     A variant of the libtiff system library made
# Meta description     suitable for direct loading as a Tcl package.
# Meta license         BSD
# Meta platform        win32-ix86
# Meta require         {Tcl 8.4}
# Meta summary         tiff Support
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.4]} return

package ifneeded tifftcl 3.8.2 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require Tcl 8.4

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            load [file join {@} tifftcl382.dll]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide tifftcl 3.8.2

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
