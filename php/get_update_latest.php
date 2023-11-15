<?php
require 'db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

if($_SERVER['REQUEST_METHOD'] == 'GET'){

    // query insert new machine details
    $sql= 'SELECT * FROM tbl_update ORDER BY id DESC LIMIT 1;';

    try {
        $set=$conn->prepare("SET SQL_MODE=''");
        $set->execute();

        $get_sql = $conn->prepare($sql);
        $get_sql->execute();
        $result_get_sql = $get_sql->fetch(PDO::FETCH_ASSOC);
        echo json_encode($result_get_sql);
    } catch (PDOException $e) {
        echo json_encode(array('success'=>false,'message'=>$e->getMessage()));
    } finally{
        // Closing the connection.
        $conn = null;
    }
}else{
    echo json_encode(array('success'=>false,'message'=>'Error input'));
    die();
}