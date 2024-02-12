﻿; Generated by kalamine on 2024-02-12

#NoEnv
#Persistent
#InstallKeybdHook
#SingleInstance,       force
#MaxThreadsBuffer
#MaxThreadsPerHotKey   3
#MaxHotkeysPerInterval 300
#MaxThreads            20

SendMode Event ; either Event or Input
SetKeyDelay,   -1
SetBatchLines, -1
Process, Priority, , R
SetWorkingDir, %A_ScriptDir%
StringCaseSense, On


;-------------------------------------------------------------------------------
; On/Off Switch
;-------------------------------------------------------------------------------

global Active := True

HideTrayTip() {
  TrayTip  ; Attempt to hide it the normal way.
  if SubStr(A_OSVersion,1,3) = "10." {
    Menu Tray, NoIcon
    Sleep 200  ; It may be necessary to adjust this sleep.
    Menu Tray, Icon
  }
}

ShowTrayTip() {
  title := "Colemak French Touch"
  text := Active ? "ON" : "OFF"
  HideTrayTip()
  TrayTip, %title% , %text%, 1, 0x31
  SetTimer, HideTrayTip, -1500
}

RAlt & Alt::
Alt & RAlt::
  global Active
  Active := !Active
  ShowTrayTip()
  return

#If Active
SetTimer, ShowTrayTip, -1000  ; not working


;-------------------------------------------------------------------------------
; DeadKey Helpers
;-------------------------------------------------------------------------------

global DeadKey := ""

; Check CapsLock status, upper the char if needed and send the char
SendChar(char) {
  if % GetKeyState("CapsLock", "T") {
    if (StrLen(char) == 6) {
      ; we have something in the form of `U+NNNN `
      ; Change it to 0xNNNN so it can be passed to `Chr` function
      char := Chr("0x" SubStr(char, 3, 4))
    }
    StringUpper, char, char
  }
  Send, {%char%}
}

DoTerm(base:="") {
  global DeadKey

  term := SubStr(DeadKey, 2, 1)

  Send, {%term%}
  SendChar(base)
  DeadKey := ""
}

DoAction(action:="") {
  global DeadKey

  if (action == "U+0020") {
    Send, {SC39}
    DeadKey := ""
  }
  else if (StrLen(action) != 2) {
    SendChar(action)
    DeadKey := ""
  }
  else if (action == DeadKey) {
    DoTerm(SubStr(DeadKey, 2, 1))
  }
  else {
    DeadKey := action
  }
}

SendKey(base, deadkeymap) {
  if (!DeadKey) {
    DoAction(base)
  }
  else if (deadkeymap.HasKey(DeadKey)) {
    DoAction(deadkeymap[DeadKey])
  }
  else {
    DoTerm(base)
  }
}


;-------------------------------------------------------------------------------
; Base
;-------------------------------------------------------------------------------

;  Digits

 SC02::SendKey("U+0031", {"*^": "U+00b9"}) ; 1
+SC02::SendKey("U+20ac", {}) ; €

 SC03::SendKey("U+0032", {"*^": "U+00b2"}) ; 2
+SC03::SendKey("U+0040", {}) ; @

 SC04::SendKey("U+0033", {"*^": "U+00b3"}) ; 3
+SC04::SendKey("U+0023", {}) ; #

 SC05::SendKey("U+0034", {"*^": "U+2074"}) ; 4
+SC05::SendKey("U+0024", {}) ; $

 SC06::SendKey("U+0035", {"*^": "U+2075"}) ; 5
+SC06::SendKey("U+0025", {}) ; %

 SC07::SendKey("U+0036", {"*^": "U+2076"}) ; 6
+SC07::SendKey("U+005e", {}) ; ^

 SC08::SendKey("U+0037", {"*^": "U+2077"}) ; 7
+SC08::SendKey("U+0026", {}) ; &

 SC09::SendKey("U+0038", {"*^": "U+2078"}) ; 8
+SC09::SendKey("U+002a", {}) ; *

 SC0a::SendKey("U+0039", {"*^": "U+2079"}) ; 9
+SC0a::SendKey("U+00ab", {}) ; «

 SC0b::SendKey("U+0030", {"**": "U+00b0", "*^": "U+2070"}) ; 0
+SC0b::SendKey("U+00bb", {}) ; »

;  Letters, first row

 SC10::SendKey("U+0071", {}) ; q
+SC10::SendKey("U+0051", {}) ; Q

 SC11::SendKey("U+0077", {"*``": "U+1e81", "*´": "U+1e83", "*^": "U+0175", "*¨": "U+1e85", "*¤": "U+20a9"}) ; w
+SC11::SendKey("U+0057", {"*``": "U+1e80", "*´": "U+1e82", "*^": "U+0174", "*¨": "U+1e84", "*¤": "U+20a9"}) ; W

 SC12::SendKey("U+0066", {"**": "U+00e0", "*¤": "U+0192"}) ; f
+SC12::SendKey("U+0046", {"**": "U+00c0", "*¤": "U+20a3"}) ; F

 SC13::SendKey("U+0070", {"**": "U+00f9", "*´": "U+1e55", "*/": "U+1d7d", "*¤": "U+20b0"}) ; p
+SC13::SendKey("U+0050", {"**": "U+00d9", "*´": "U+1e54", "*/": "U+2c63", "*¤": "U+20a7"}) ; P

 SC14::SendKey("U+0067", {"*´": "U+01f5", "*^": "U+011d", "*¸": "U+0123", "*/": "U+01e5", "*¤": "U+20b2"}) ; g
+SC14::SendKey("U+0047", {"*´": "U+01f4", "*^": "U+011c", "*¸": "U+0122", "*/": "U+01e4", "*¤": "U+20b2"}) ; G

 SC15::SendKey("U+006a", {"*^": "U+0135", "*/": "U+0249"}) ; j
+SC15::SendKey("U+004a", {"*^": "U+0134", "*/": "U+0248"}) ; J

 SC16::SendKey("U+006c", {"**": "U+0153", "*´": "U+013a", "*¸": "U+013c", "*/": "U+0142", "*¤": "U+00a3"}) ; l
+SC16::SendKey("U+004c", {"**": "U+0152", "*´": "U+0139", "*¸": "U+013b", "*/": "U+0141", "*¤": "U+20a4"}) ; L

 SC17::SendKey("U+006f", {"**": "U+00f4", "*``": "U+00f2", "*´": "U+00f3", "*^": "U+00f4", "*~": "U+00f5", "*¨": "U+00f6", "*/": "U+00f8", "*¤": "U+0bf9"}) ; o
+SC17::SendKey("U+004f", {"**": "U+00d4", "*``": "U+00d2", "*´": "U+00d3", "*^": "U+00d4", "*~": "U+00d5", "*¨": "U+00d6", "*/": "U+00d8", "*¤": "U+0af1"}) ; O

 SC18::SendKey("**", {"**": "*¨"})
+SC18::SendKey("U+0021", {}) ; !

 SC19::SendKey("U+0079", {"**": "U+00ee", "*``": "U+1ef3", "*´": "U+00fd", "*^": "U+0177", "*~": "U+1ef9", "*¨": "U+00ff", "*/": "U+024f", "*¤": "U+00a5"}) ; y
+SC19::SendKey("U+0059", {"**": "U+00ce", "*``": "U+1ef2", "*´": "U+00dd", "*^": "U+0176", "*~": "U+1ef8", "*¨": "U+0178", "*/": "U+024e", "*¤": "U+5186"}) ; Y

;  Letters, second row

 SC1e::SendKey("U+0061", {"**": "U+00e2", "*``": "U+00e0", "*´": "U+00e1", "*^": "U+00e2", "*~": "U+00e3", "*¨": "U+00e4", "*/": "U+2c65", "*¤": "U+060b"}) ; a
+SC1e::SendKey("U+0041", {"**": "U+00c2", "*``": "U+00c0", "*´": "U+00c1", "*^": "U+00c2", "*~": "U+00c3", "*¨": "U+00c4", "*/": "U+023a", "*¤": "U+20b3"}) ; A

 SC1f::SendKey("U+0072", {"**": "U+00e9", "*´": "U+0155", "*¸": "U+0157", "*/": "U+024d", "*¤": "U+20a2"}) ; r
+SC1f::SendKey("U+0052", {"**": "U+00c9", "*´": "U+0154", "*¸": "U+0156", "*/": "U+024c", "*¤": "U+20a8"}) ; R

 SC20::SendKey("U+0073", {"**": "U+00e8", "*´": "U+015b", "*^": "U+015d", "*¸": "U+015f", "*¤": "U+20aa"}) ; s
+SC20::SendKey("U+0053", {"**": "U+00c8", "*´": "U+015a", "*^": "U+015c", "*¸": "U+015e", "*¤": "U+0024"}) ; S

 SC21::SendKey("U+0074", {"**": "U+002d", "*¨": "U+1e97", "*¸": "U+0163", "*/": "U+0167", "*¤": "U+09f3"}) ; t
+SC21::SendKey("U+0054", {"*¸": "U+0162", "*/": "U+0166", "*¤": "U+20ae"}) ; T

 SC22::SendKey("U+0064", {"**": "U+2013", "*¸": "U+1e11", "*/": "U+0111", "*¤": "U+20ab"}) ; d
+SC22::SendKey("U+0044", {"*¸": "U+1e10", "*/": "U+0110", "*¤": "U+20af"}) ; D

 SC23::SendKey("U+006d", {"*´": "U+1e3f", "*¤": "U+20a5"}) ; m
+SC23::SendKey("U+004d", {"*´": "U+1e3e", "*¤": "U+2133"}) ; M

 SC24::SendKey("U+006e", {"*``": "U+01f9", "*´": "U+0144", "*~": "U+00f1", "*¸": "U+0146", "*¤": "U+20a6"}) ; n
+SC24::SendKey("U+004e", {"*``": "U+01f8", "*´": "U+0143", "*~": "U+00d1", "*¸": "U+0145", "*¤": "U+20a6"}) ; N

 SC25::SendKey("U+0065", {"**": "U+00ea", "*``": "U+00e8", "*´": "U+00e9", "*^": "U+00ea", "*~": "U+1ebd", "*¨": "U+00eb", "*¸": "U+0229", "*/": "U+0247", "*¤": "U+20ac"}) ; e
+SC25::SendKey("U+0045", {"**": "U+00ca", "*``": "U+00c8", "*´": "U+00c9", "*^": "U+00ca", "*~": "U+1ebc", "*¨": "U+00cb", "*¸": "U+0228", "*/": "U+0246", "*¤": "U+20a0"}) ; E

 SC26::SendKey("U+0069", {"*``": "U+00ec", "*´": "U+00ed", "*^": "U+00ee", "*~": "U+0129", "*¨": "U+00ef", "*/": "U+0268", "*¤": "U+fdfc"}) ; i
+SC26::SendKey("U+0049", {"*``": "U+00cc", "*´": "U+00cd", "*^": "U+00ce", "*~": "U+0128", "*¨": "U+00cf", "*/": "U+0197", "*¤": "U+17db"}) ; I

 SC27::SendKey("U+0075", {"**": "U+00fb", "*``": "U+00f9", "*´": "U+00fa", "*^": "U+00fb", "*~": "U+0169", "*¨": "U+00fc", "*/": "U+0289", "*¤": "U+5143"}) ; u
+SC27::SendKey("U+0055", {"**": "U+00db", "*``": "U+00d9", "*´": "U+00da", "*^": "U+00db", "*~": "U+0168", "*¨": "U+00dc", "*/": "U+0244", "*¤": "U+5713"}) ; U

;  Letters, third row

 SC2c::SendKey("U+007a", {"**": "U+00e6", "*´": "U+017a", "*^": "U+1e91", "*/": "U+01b6"}) ; z
+SC2c::SendKey("U+005a", {"**": "U+00c6", "*´": "U+0179", "*^": "U+1e90", "*/": "U+01b5"}) ; Z

 SC2d::SendKey("U+0078", {"*¨": "U+1e8d"}) ; x
+SC2d::SendKey("U+0058", {"*¨": "U+1e8c"}) ; X

 SC2e::SendKey("U+0063", {"**": "U+00e7", "*´": "U+0107", "*^": "U+0109", "*¸": "U+00e7", "*/": "U+023c", "*¤": "U+00a2"}) ; c
+SC2e::SendKey("U+0043", {"**": "U+00c7", "*´": "U+0106", "*^": "U+0108", "*¸": "U+00c7", "*/": "U+023b", "*¤": "U+20a1"}) ; C

 SC2f::SendKey("U+0076", {"**": "U+005f", "*~": "U+1e7d"}) ; v
+SC2f::SendKey("U+0056", {"**": "U+005f", "*~": "U+1e7c"}) ; V

 SC30::SendKey("U+0062", {"**": "U+2014", "*/": "U+0180", "*¤": "U+0e3f"}) ; b
+SC30::SendKey("U+0042", {"*/": "U+0243", "*¤": "U+20b1"}) ; B

 SC31::SendKey("U+006b", {"**": "U+201c", "*´": "U+1e31", "*¸": "U+0137", "*¤": "U+20ad"}) ; k
+SC31::SendKey("U+004b", {"*´": "U+1e30", "*¸": "U+0136", "*¤": "U+20ad"}) ; K

 SC32::SendKey("U+0068", {"**": "U+201d", "*^": "U+0125", "*¨": "U+1e27", "*¸": "U+1e29", "*/": "U+0127", "*¤": "U+20b4"}) ; h
+SC32::SendKey("U+0048", {"*^": "U+0124", "*¨": "U+1e26", "*¸": "U+1e28", "*/": "U+0126", "*¤": "U+20b4"}) ; H

 SC33::SendKey("U+002f", {"**": "U+2026"}) ; /
+SC33::SendKey("U+003f", {}) ; ?

 SC34::SendKey("U+002c", {}) ; ,
+SC34::SendKey("U+003b", {}) ; ;

 SC35::SendKey("U+002e", {"**": "U+00b7"}) ; .
+SC35::SendKey("U+003a", {"**": "U+2022"}) ; :

;  Pinky keys

 SC0c::SendKey("U+002d", {"*^": "U+207b"}) ; -
+SC0c::SendKey("U+005f", {}) ; _

 SC0d::SendKey("U+003d", {"*^": "U+207c", "*~": "U+2243", "*/": "U+2260"}) ; =
+SC0d::SendKey("U+002b", {"*^": "U+207a"}) ; +

 SC1a::SendKey("U+005b", {}) ; [
+SC1a::SendKey("U+007b", {}) ; {

 SC1b::SendKey("U+005d", {}) ; ]
+SC1b::SendKey("U+007d", {}) ; }

 SC28::SendKey("U+0027", {}) ; '
+SC28::SendKey("U+0022", {}) ; "

 SC29::SendKey("U+0060", {}) ; `
+SC29::SendKey("U+007e", {}) ; ~

 SC2b::SendKey("U+005c", {}) ; \
+SC2b::SendKey("U+007c", {}) ; |

 SC56::SendKey("U+003c", {"*~": "U+2272", "*/": "U+226e"}) ; <
+SC56::SendKey("U+003e", {"*~": "U+2273", "*/": "U+226f"}) ; >

;  Space bar

 SC39::SendKey("U+0020", {"**": "U+2019", "*``": "U+0060", "*´": "U+0027", "*^": "U+005e", "*~": "U+007e", "*¨": "U+0022", "*¸": "U+00b8", "*/": "U+002f", "*¤": "U+00a4"}) ;  
+SC39::SendKey("U+202f", {"**": "U+2019", "*``": "U+0060", "*´": "U+0027", "*^": "U+005e", "*~": "U+007e", "*¨": "U+0022", "*¸": "U+00b8", "*/": "U+002f", "*¤": "U+00a4"}) ;  


;-------------------------------------------------------------------------------
; AltGr
;-------------------------------------------------------------------------------

;  Digits

 <^>!SC02::SendKey("U+2081", {}) ; ₁
<^>!+SC02::SendKey("U+00b9", {}) ; ¹

 <^>!SC03::SendKey("U+2082", {}) ; ₂
<^>!+SC03::SendKey("U+00b2", {}) ; ²

 <^>!SC04::SendKey("U+2083", {}) ; ₃
<^>!+SC04::SendKey("U+00b3", {}) ; ³

 <^>!SC05::SendKey("U+2084", {}) ; ₄
<^>!+SC05::SendKey("U+2074", {}) ; ⁴

 <^>!SC06::SendKey("U+2085", {}) ; ₅
<^>!+SC06::SendKey("U+2075", {}) ; ⁵

 <^>!SC07::SendKey("U+2086", {}) ; ₆
<^>!+SC07::SendKey("U+2076", {}) ; ⁶

 <^>!SC08::SendKey("U+2087", {}) ; ₇
<^>!+SC08::SendKey("U+2077", {}) ; ⁷

 <^>!SC09::SendKey("U+2088", {}) ; ₈
<^>!+SC09::SendKey("U+2078", {}) ; ⁸

 <^>!SC0a::SendKey("U+2089", {}) ; ₉
<^>!+SC0a::SendKey("U+2079", {}) ; ⁹

 <^>!SC0b::SendKey("U+2080", {}) ; ₀
<^>!+SC0b::SendKey("U+2070", {}) ; ⁰

;  Letters, first row

 <^>!SC10::SendKey("U+0040", {}) ; @

 <^>!SC11::SendKey("U+003c", {"*~": "U+2272", "*/": "U+226e"}) ; <
<^>!+SC11::SendKey("U+2264", {"*/": "U+2270"}) ; ≤

 <^>!SC12::SendKey("U+003e", {"*~": "U+2273", "*/": "U+226f"}) ; >
<^>!+SC12::SendKey("U+2265", {"*/": "U+2271"}) ; ≥

 <^>!SC13::SendKey("U+0024", {}) ; $
<^>!+SC13::SendKey("*¤", {"*¤": "¤"})

 <^>!SC14::SendKey("U+0025", {}) ; %
<^>!+SC14::SendKey("U+2030", {}) ; ‰

 <^>!SC15::SendKey("U+005e", {}) ; ^
<^>!+SC15::SendKey("*^", {"*^": "^"})

 <^>!SC16::SendKey("U+0026", {}) ; &

 <^>!SC17::SendKey("U+002a", {}) ; *
<^>!+SC17::SendKey("U+00d7", {}) ; ×

 <^>!SC18::SendKey("U+0027", {}) ; '
<^>!+SC18::SendKey("*´", {"*´": "´"})

 <^>!SC19::SendKey("U+0060", {}) ; `
<^>!+SC19::SendKey("*``", {"*``": "`"}) ; *`

;  Letters, second row

 <^>!SC1e::SendKey("U+007b", {}) ; {

 <^>!SC1f::SendKey("U+0028", {"*^": "U+207d"}) ; (
<^>!+SC1f::SendKey("U+207d", {}) ; ⁽

 <^>!SC20::SendKey("U+0029", {"*^": "U+207e"}) ; )
<^>!+SC20::SendKey("U+207e", {}) ; ⁾

 <^>!SC21::SendKey("U+007d", {}) ; }

 <^>!SC22::SendKey("U+003d", {"*^": "U+207c", "*~": "U+2243", "*/": "U+2260"}) ; =
<^>!+SC22::SendKey("U+2260", {}) ; ≠

 <^>!SC23::SendKey("U+005c", {}) ; \
<^>!+SC23::SendKey("*/", {"*/": "/"})

 <^>!SC24::SendKey("U+002b", {"*^": "U+207a"}) ; +
<^>!+SC24::SendKey("U+00b1", {}) ; ±

 <^>!SC25::SendKey("U+002d", {"*^": "U+207b"}) ; -
<^>!+SC25::SendKey("U+2014", {}) ; —

 <^>!SC26::SendKey("U+002f", {"**": "U+2026"}) ; /
<^>!+SC26::SendKey("U+00f7", {}) ; ÷

 <^>!SC27::SendKey("U+0022", {}) ; "
<^>!+SC27::SendKey("*¨", {"*¨": "¨"})

;  Letters, third row

 <^>!SC2c::SendKey("U+007e", {}) ; ~
<^>!+SC2c::SendKey("*~", {"*~": "~"})

 <^>!SC2d::SendKey("U+005b", {}) ; [

 <^>!SC2e::SendKey("U+005d", {}) ; ]

 <^>!SC2f::SendKey("U+005f", {}) ; _
<^>!+SC2f::SendKey("U+2013", {}) ; –

 <^>!SC30::SendKey("U+0023", {}) ; #

 <^>!SC31::SendKey("U+007c", {}) ; |
<^>!+SC31::SendKey("U+00a6", {}) ; ¦

 <^>!SC32::SendKey("U+0021", {}) ; !
<^>!+SC32::SendKey("U+00ac", {}) ; ¬

 <^>!SC33::SendKey("U+003b", {}) ; ;
<^>!+SC33::SendKey("*¸", {"*¸": "¸"})

 <^>!SC34::SendKey("U+003a", {"**": "U+2022"}) ; :

 <^>!SC35::SendKey("U+003f", {}) ; ?

;  Pinky keys

;  Space bar

 <^>!SC39::SendKey("U+0020", {"**": "U+2019", "*``": "U+0060", "*´": "U+0027", "*^": "U+005e", "*~": "U+007e", "*¨": "U+0022", "*¸": "U+00b8", "*/": "U+002f", "*¤": "U+00a4"}) ;  
<^>!+SC39::SendKey("U+00a0", {"**": "U+2019", "*``": "U+0060", "*´": "U+0027", "*^": "U+005e", "*~": "U+007e", "*¨": "U+0022", "*¸": "U+00b8", "*/": "U+002f", "*¤": "U+00a4"}) ;  

; Special Keys

$<^>!Esc::       Send {SC01}
$<^>!End::       Send {SC4f}
$<^>!Home::      Send {SC47}
$<^>!Delete::    Send {SC53}
$<^>!Backspace:: Send {SC0e}


;-------------------------------------------------------------------------------
; Ctrl
;-------------------------------------------------------------------------------

;  Digits

;  Letters, first row

 ^SC10::Send  ^q
^+SC10::Send ^+Q

 ^SC11::Send  ^w
^+SC11::Send ^+W

 ^SC12::Send  ^f
^+SC12::Send ^+F

 ^SC13::Send  ^p
^+SC13::Send ^+P

 ^SC14::Send  ^g
^+SC14::Send ^+G

 ^SC15::Send  ^j
^+SC15::Send ^+J

 ^SC16::Send  ^l
^+SC16::Send ^+L

 ^SC17::Send  ^o
^+SC17::Send ^+O

 ^SC19::Send  ^y
^+SC19::Send ^+Y

;  Letters, second row

 ^SC1e::Send  ^a
^+SC1e::Send ^+A

 ^SC1f::Send  ^r
^+SC1f::Send ^+R

 ^SC20::Send  ^s
^+SC20::Send ^+S

 ^SC21::Send  ^t
^+SC21::Send ^+T

 ^SC22::Send  ^d
^+SC22::Send ^+D

 ^SC23::Send  ^m
^+SC23::Send ^+M

 ^SC24::Send  ^n
^+SC24::Send ^+N

 ^SC25::Send  ^e
^+SC25::Send ^+E

 ^SC26::Send  ^i
^+SC26::Send ^+I

 ^SC27::Send  ^u
^+SC27::Send ^+U

;  Letters, third row

 ^SC2c::Send  ^z
^+SC2c::Send ^+Z

 ^SC2d::Send  ^x
^+SC2d::Send ^+X

 ^SC2e::Send  ^c
^+SC2e::Send ^+C

 ^SC2f::Send  ^v
^+SC2f::Send ^+V

 ^SC30::Send  ^b
^+SC30::Send ^+B

 ^SC31::Send  ^k
^+SC31::Send ^+K

 ^SC32::Send  ^h
^+SC32::Send ^+H

;  Pinky keys

;  Space bar

