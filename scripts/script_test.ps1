$header1 = @{
    "Accept"="*/*"
    "Content-Type"="application/json; charset=UTF-8"
}

curl.exe -X GET  -H $header1 http://103.62.153.74:53000/computer_detail/update_status.php
