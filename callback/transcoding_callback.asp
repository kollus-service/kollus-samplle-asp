<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/plain; charset=utf-8"

' Kollus 트랜스코딩 완료 Callback 파라미터
Dim content_provider_key, filename, upload_file_key, transcoding_result

content_provider_key    = Request.Form("content_provider_key")
filename                = Request.Form("filename")
upload_file_key         = Request.Form("upload_file_key")
transcoding_result      = Request.Form("transcoding_result")

' 출력 (디버깅용)
Response.Write "OK" & vbCrLf
Response.Write "content_provider_key: " & content_provider_key & vbCrLf
Response.Write "filename: " & filename & vbCrLf
Response.Write "upload_file_key: " & upload_file_key & vbCrLf
Response.Write "transcoding_result: " & transcoding_result & vbCrLf

' 전달 받은 Callback 파라미터를 이용해서 로직 처리...

%>
