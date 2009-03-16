#
# Tcl package index file
#
# Note sqlite*3* init specifically
#
package ifneeded sqlite3 3.6.10 \
    [list load [file join $dir sqlite3610.dll] Sqlite3]
