$req = [System.Net.WebRequest]::Create("http://103.62.153.74:53000/computer_detail/update_status.php")
$resp = $req.GetResponse()
$reqstream = $resp.GetResponseStream()
$stream = new-object System.IO.StreamReader $reqstream
$result = $stream.ReadToEnd()

$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$obj = $ser.DeserializeObject($result)
$obj.update | Out-Host 