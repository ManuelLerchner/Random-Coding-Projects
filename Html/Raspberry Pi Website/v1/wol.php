<html>
	<head>
		<meta name="viewport" content="width=device-width" />
	</head>

	<body  style="background-color:Blue">
		<center>
			<h1>Control PC</h1>

			<form method="get" action="index.php">
				<input type="submit" style = "font-size: 14 pt" value="wol" name="wol">
				<input type="submit" style = "font-size: 14 pt" value="Shutdown" name="Shutdown">
			</form>

			<?php
				if(isset($_GET['wol'])){
					echo "WOL Sent";
					shell_exec("wakeonlan B4:2E:99:E8:5D:E0");
				}

				if(isset($_GET['Shutdown'])){
					echo "Shutdown Sent";
					shell_exec('net rpc shutdown -I 192.168.0.100  -t 10 -U Manuel%Lerchner2002 ');
				}
			?>
			
		</center>
	</body>
</html>
