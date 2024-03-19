<?php
require 'db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

if($_SERVER['REQUEST_METHOD'] == 'POST'){
    $hostname = $input['hostname'];

    // query get computer latest update id
    $sql = 'SELECT update_id FROM tbl_computer_details WHERE hostname = :hostname ORDER BY update_id DESC LIMIT 1;';

    try {
        $set=$conn->prepare("SET SQL_MODE=''");
        $set->execute();

        $get_sql = $conn->prepare($sql);
        $get_sql->bindParam(':hostname', $hostname, PDO::PARAM_STR);
        $get_sql->execute();
        $result_get_sql = $get_sql->fetch(PDO::FETCH_ASSOC);
        echo json_encode($result_get_sql);
        // echo json_encode(array('success'=>false,'message'=>'yawa'));
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