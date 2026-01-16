<!-- #include file="JSON_2.0.4.asp" -->
<!-- #include file="JSON_UTIL_0.0.1.asp" -->
<%

sBASE_64_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

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

Function createWebtoken(media_content_key, client_user_id, expire_time, customKey, service_account_key)
Dim Payload, mc, JWTHead
Set JWTHead = jsObject()
JWTHead("typ") = "JWT"
JWTHead("alg") = "HS256"
Set Payload = jsObject()
Payload("expt") = expire_time
Payload("cuid") = client_user_id
'Payload("playback_rates") = playbackRates

'mck_length = Ubound(media_content_key)
'Dim temp()
'ReDim temp(mck_length)
Payload("mc") = media_content_key

tmp = Base64ToSafeBase64(tmp)
tmp = Base64encode(toJSON(JWTHead)) + "." + Base64encode(toJSON(Payload))
'tmp = Base64ToSafeBase64(tmp)
Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0

Dim Return : result = ""

result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = Server.URLEncode(result)
result = tmp+"."+result
createWebtoken = result
End Function

Function createWebtoken_next(media_content_key, client_user_id, expire_time, customKey, service_account_key)
Dim Payload, mc, JWTHead
Set JWTHead = jsObject()
JWTHead("typ") = "JWT"
JWTHead("alg") = "HS256"
Set Payload = jsObject()
Payload("expt") = expire_time
Payload("cuid") = client_user_id
Payload("next_episode") = true
'Payload("playback_rates") = playbackRates

'mck_length = Ubound(media_content_key)
'Dim temp()
'ReDim temp(mck_length)
Payload("mc") = media_content_key

tmp = Base64ToSafeBase64(tmp)
tmp = Base64encode(toJSON(JWTHead)) + "." + Base64encode(toJSON(Payload))
'tmp = Base64ToSafeBase64(tmp)
Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0

Dim Return : result = ""

result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = Server.URLEncode(result)
result = tmp+"."+result
createWebtoken_next = result
End Function

Function createWebtoken_playback(media_content_key, client_user_id, expire_time, customKey, service_account_key,playbackRates)
Dim Payload, mc, JWTHead
Set JWTHead = jsObject()
JWTHead("typ") = "JWT"
JWTHead("alg") = "HS256"
Set Payload = jsObject()
Payload("expt") = expire_time
Payload("cuid") = client_user_id
Payload("playback_rates") = playbackRates

'mck_length = Ubound(media_content_key)
'Dim temp()
'ReDim temp(mck_length)
Payload("mc") = media_content_key

tmp = Base64ToSafeBase64(tmp)
tmp = Base64encode(toJSON(JWTHead)) + "." + Base64encode(toJSON(Payload))
'tmp = Base64ToSafeBase64(tmp)
Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0

Dim Return : result = ""

result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = Server.URLEncode(result)
result = tmp+"."+result
createWebtoken_playback = result
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
createWebtoken_callback = result
End Function

Function createWebtokenForCallback(results, service_account_key)
Set JWTHead = New JSONobject
JWTHead.add "typ", "JWT"
JWTHead.add "alg", "HS256"
tmp = Base64encode(JWTHead.Serialize()) + "." + Base64encode(results.Serialize())
Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("lib/sha256.wsc") )
sha256.hexcase = 0
Dim result : result = ""
result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = tmp+"."+result
createWebtokenForCallback = result
End Function

Function createCallbackToken(results, service_account_key)
Dim JWTHead, tmp, sha256, result
Set JWTHead = jsObject()
JWTHead("typ") = "JWT"
JWTHead("alg") = "HS256"
tmp = Base64encode(toJSON(JWTHead)) + "." + Base64encode(toJSON(results))
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0
result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = tmp + "." + result
createCallbackToken = result
End Function

Function createWebtoken2(media_content_key, client_user_id, expire_time, customKey, service_account_key)
Dim Payload, mc, JWTHead
Set JWTHead = jsObject()
JWTHead("typ") = "JWT"
JWTHead("alg") = "HS256"
Set Payload = jsObject()
Payload("expt") = expire_time
Payload("cuid") = client_user_id

Payload("mc") = media_content_key

tmp = Base64encode(toJSON(JWTHead)) + "." + Base64encode(toJSON(Payload))

Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0

Dim Return : result = ""

result = sha256.b64_hmac_sha256(service_account_key, tmp)

result = tmp+"."+result
createWebtoken2 = result
End Function

Function createWebtoken_skin(media_content_key, client_user_id, expire_time, skin_path, skin_sha1sum, customKey, service_account_key)
Dim Payload, mc, JWTHead
Set JWTHead = jsObject()
JWTHead("typ") = "JWT"
JWTHead("alg") = "HS256"
Set Payload = jsObject()
Payload("expt") = expire_time
Payload("cuid") = client_user_id
Set skinInfo = jsObject()
skinInfo("skin_path") = skin_path
skinInfo("skin_sha1sum") = skin_sha1sum
'mck_length = Ubound(media_content_key)
'Dim temp()
'ReDim temp(mck_length)
Payload("mc") = media_content_key
Set Payload("pc_skin") = skinInfo
tmp = Base64encode(toJSON(JWTHead)) + "." + Base64encode(toJSON(Payload))

Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0

Dim Return : result = ""

result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = Server.URLEncode(result)
result = tmp+"."+result
createWebtoken_skin = result
End Function


Function createWebtoken_live(lmckey, client_user_id, expire_time, service_account_key, title)
Dim Payload, mc, JWTHead
Set JWTHead = jsObject()
JWTHead("typ") = "JWT"
JWTHead("alg") = "HS256"
Set Payload = jsObject()
Payload("expt") = expire_time
Payload("cuid") = client_user_id
Payload("lmckey") = lmckey
Payload("title") = title
tmp = Base64encode(toJSON(JWTHead)) + "." + Base64encode(toJSON(Payload))
tmp = Base64ToSafeBase64(tmp)
Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0

Dim Return : result = ""
result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = Server.URLEncode(result)
result = tmp+"."+result
createWebtoken_live = result
End Function



Function createWebtoken_vwc(media_content_key, client_user_id, expire_time, customKey, service_account_key, font_size, font_color, show_time, hide_time, alpha)
Dim Payload, mc, JWTHead, vwc
Set JWTHead = jsObject()
JWTHead("typ") = "JWT"
JWTHead("alg") = "HS256"
Set Payload = jsObject()
Payload("expt") = expire_time
Payload("cuid") = client_user_id
Payload("mc") = media_content_key


Set vwc = jsObject()
vwc("font_size") = font_size
vwc("font_color") = font_color
vwc("show_time") = show_time
vwc("hide_time") = hide_time
vwc("alpha") = alpha
vwc("enable_html5_player") = true
Set Payload("video_watermarking_code_policy") = vwc

tmp = Base64encode(toJSON(JWTHead)) + "." + Base64encode(toJSON(Payload))

Dim sha256
Set sha256 = GetObject( "script:" & Server.MapPath("/lib/sha256.wsc") )
sha256.hexcase = 0

Dim Return : result = ""

result = sha256.b64_hmac_sha256(service_account_key, tmp)
result = Server.URLEncode(result)
result = tmp+"."+result
createWebtoken_vwc = result
End Function

%>
