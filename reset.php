<?php

	// 1. READ EXISTING JSON
 
    $json = [];

    // 2. WRITE TO JSON
    $fp = fopen('sms.json', 'w');
	fwrite($fp, json_encode($json));
	fclose($fp);
?>