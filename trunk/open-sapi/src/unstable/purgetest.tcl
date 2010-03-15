# time wine ~/open-sapi/tools/tcl/bin/tclsh85.exe ~/open-sapi/src/unstable/purgetest.tcl 2> /dev/null
# Speak Space = 40139.7 microseconds per iteration 
# Skip Sentence = 16715.7 microseconds per iteration 
# Rate = 200484.46 microseconds per iteration 
# XML = 123127.82 microseconds per iteration 


#Speak Space = 21490.76 microseconds per iteration 
#Skip Sentence = 164500.6 microseconds per iteration 
#Rate = 146549.4 microseconds per iteration 
#XML = 141047.42 microseconds per iteration 

package require tcom

set maxint [expr 0x7[string range [format %X -1] 1 end]]
set XML0 "<rate absspeed=\"0\"/>"
set XML5 "<rate absspeed=\"5\"/>"

       ::tcom::configure -concurrency multithreaded
       set voice [::tcom::ref createobject Sapi.SpVoice]
# Speak Space = 22698.94 microseconds per iteration       
puts "\n\n Speak Space = [ time {
           set i 0
           $voice Speak "This is a test of the ms speech engine time cut out.This is a test of the ms speech engine time cut out." 1 
           while { $i < 5000} { incr i }
           $voice Speak " " 3      
       } 50 ] \n\n"

puts "VS = [$voice GetOutputStream]"

# Skip Sentence = 38106.04 microseconds per iteration       
puts "\n\n Skip Sentence = [ time {
           set i 0
           $voice Speak "This is a test of the ms speech engine time cut out.This is a test of the ms speech engine time cut out." 1
           while { $i < 5000} { incr i }
           $voice Skip Sentence $maxint 
       } 50 ] \n\n"

# Rate = 213061.26 microseconds per iteration       
puts "\n\n Rate = [ time {
           $voice Rate 5
           $voice Speak "Test" 0
           $voice Rate 0
           $voice Speak "Test" 0
           } 50 ] \n\n"

# XML = 126460.28 microseconds per iteration 
puts "\n\n XML = [ time {
           $voice Speak "$XML5 Test" 0
           $voice Speak "$XML0 Test" 0
           } 50 ] \n\n"
