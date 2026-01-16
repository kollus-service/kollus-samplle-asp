<?php
/**
 * base64_urlencode
 *
 * @param string $str
 * @return string
 */
function base64_urlencode($str) {
    return rtrim(strtr(base64_encode($str), '+/', '-_'), '=');
}

/**
 * jwt_encode
 *
 * @param array $payload
 * @param string $key
 * @return string
 */
function jwt_encode($payload, $key) {
    $jwtHead = base64_urlencode(json_encode(array('typ' => 'JWT', 'alg' => 'HS256')));
    $jsonPayload = base64_urlencode(json_encode($payload));
    $signature = base64_urlencode(hash_hmac('SHA256', $jwtHead . '.' . $jsonPayload, $key, true));

    return $jwtHead . '.' . $jsonPayload . '.' . $signature;
}

$securityKey = 'syhan';
$customKey = '7edfba2021137d74594107943dc8366c';

$kind = isset($_POST['kind']) ? (int)$_POST['kind'] : null;
$clientUserId = isset($_POST['client_user_id']) ? $_POST['client_user_id'] : null;
$mediaContentKey = isset($_POST['media_content_key']) ? $_POST['media_content_key'] : null;

$result = array(
    'data' => array()
);

$callbackResult = true;

switch($kind) {
    case 1:
        $result['data']['result'] =  (int)$callbackResult;
        $result['data']['expiration_date'] = time() + 60000000; // 10 min
        // $result['data']['expiration_playtime'] = 30; // 10 min
        // TODO: try more options

        if (!$result['data']['result']) {
            $result['data']['message'] = "해당 ID는 강의 공유, 양도, 불법거래 등 \n부정사용 행위 사유로 수강정지 조치되었습니다.\n부당한 사용 정지 조치를 받았다면, \n학습지원센터 > 소명게시판에서 소명해 주세요.\n확인 후 처리해 드리겠습니다.\n";
        }

        break;
    case 3:
        $result['data']['result'] =  (int)$callbackResult;
        // TODO: try more options

        if (!$result['data']['result']) {
            $result['data']['message'] = '해당 ID는 강의 공유, 양도, 불법거래 등 \n부정사용 행위 사유로 수강정지 조치되었습니다.\n부당한 사용 정지 조치를 받았다면, \n학습지원센터 > 소명게시판에서 소명해 주세요.\n확인 후 처리해 드리겠습니다.\n';
        }

        break;
}

// 로그 파일에 쓰기
file_put_contents('/var/tmp/sooyoon-lms.log', jwt_encode($result, $securityKey), FILE_APPEND);
header('Content-Type:text/plain; charset=utf-8');
header('X-Kollus-UserKey:' . $customKey);
echo jwt_encode($result, $securityKey);