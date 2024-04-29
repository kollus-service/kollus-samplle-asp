<!-- #include virtual="/lib/webToken.asp" -->
<%
expire_time = {EXPIRE_DATE}
customKey = "{CUSTOM_KEY}"
service_account_key = "{SERVICE_ACCOUNT_KEY}"
client_user_id = "{CLIENT_USER_ID}"
Dim media_content_keys(0)
Set media_content_key1 = jsObject()
media_content_key1("mckey") = "{MEDIA_CONTENT_KEY}"
Set media_content_keys(0) = media_content_key1
jwt = createWebtoken_next(media_content_keys, client_user_id, expire_time, customKey, service_account_key)
%>
<html>

<body>

<iframe width="50%" height="50%" src="https://v.kr.kollus.com/s?jwt=<%=jwt%>&custom_key=<%=customKey%>&purgecache" allowfullscreen="" mozallowfullscreen="" webkitallowfullscreen=""></iframe>
<br>

</body>
</html>
