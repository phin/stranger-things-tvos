<?php

	// 1. READ EXISTING JSON

	$string = file_get_contents("sms.json");
	$json = json_decode($string, true);
    $number = $_POST['From'];
	$body = $_POST['Body'];

	// TODO : Sanitize
	// TODO : Format the way we want it
    $next = array('from' => $number, 'body' => $body);
    $json[] = $next;

    // 2. WRITE TO JSON
    $fp = fopen('sms.json', 'w');
	fwrite($fp, json_encode($json));
	fclose($fp);

    // output the counter response
    header("content-type: text/xml");
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
?>
<Response>
    <Sms>Thank you. Your message will appear on the tv soon. 😊</Sms>
</Response>