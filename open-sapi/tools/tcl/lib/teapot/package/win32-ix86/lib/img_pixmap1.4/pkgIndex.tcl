
# @@ Meta Begin
# Package img::pixmap 1.4
# Meta activestatetags ActiveTcl Public Img
# Meta as::origin      http://sourceforge.net/projects/tkimg
# Meta category        Tk Image Format
# Meta description     This s support for the pixmap image format.
# Meta platform        win32-ix86
# Meta require         {img::base 1.4-2}
# Meta require         {Tcl 8.4-9}
# Meta require         {Tk 8.4-9}
# Meta subject         pixmap
# Meta summary         pixmap Image Support
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.4]} return

package ifneeded img::pixmap 1.4 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require img::base 1.4-2
        package require Tcl 8.4-9
        package require Tk 8.4-9

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            load [file join {@} tkimgpixmap14.dll]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide img::pixmap 1.4

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
