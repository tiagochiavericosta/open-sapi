package require tcom

set maxint [expr 0x7[string range [format %X -1] 1 end]]

       # ::tcom::configure -concurrency multithreaded
       set voice [::tcom::ref createobject Sapi.SpVoice]
       set APO [::tcom::ref createobject Sapi.SpCustomStream]
       set GI [::tcom::ref createobject  Sapi.SPStream]
      # set GIC [::tcom::ref createobject Sapi.SPStream.CreateStreamOnHGlobal]
      set testStream [::tcom::ref createobject Sapi.SpFileStream]
      set GIC [::tcom::ref createobject Sapi.SpAudioFormat]
      
      # [$APO Open "True" "AUDIOFORMAT"]
       $GIC Type 6
       $testStream Format $GIC
       
       # set GIC [$GI -call Sapi.SPStream.CreateStreamOnHGlobal]
       # [$GIC hGlobal NULL]
       # [$GIC fDeleteOnRelease True]
       # [$GIC ppstm $GI]

       
       $GI SetBaseStream $APO $GIC 6
       
       # set $VAOS $APO
        
       $voice Speak "Welcome!"
       set test 0
       while {1} {
           [$APO Read $test 100]
           puts $test
       }
