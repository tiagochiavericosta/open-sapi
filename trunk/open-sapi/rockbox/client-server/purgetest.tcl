package require tcom

set maxint [expr 0x7[string range [format %X -1] 1 end]]

       ::tcom::configure -concurrency multithreaded
       set voice [::tcom::ref createobject Sapi.SpVoice]
       
puts [ time {
       $voice Speak "<bookmark mark="bookmark_one"/>This is a test of the ms speech<bookmark mark="bookmark_two"/> engine time cut out.<bookmark mark="bookmark_three"/>" 1
       after 1000 { $voice Speak " " 3 }
       } 50
       
puts [ time {
       $voice Speak "This is a test of the ms speech engine time cut out." 1
       after 1000 { $voice Skip Sentence $maxint }
       } 50
