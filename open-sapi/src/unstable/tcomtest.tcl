package require tcom

set voice [::tcom::ref createobject  Sapi.SpVoice]

proc setVoice {voice} {
    $voice Speak "This is a test." 0
}

 puts "[time { setVoice $voice } 100]"
 
 
 # 160625.74
