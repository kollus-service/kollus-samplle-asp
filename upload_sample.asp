<!-- #include virtual="/lib/json2.asp" -->
<%
accessToken = "{ACCESS_TOKEN}"
url = "http://api.kr.kollus.com/0/media_auth/upload/create_url?access_token=" & accessToken
postData="expire_time={EXPIRE_TIME}&title={TITLE}"
Set header = CreateObject("MSXML2.ServerXMLHTTP.3.0")
header.Open "POST", url, False
header.SetRequestHeader "Content-Type", "application/json"
header.Send postData
responseText = header.responseText
Set result = New JSONobject.parse(responseText)
set header = nothing
%>

<html>
<head>
	<meta charset="utf-8" />
	<title>HTTP Upload Endpoint Sample</title>
	<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0,maximum-scale=1.0" />
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script>
function uploadFile(){
	var form = $('#form')[0];
	var formData = new FormData(form);
	formData.append("upload-file", $("#upload-file")[0].files[0]);
	formData.append("accept","application/json");
	$.ajax({
		url: '<%=result("result")("upload_url")%>',
		processData: false,
		contentType: false,
		data: formData,
		type: 'POST',
		success: function(result){
			alert(result.message);
	}
	});
}
</script>
</head>
<body>
<h3>Content Upload</h3>

<form id="form">
	<input type="file" id="upload-file" />
	<input type="hidden" name="redirection_scope" value="outer"/>
 	<input type="button" value="ì—…ë¡œë“œ" onclick="uploadFile();" />
</form>
</body>
</html>
