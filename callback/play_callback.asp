<%@ Language="VBScript" %>
<!-- #include virtual="/lib/webToken.asp" -->
<%

Dim securityKey, customKey
Dim kind, clientUserId, mediaContentKey
Dim results, dataObj
Dim callbackResult
Dim jwtResult

' Configuration
securityKey = "{SERVICE_ACCOUNT_KEY}"
customKey = "{CUSTOM_KEY}"

' Get POST parameters
kind = Request.Form("kind")
If kind <> "" Then
    kind = CInt(kind)
Else
    kind = 0
End If
clientUserId = Request.Form("client_user_id")
mediaContentKey = Request.Form("media_content_key")

' Initialize result object using jsObject (like createWebtoken style)
Set results = jsObject()
Set dataObj = jsObject()

callbackResult = True

' Process based on kind
Select Case kind
    Case 1
        If callbackResult Then
            dataObj("result") = 1
        Else
            dataObj("result") = 0
        End If
        dataObj("expiration_date") = GetUnixTimestamp() + 60000000 ' Unix timestamp + 60000000
        ' dataObj("expiration_playtime") = 30

        If Not callbackResult Then
            dataObj("message") = "해당 ID는 강의 공유, 양도, 불법거래 등 " & vbLf & "부정사용 행위 사유로 수강정지 조치되었습니다."	'커스텀 메세지
        End If

    Case 3
        If callbackResult Then
            dataObj("result") = 1
        Else
            dataObj("result") = 0
        End If

        If Not callbackResult Then
            dataObj("message") = "해당 ID는 강의 공유, 양도, 불법거래 등 " & vbLf & "부정사용 행위 사유로 수강정지 조치되었습니다."	'커스텀 메세지
        End If
End Select

' Generate JWT token using jsObject style
Set results("data") = dataObj
jwtResult = createCallbackToken(results, securityKey)

' Set response headers
Response.ContentType = "text/plain"
Response.Charset = "utf-8"
Response.AddHeader "X-Kollus-UserKey", customKey

' Output JWT result
Response.Write jwtResult

' Cleanup
Set dataObj = Nothing
Set results = Nothing

' Helper function to get Unix timestamp
Function GetUnixTimestamp()
    Dim d
    d = Now()
    ' Convert to UTC (adjust for your timezone if needed)
    GetUnixTimestamp = DateDiff("s", "01/01/1970 00:00:00", d)
End Function
%>
