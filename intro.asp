<!-- #include virtual="/lib/webToken.asp" -->
<%
expire_time = {EXPIRE_DATE} 'UNIX TIME STAMP
customKey = "{CUSTOM_KEY}" '콜러스 콘솔의 설정 페이지 -> 사용자 키
service_account_key = "{SERVICE_ACCOUNT_KEY}" '콜러스 콘솔의 설정 페이지 -> 보안 키
client_user_id = "{CLIENT_USER_ID}" '홈페이지 사용자 아이디
Dim media_content_keys(1)
Set media_content_key_intro = jsObject()
Set media_content_key = jsObject()
media_content_key_intro("mckey") = "{MEDIA_CONTENT_KEY}" '미디어 컨텐츠 키, 콜러스 콘솔의 채널 페이지 -> 컨텐츠 상세 정보에서 확인
media_content_key_intro("intr") = true '인트로로 사용할 영상이면 true 로 설정
media_content_key("mckey") = "{MEDIA_CONTENT_KEY}" '본영상으로 사용할 미디어 컨텐츠 키
Set media_content_keys(0) = media_content_key_intro
Set media_content_keys(1) = media_content_key
jwt = createWebtoken(media_content_keys, client_user_id, expire_time, customKey, service_account_key)
%>
<!DOCTYPE html>
<html lang="ko">
<body>

<iframe id='player'  src="http://v.kr.kollus.com/s?jwt=<%=jwt%>&custom_key=<%=customKey%>" width="800" height="600" allowfullscreen webkitallowfullscreen mozallowfullscreen allow="autoplay"></iframe>
</body>
</html>
