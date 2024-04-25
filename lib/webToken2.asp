<!-- #include virtual="/lib/json2.asp" -->
<%

Const sBASE_64_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" 

function Base64encode(ByVal asContents)
        Dim lnPosition
        Dim lsResult
        Dim Char1
        Dim Char2
        Dim Char3
        Dim Char4
        Dim Byte1
        Dim Byte2
        Dim Byte3
        Dim SaveBits1
        Dim SaveBits2
        Dim lsGroupBinary
        Dim lsGroup64

        if Len(asContents) Mod 3 > 0 Then _
        asContents = asContents & String(3 - (Len(asContents) Mod 3), " ")
        lsResult = ""

        For lnPosition = 1 To Len(asContents) Step 3
               lsGroup64 = ""
               lsGroupBinary = Mid(asContents, lnPosition, 3)

               Byte1 = Asc(Mid(lsGroupBinary, 1, 1)): SaveBits1 = Byte1 And 3
               Byte2 = Asc(Mid(lsGroupBinary, 2, 1)): SaveBits2 = Byte2 And 15
               Byte3 = Asc(Mid(lsGroupBinary, 3, 1))

               Char1 = Mid(sBASE_64_CHARACTERS, ((Byte1 And 252) \ 4) + 1, 1)
               Char2 = Mid(sBASE_64_CHARACTERS, (((Byte2 And 240) \ 16) Or _
               (SaveBits1 * 16) And &HFF) + 1, 1)
               Char3 = Mid(sBASE_64_CHARACTERS, (((Byte3 And 192) \ 64) Or _
               (SaveBits2 * 4) And &HFF) + 1, 1)
               Char4 = Mid(sBASE_64_CHARACTERS, (Byte3 And 63) + 1, 1)
               lsGroup64 = Char1 & Char2 & Char3 & Char4

               lsResult = lsResult + lsGroup64
         Next

         Base64encode = lsResult
End Function

Function Base64ToSafeBase64(sIn)
  sOut = Replace(sIn,"+","-")
  sOut = Replace(sOut,"/","_")
  sOut = Replace(sOut,"\r","")
  sOut = Replace(sOut,"\n","")
  sOut = Replace(sOut,"=","")
  Base64ToSafeBase64 = sOut
End Function


Function createWebtoken_callback(service_account_key, results)
Set JWTHead = New JSONobject	
JWTHead.add "typ", "JWT"
JWTHead.add "alg", "HS256"
set JSON = New JSONobject
tmp = Base64encode(JWTHead.Serialize()) + "." + Base64encode(results.Serialize())
Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0
Dim Return : result = ""
result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = tmp+"."+result
createWebtoken2 = result
End Function

%>
