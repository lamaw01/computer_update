<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);


if($_SERVER['REQUEST_METHOD'] == 'POST'){
    $windowsProductName = $input['windowsProductName'];
    $osHardwareAbstractionLayer = $input['osHardwareAbstractionLayer'];
    $antivirusSignatureVersion = $input['antivirusSignatureVersion'];
    $csDNSHostName = $input['csDNSHostName'];
    $ipAddress = $input['ipAddress'];
    $machineId = $input['machineId'];

    // query check if machine has data
    $check_machine_exist = 'SELECT * FROM tbl_arriba_computer_details
    WHERE machineId = :check_machineId';

    // query insert new machine details
    $insert_machine= 'INSERT INTO tbl_arriba_computer_details(windowsProductName, osHardwareAbstractionLayer, antivirusSignatureVersion, csDNSHostName, ipAddress, machineId)
    VALUES (:windowsProductName,:osHardwareAbstractionLayer,:antivirusSignatureVersion,:csDNSHostName,:ipAddress,:insert_machineId)';

    // query update machine details
    $update_machine = 'UPDATE tbl_arriba_computer_details SET windowsProductName = :windowsProductName, osHardwareAbstractionLayer = :osHardwareAbstractionLayer,
    antivirusSignatureVersion = :antivirusSignatureVersion, csDNSHostName = :csDNSHostName, ipAddress = :ipAddress WHERE machineId = :update_machineId';

    try {
        // check if machine has data
        $sql_check_machine= $conn->prepare($check_machine_exist);
        $sql_check_machine->bindParam(':check_machineId', $machineId, PDO::PARAM_STR);
        $sql_check_machine->execute();
        $result_sql_check_machine = $sql_check_machine->fetch(PDO::FETCH_ASSOC);
        // insert
        if(!$result_sql_check_machine){
            $sql_insert = $conn->prepare($insert_machine);
            $sql_insert->bindParam(':windowsProductName', $windowsProductName, PDO::PARAM_STR);
            $sql_insert->bindParam(':osHardwareAbstractionLayer', $osHardwareAbstractionLayer, PDO::PARAM_STR);
            $sql_insert->bindParam(':antivirusSignatureVersion', $antivirusSignatureVersion, PDO::PARAM_STR);
            $sql_insert->bindParam(':csDNSHostName', $csDNSHostName, PDO::PARAM_STR);
            $sql_insert->bindParam(':ipAddress', $ipAddress, PDO::PARAM_STR);
            $sql_insert->bindParam(':insert_machineId', $machineId, PDO::PARAM_STR);
            $sql_insert->execute();
            echo json_encode(array('success'=>true,'message'=>'insert'));
        }
        // update
        else{
            $sql_update = $conn->prepare($update_machine);
            $sql_update->bindParam(':windowsProductName', $windowsProductName, PDO::PARAM_STR);
            $sql_update->bindParam(':osHardwareAbstractionLayer', $osHardwareAbstractionLayer, PDO::PARAM_STR);
            $sql_update->bindParam(':antivirusSignatureVersion', $antivirusSignatureVersion, PDO::PARAM_STR);
            $sql_update->bindParam(':csDNSHostName', $csDNSHostName, PDO::PARAM_STR);
            $sql_update->bindParam(':ipAddress', $ipAddress, PDO::PARAM_STR);
            $sql_update->bindParam(':update_machineId', $machineId, PDO::PARAM_STR);
            $sql_update->execute();
            echo json_encode(array('success'=>true,'message'=>'update'));
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