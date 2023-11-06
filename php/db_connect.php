<?php
$servername = "localhost";
$username = "computer_details";
$password = "deTa1ls";
$port = "3306";
$db = "computer_details";

try {
    $conn = new PDO("mysql:host=$servername;port=$port;dbname=$db", $username, $password);
    // setting the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    //echo "Connected successfully";
    }
catch(PDOException $e){
    echo "Connection failed: " . $e->getMessage();
    }
?>