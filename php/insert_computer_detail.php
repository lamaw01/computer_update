<?php
require 'db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

if($_SERVER['REQUEST_METHOD'] == 'POST'){
    $uuid = $input['uuid'];
    $hostname = $input['hostname'];
    $os = $input['os'];
    $defender = $input['defender'];
    $cpu = $input['cpu'];
    $gpu = $input['gpu'];
    $motherboard = $input['motherboard'];
    $ram = $input['ram'];
    $storage = $input['storage'];
    $user = $input['user'];
    $network = $input['network'];
    $monitor = $input['monitor'];
    $browser = $input['browser'];
    $msoffice = $input['msoffice'];

    $last_id_sql = 'SELECT * FROM tbl_update ORDER BY id DESC LIMIT 1;';

    $insert_sql = 'INSERT INTO tbl_computer_details(uuid,hostname,os,defender,cpu,gpu,motherboard,ram,storage,user,network,monitor,browser,msoffice,update_id)
    VALUES (:uuid,:hostname,:os,:defender,:cpu,:gpu,:motherboard,:ram,:storage,:user,:network,:monitor,:browser,:msoffice,:update_id)';

    $update_hostname_sql = 'UPDATE tbl_computer_details SET hostname=:hostname WHERE uuid=:uuid';

    $latest_hostname_sql = 'SELECT hostname FROM tbl_computer_details WHERE uuid=:uuid ORDER BY id DESC LIMIT 1;';

    try {
        // $set=$conn->prepare("SET SQL_MODE=''");
        // $set->execute();

        $get_latest_hostname_sql = $conn->prepare($latest_hostname_sql);
        $get_latest_hostname_sql->bindParam(':uuid', $uuid, PDO::PARAM_STR);
        $get_latest_hostname_sql->execute();
        $result_get_latest_hostname_sql = $get_latest_hostname_sql->fetch(PDO::FETCH_ASSOC);
        $latest_hostname = $result_get_latest_hostname_sql["hostname"];
        // echo json_encode($latest_hostname);
        // $value = !is_null($latest_hostname);
        // var_dump($value);

        if(!is_null($latest_hostname) && $latest_hostname != $hostname){
            $sql_update = $conn->prepare($update_hostname_sql);
            $sql_update->bindParam(':hostname', $hostname, PDO::PARAM_STR);
            $sql_update->bindParam(':uuid', $uuid, PDO::PARAM_STR);
            $sql_update->execute();
            echo json_encode(array('success'=>true,'message'=>'update','latest_hostname'=>$latest_hostname));
        }else{
            $get_sql = $conn->prepare($last_id_sql);
            $get_sql->execute();
            $result_get_sql = $get_sql->fetch(PDO::FETCH_ASSOC);
            $update_id = $result_get_sql["id"];

            $sql_insert = $conn->prepare($insert_sql);
            $sql_insert->bindParam(':uuid', $uuid, PDO::PARAM_STR);
            $sql_insert->bindParam(':hostname', $hostname, PDO::PARAM_STR);
            $sql_insert->bindParam(':os', $os, PDO::PARAM_STR);
            $sql_insert->bindParam(':defender', $defender, PDO::PARAM_STR);
            $sql_insert->bindParam(':cpu', $cpu, PDO::PARAM_STR);
            $sql_insert->bindParam(':gpu', $gpu, PDO::PARAM_STR);
            $sql_insert->bindParam(':motherboard', $motherboard, PDO::PARAM_STR);
            $sql_insert->bindParam(':ram', $ram, PDO::PARAM_STR);
            $sql_insert->bindParam(':storage', $storage, PDO::PARAM_STR);
            $sql_insert->bindParam(':user', $user, PDO::PARAM_STR);
            $sql_insert->bindParam(':network', $network, PDO::PARAM_STR);
            $sql_insert->bindParam(':monitor', $monitor, PDO::PARAM_STR);
            $sql_insert->bindParam(':browser', $browser, PDO::PARAM_STR);
            $sql_insert->bindParam(':msoffice', $msoffice, PDO::PARAM_STR);
            $sql_insert->bindParam(':update_id', $update_id, PDO::PARAM_INT);
            $sql_insert->execute();
            echo json_encode(array('success'=>true,'message'=>'insert'));
        }
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
?>