<?php

$to = 'b@bdeak.net';
$from = 'errrelay@bdeak.net';

if (!$to) {
	exit("Must supply to email");
}
if (!$from) {
	exit("Must supply from email");
}

$log_file = $_POST['log_file'];
$diff = $_POST['diff'];

if (!$log_file) {
	exit("Must supply log file");
}
if (!$diff) {
	exit("Must supply diff");
}

$subject = 'New changes in ' . $log_file;

mail($to, $subject, $diff, 'From: ' . $from);