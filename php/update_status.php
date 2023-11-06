<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

echo json_encode(array('success'=>true,'update'=>true));
