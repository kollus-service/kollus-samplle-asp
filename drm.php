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
$customKey = '2d0e3724427ad1428a6778392dba251e';

$items = isset($_POST['items']) ? $_POST['items'] : '';
$items = empty($items) ? array() : json_decode($items, true);

$result = array(
    'data' => array()
);

foreach ($items as $item) {
    $kind = isset($item['kind']) ? (int)$item['kind'] : null;
    $clientUserId = isset($item['client_user_id']) ? $item['client_user_id'] : null;
    $mediaContentKey = isset($item['media_content_key']) ? $item['media_content_key'] : null;
    $startAt = isset($item['start_at']) ? $item['start_at'] : null;

    file_put_contents('/var/tmp/sooyoon-drm.log', $mediaContentKey.PHP_EOL, FILE_APPEND);

    $callbackResult = true;

    $itemResult = [
        'result' => (int)$callbackResult,
        'media_content_key' => $mediaContentKey,
    ];
    switch($kind) {
        case 1:
            $itemResult['kind'] = 1;
            // TODO: try more options

            // $itemResult['expiration_count'] = 0;
            
            if (!$itemResult['result']) {
                $itemResult['message'] = 'This video is not permitted to you';
            }
            break;
        case 2:
            // TODO: marking download 'done' to db.
            $itemResult['kind'] = 2;
            // TODO: try more options

            if (!$itemResult['result']) {
                $itemResult['message'] = 'This video is not permitted to you';
            }
            break;
        case 3:
            $itemResult['kind'] = 3;
            // TODO: try more options

            $itemResult['start_at'] = $startAt;
            // $itemResult['expiration_count'] = 0;


            if (!$itemResult['result']) {
                $itemResult['message'] = 'This video is not permitted to you';
            }
            break;
    }

    if (!empty($result)) {
        $result['data'][] = $itemResult;
    }
}


 $logFile = '/var/tmp/sooyoon-drm.log';
 file_put_contents($logFile, json_encode($result).PHP_EOL, FILE_APPEND);

header('Content-Type:text/plain; charset=utf-8');
header('X-Kollus-UserKey:' . $customKey);
echo jwt_encode($result, $securityKey);