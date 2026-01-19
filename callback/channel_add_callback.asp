<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/plain; charset=utf-8"

' Kollus 채널 추가 Callback 파라미터
Dim content_provider_key, full_filename, filename, upload_file_key, media_content_key, channel_key, channel_name, profile_key, update_type

content_provider_key = Request.Form("content_provider_key")
full_filename        = Request.Form("full_filename")
filename             = Request.Form("filename")
upload_file_key      = Request.Form("upload_file_key")
media_content_key    = Request.Form("media_content_key")
channel_key          = Request.Form("channel_key")
channel_name         = Request.Form("channel_name")
profile_key          = Request.Form("profile_key")
update_type          = Request.Form("update_type")



' 출력 (디버깅용)
Response.Write "OK" & vbCrLf
Response.Write "content_provider_key: " & content_provider_key & vbCrLf
Response.Write "full_filename: " & full_filename & vbCrLf
Response.Write "filename: " & filename & vbCrLf
Response.Write "upload_file_key: " & upload_file_key & vbCrLf
Response.Write "media_content_key: " & media_content_key & vbCrLf
Response.Write "channel_key: " & channel_key & vbCrLf
Response.Write "channel_name: " & channel_name & vbCrLf
Response.Write "profile_key: " & profile_key & vbCrLf
Response.Write "update_type: " & update_type & vbCrLf

' 전달 받은 Callback 파라미터를 이용해서 로직 처리...

%>
