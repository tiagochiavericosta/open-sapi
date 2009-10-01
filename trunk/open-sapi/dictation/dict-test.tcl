package require tcom


proc voiceEvent {StreamNumber StreamPosition RecognitionType Result} {
#    puts "$StreamNumber\n $StreamPosition \n $RecognitionType \n $Result"
    set result [$Result PhraseInfo]
    puts [$result GetText]
}

set recoContext [::tcom::ref createobject Sapi.SpSharedRecoContext]

set grammar [$recoContext CreateGrammar 1]

$grammar DictationLoad "" 0
$grammar DictationSetState 1


::tcom::bind $recoContext voiceEvent

vwait forever

#Dim WithEvents RecoContext As SpSharedRecoContext
#Dim Grammar As ISpeechRecoGrammar
#Set RecoContext = New SpSharedRecoContext
#Set Grammar = RecoContext.CreateGrammar(1)
#Grammar.DictationLoad
#Grammar.DictationSetState SGDSActive

#' the following is the event handler for the recognition event...
#Private Sub RecoContext_Recognition(ByVal StreamNumber As Long, _
#ByVal StreamPosition As Variant, _
#ByVal RecognitionType As SpeechRecognitionType, _
#ByVal Result As ISpeechRecoResult _
#)
#Dim strText As String

#' put strText in a TextBox, or whatever..
#strText = Result.PhraseInfo.GetText.
#
#End Sub 
