<!-- #include virtual="/lib/webToken.asp" -->
<%
expire_time = 1767139200
service_account_key = ""
client_user_id = ""
customKey = "" 
channelKey = ""
title = ""
jwt = createWebtoken_live(channelKey, client_user_id, expire_time, service_account_key,title)

%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title></title>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0,maximum-scale=1.0" />
    <script src="//code.jquery.com/jquery-1.11.2.min.js"></script>
	<script type="text/javascript">
	$(document).ready(function(){
		$("#poster").click(function(){
			var ua = navigator.userAgent,
			IS_IPAD = ua.match(/iPad/i) != null,
			IS_IPHONE = !IS_IPAD && ((ua.match(/iPhone/i) != null) || (ua.match(/iPod/i) != null)),
			IS_IOS = IS_IPAD || IS_IPHONE,
			IS_ANDROID = !IS_IOS && ua.match(/Android/i) != null,
			IS_BLACKBERRY = ua.match(/BlackBerry/i),
			IS_OPERAMINI = ua.match(/Opera Mini/i),
			IS_WINDOWMOBILE = ua.match(/IEMobile/i),
			IS_MOBILE = IS_IOS || IS_ANDROID || IS_BLACKBERRY || IS_OPERAMINI || IS_WINDOWMOBILE,
			IS_APPABLE = IS_IOS || IS_ANDROID,
			IS_CHROME = ua.match(/Chrome/i),
			IS_CHOME25 = IS_CHROME && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split('/')[1] > 25,
			IS_KITKAT_WEBVIEW = (ua.match(/NAVER/i) != null) || (ua.match(/Daum/i) != null),
			IS_FIREFOX = ua.match(/Firefox/i);
			if (IS_IOS || IS_ANDROID) {
				call_player('path', '<%=jwt%>','<%=customKey%>');
			}
			else{
				$("#child").show();
				$("#poster").hide();
			}
		});
	});

	    function call_player(method, jwt, custom_key) {
	    	var scheme_param = method + '?url=https://v-live-kr.kollus.com/si?jwt=' + jwt+'&custom_key='+custom_key;
	        kollus_custom_scheme_call(scheme_param);
		}

	    function start_downloads() {
	        var chk_info = document.media_form;
	        var count = 0;
	        var url_list = "";

	        for (i = 0; i < chk_info.length; i++) {
	            if (chk_info[i].checked == true) {
	                if (count == 0) {
	                    url_list += "?url=";
	                }
	                if (count > 0) {
	                    url_list += "&url=";
	                }
	                url_list += chk_info[i].value;
	                count += 1;
	            }
	        }

	        if (count == 0) {
	            alert("다운로드 항목을 선택해 주세요.");
	            return;
	        }

	        var scheme_param = 'download' + url_list;
	        kollus_custom_scheme_call(scheme_param);
	    }

	    function kollus_custom_scheme_call(scheme_param) {
			scheme_param = encodeURI(scheme_param);
	    	var this_tag = $(this);
			var ua = navigator.userAgent,
				IS_IPAD = ua.match(/iPad/i) != null,
				IS_MAC = ua.match(/Mac/i) != null,
				IS_IPHONE = !IS_IPAD && ((ua.match(/iPhone/i) != null) || (ua.match(/iPod/i) != null)),
				IS_IOS = IS_IPAD || IS_IPHONE || IS_MAC,
				IS_ANDROID = !IS_IOS && ua.match(/Android/i) != null,
				IS_BLACKBERRY = ua.match(/BlackBerry/i),
				IS_OPERAMINI = ua.match(/Opera Mini/i),
				IS_WINDOWMOBILE = ua.match(/IEMobile/i),
				IS_MOBILE = IS_IOS || IS_ANDROID || IS_BLACKBERRY || IS_OPERAMINI || IS_WINDOWMOBILE,
				IS_APPABLE = IS_IOS || IS_ANDROID,
				IS_CHROME = ua.match(/Chrome/i),
				IS_CHOME25 = IS_CHROME && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split('/')[1] > 25,
				IS_KITKAT_WEBVIEW = (ua.match(/NAVER/i) != null) || (ua.match(/Daum/i) != null),
				IS_FIREFOX = ua.match(/Firefox/i);

			var clicked_at = new Date;

			setTimeout(function () {
				if (new Date - clicked_at < 2000) {
					if (IS_IOS) {
						window.location.href = "https://itunes.apple.com/app/id760006888";
					} else if (IS_ANDROID) {
						window.location.href = 'market://details?id=com.kollus.media';
					}
				}
			}, 1500);

			if (IS_IOS || IS_ANDROID) {
				if (IS_ANDROID && IS_CHOME25) {
					window.location.href = 'intent://' + scheme_param +'&#Intent;package=com.kollus.media;scheme=kollus;end;';
				} else {
					var safari_version = parseFloat(ua.substr(ua.lastIndexOf('Safari/') + 7, 7));

					if (safari_version >= 601.1) {
						window.location.href = 'kollus://' + scheme_param;
					} else {
						var iframe_id = 'kollus_mobile_player_iframe_call';
						if (!$('#' + iframe_id).length) {
							var iframe = $('<iframe id="' + iframe_id + '"/>').hide();
							$('body').append(iframe);
						}
						$('#' + iframe_id).attr('src', 'kollus://' + scheme_param);
					}
				}
			}
			else{
				window.location.href = 'http://127.0.0.1:8388/stream/open?path=' + encodeURIComponent("https://v-live-kr.kollus.com/s?jwt=<%=jwt%>&custom_key=<%=customKey%>");
			}
	    }
	</script>
</head>
<body>
	<p>
		<h3>모바일 전용플레이어 스트리밍 호출(직접호출)</h3>
		<div id="Div4" style="border:solid;">
			<ol>
				<li>
					<a href="javascript:void(0);" onclick="call_player('path', '<%=jwt%>','<%=customKey%>');">Sample1</a>
				</li>
			</ol>
	    </div>
	</p>
<br>
<iframe width="1280" height="720" src="https://v-live-kr.kollus.com/s?jwt=<%=jwt%>&custom_key=<%=customKey%>&uservalue0=asdf&uservalue1=asdfasf" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe><br>
</body>
</html>
