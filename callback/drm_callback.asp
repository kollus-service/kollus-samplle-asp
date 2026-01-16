<%@ Language="VBScript" %>
<!-- #include virtual="/lib/webToken.asp" -->
<%
Function GetSafeInt(obj, key, defaultVal)
    On Error Resume Next
    Dim v : v = obj.item(key)
    If Err.Number <> 0 Or IsNull(v) Or v = "" Then
        GetSafeInt = defaultVal
        Err.Clear
    Else
        GetSafeInt = CInt(v)
    End If
    On Error GoTo 0
End Function

Dim securityKey, customKey
Dim itemsJson, items, item
Dim results, dataArr
Dim jwtResult
Dim i

' Configuration
securityKey = "{SERVICE_ACCOUNT_KEY}"
customKey = "{CUSTOM_KEY}"

' Get POST parameters
itemsJson = Request.Form("items")

' Initialize result object using jsObject style
Set results = jsObject()
Set dataArr = jsArray()

' Parse items JSON array
If itemsJson <> "" Then
    Set items = JSON.parse(itemsJson)

    ' Loop through items array
    For i = 0 To items.length - 1
        Set item = items.get(i)

        Dim kind, clientUserId, mediaContentKey, startAt
        Dim callbackResult
        Dim itemResulta

        ' Get item properties
        kind = 0
        If Not IsNull(item.kind) Then kind = CInt(item.kind)
        clientUserId = item.client_user_id
        mediaContentKey = item.media_content_key
		startAt = GetSafeInt(item, "start_at", 0)

        callbackResult = True

        ' Build item result
        Set itemResult = jsObject()
        If callbackResult Then
            itemResult("result") = 1
        Else
            itemResult("result") = 0
        End If
        itemResult("media_content_key") = mediaContentKey

        Select Case kind
            Case 1
                itemResult("kind") = 1
                ' itemResult("expiration_count") = 0

                If Not callbackResult Then
                    itemResult("message") = "This video is not permitted to you"	'커스텀 메세지
                End If

            Case 2
                itemResult("kind") = 2

                If Not callbackResult Then
                    itemResult("message") = "This video is not permitted to you"	'커스텀 메세지
                End If

            Case 3
                itemResult("kind") = 3
                itemResult("start_at") = startAt
                ' itemResult("expiration_count") = 0

                If Not callbackResult Then
                    itemResult("message") = "This video is not permitted to you"	'커스텀 메세지
                End If
        End Select

        ' Add item result to data array
		Set dataArr(Null) = itemResult
        Set itemResult = Nothing
    Next

    Set items = Nothing
End If

' Generate JWT token using jsObject style
Set results("data") = dataArr
jwtResult = createCallbackToken(results, securityKey)

' Set response headers
Response.ContentType = "text/plain"
Response.Charset = "utf-8"
Response.AddHeader "X-Kollus-UserKey", customKey

' Output JWT result
Response.Write jwtResult

' Cleanup
Set dataArr = Nothing
Set results = Nothing
%>
