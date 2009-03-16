# ACTIVESTATE TEAPOT-PKG BEGIN TM -*- tcl -*-
# -- Tcl Module

# @@ Meta Begin
# Package Img 1.4
# Meta activestatetags ActiveTcl Public Img
# Meta as::author      {Jan Nijtmans}
# Meta as::origin      http://sourceforge.net/projects/tkimg
# Meta category        Tk Image Format
# Meta description     The Img package provides support for several image
# Meta description     formats beyond the standard formats in Tk (PBM, PPM,
# Meta description     and GIF), including BMP, XBM, XPM, GIF (no LZW),
# Meta description     PNG, JPEG, TIFF, and PostScript.
# Meta license         BSD
# Meta platform        tcl
# Meta require         {Tcl 8.4}
# Meta require         {Tk 8.4}
# Meta require         {img::bmp 1.4-2}
# Meta require         {img::gif 1.4-2}
# Meta require         {img::ico 1.4-2}
# Meta require         {img::jpeg 1.4-2}
# Meta require         {img::pcx 1.4-2}
# Meta require         {img::pixmap 1.4-2}
# Meta require         {img::png 1.4-2}
# Meta require         {img::ppm 1.4-2}
# Meta require         {img::ps 1.4-2}
# Meta require         {img::sgi 1.4-2}
# Meta require         {img::sun 1.4-2}
# Meta require         {img::tga 1.4-2}
# Meta require         {img::tiff 1.4-2}
# Meta require         {img::window 1.4-2}
# Meta require         {img::xbm 1.4-2}
# Meta require         {img::xpm 1.4-2}
# Meta subject         bmp gif ico jpeg pcx pdf pixmap png ppm ps sgi sun
# Meta subject         tga tiff window xbm xpm
# Meta summary         Additional image formats for Tk
# @@ Meta End


# ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

package require Tcl 8.4
package require Tk 8.4
package require img::bmp 1.4-2
package require img::gif 1.4-2
package require img::ico 1.4-2
package require img::jpeg 1.4-2
package require img::pcx 1.4-2
package require img::pixmap 1.4-2
package require img::png 1.4-2
package require img::ppm 1.4-2
package require img::ps 1.4-2
package require img::sgi 1.4-2
package require img::sun 1.4-2
package require img::tga 1.4-2
package require img::tiff 1.4-2
package require img::window 1.4-2
package require img::xbm 1.4-2
package require img::xpm 1.4-2

# ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

# ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

package provide Img 1.4

# ACTIVESTATE TEAPOT-PKG END DECLARE
# ACTIVESTATE TEAPOT-PKG END TM

    # Compatibility hack. When asking for the old name of the package
    # then load all format handlers and base libraries provided by tkImg.
    # Actually we ask only for the format handlers, the required base
    # packages will be loaded automatically through the usual package
    # mechanism.

    # When reading images without specifying it's format (option -format),
    # the available formats are tried in reversed order as listed here.
    # Therefore file formats with some "magic" identifier, which can be
    # recognized safely, should be added at the end of this list.

    package require img::window
    package require img::tga
    package require img::ico
    package require img::pcx
    package require img::sgi
    package require img::sun
    package require img::xbm
    package require img::xpm
    package require img::ps
    package require img::jpeg
    package require img::png
    package require img::tiff
    package require img::bmp
    package require img::ppm
    package require img::gif
    package require img::pixmap

    package provide Img 1.4
