package require tcom
# package require snack

set maxint [expr 0x7[string range [format %X -1] 1 end]]

    proc watchVoiceEvent {event args} {
           global voice
           global GI
           #if {$event == "EndStream" && [$voice WaitUntilDone 500] } {
           #    puts "Stream Event : $event - $args"
           #}
           puts "Stream Event : $event - $args"
           set EOF 0
           set rawAudio "Default"
#Enum SpeechStreamSeekPositionType
set SSSPTRelativeToStart 0
set SSSPTRelativeToCurrentPosition 1
set SSSPTRelativeToEnd 2
#End Enum
           puts "Seek Position - [$GI Seek 0 $SSSPTRelativeToStart]"
           set EOF 
           while { !$EOF} {
               set readCount [ $GI Read rawAudio 100 ]
               if {[string length $readCount] < 100} {
                    set readCount [expr $readCount + $readCount]
                    puts "RC - $readCount"
               }
                set EOF 1
           
           } 
           
    }
       
       # ::tcom::configure -concurrency multithreaded
       set voice [::tcom::ref createobject Sapi.SpVoice]
       set customStream [::tcom::ref createobject Sapi.SpCustomStream]
       set GI [::tcom::ref createobject  Sapi.SpMemoryStream]
       # set stream [::tcom::ref createobject  Sapi.IStream]
      #set GIC [::tcom::ref createobject Sapi.SPStream.CreateStreamOnHGlobal]
      set testStream [::tcom::ref createobject Sapi.SpFileStream]
      set GIC [::tcom::ref createobject Sapi.SpAudioFormat]
    
    # puts "$customStream"
    # puts "GI = $GI"
    # puts [$customStream BaseStream $GI]
    # set FALSE false
    # if {$FALSE} {} 
    # puts [$voice AllowAudioOutputFormatChangesOnNextSet]

#    Enum SpeechVoiceEvents
    set SVEStartInputStream 2
    set SVEEndInputStream 4
    set SVEVoiceChange 8
    set SVEBookmark 16
    set SVEWordBoundary 32
    set SVEPhoneme 64
    set SVESentenceBoundary 128
    set SVEViseme 256
    set SVEAudioLevel 512
    set SVEPrivate 32768
    set SVEAllEvents 33790
#    End Enum

    ::tcom::bind $voice watchVoiceEvent
    $voice EventInterests $SVEEndInputStream 
    
      
# sound 
    #puts [$GI CreateStreamOnHGlobal "0&;, True, $GI"]

      # [$APO Open "True" "AUDIOFORMAT"]
      
     $GIC Type 39
     $GI Format $GIC
     # $voice AudioOutputStream $GI

     #$voice AudioOutputStream $customStream 

       #  set GIC [$GI -call Sapi.SPStream.CreateStreamOnHGlobal]
       #  [$GIC hGlobal NULL]
       #  [$GIC fDeleteOnRelease True]
       #  [$GIC ppstm $stream]

       #set outputStream [$voice GetOutputStream]
       $customStream BaseStream $GI
       $voice AudioOutputStream $customStream
       
       # set $VAOS $APO
        
     $voice Speak "This is a test. We are going to make more noise and speaking than normal?\
     and on and on and on, and on and on and, on some more."

     #  set test 0
     #  while {1} {
     #      puts [$GI GetData]
     #  }
   # set s [snack::sound -debug 5]
   # set wav [$GI GetData]
   

   
   
   # $s data $wav -guessproperties 1 -fileformat RAW
   #puts [snack::mixer outputs]
   #puts [snack::mixer lines]
   #puts [snack::mixer output]
   #puts [snack::audio outputDevices]
   #snack::audio selectOutput "EsounD WaveOutDriver (Win multimedia)"
   #puts [snack::audio rates]
   #$s play
#   set filename [open wavtest.wav w+]
#   fconfigure $filename -translation binary -encoding binary
#   puts $filename $wav
#   close $filename
#   #puts [$s power]
   vwait 1
