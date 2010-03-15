package require tcom

 
 set testStream [::tcom::ref createobject Sapi.SpFileStream]
 set testFormat [::tcom::ref createobject Sapi.SpAudioFormat]
 ::tcom::configure -concurrency multithreaded
 set voice [::tcom::ref createobject Sapi.SpVoice]
 set testStreamFormat [$testStream Format]
 set tempFile stdout
 
 $testFormat Type 22
 $testStream Format $testFormat
 
 $testStream Open stdout 3 False
 
 $voice AudioOutputStream $testStream
 
 $voice Speak "This is a test of directoutput" 0 
 
 
