<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset = "utf-8"
Response.ContentType = "application/json; charset=utf-8"

` http://{도메인}/{Path}?json_data={JSON_DATA}&client_user_id={CLIENT_USER_ID}&start_at={START_AT}&uservalue0={USERVALUE0}
` 위와 같이 kollus 콘솔에서 채널에 LMS Callback 설정 기준
` 기본적으로 json_data 데이터 내 모든 LMS 데이터 포함되어 있으나, JSON 파싱 없이 사용 시 LMS Callback 호출 시 파라미터 추가로 별도 전달 받을 수 있음.

' LMS Callback 파라미터
Dim json_data
Dim client_user_id
Dim start_at
Dim uservalue0

json_data = Request("json_data")

client_user_id = Request("client_user_id")
start_at = Request("start_at")
uservalue0 = Request("uservalue0")

' 출력 (디버깅용)
Response.Write "json_data: " & json_data & vbCrLf
Response.Write "client_user_id: " & client_user_id & vbCrLf
Response.Write "start_at: " & start_at& vbCrLf
Response.Write "uservalue0: " & uservalue0& vbCrLf

' 전달받은 Callback 이용한 로직 처리...

%>
