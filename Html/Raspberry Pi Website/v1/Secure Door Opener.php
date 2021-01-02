<?php
require_once('config.php');
?>

<html>

	<head>
		<link rel="icon" href="https://keyicons.com/public/img/favicon.png?v=2">
		<meta name="viewport" content="width=device-width" />
		<title>Relay-Controller </title>
	</head>

	<body style="background-color:LightSkyBlue">
		<center>
			<h1>Control Relay</h1>

			<form class="form-signin" method="post">
				<input type="password" id="password" autocomplete=off class="input-block-level"placeholder="Enter Passphrase" name="password">
				<input type="submit" value="Close Relay" name="Send">
			</form>

			<?php	
				shell_exec("gpio write 7 1");
				shell_exec("gpio mode 7 out");	

				if(isset($_POST['Send']))			{

					$hash = hash("sha256", $_POST['password']);
					if($hash == $approvedHash) {
						echo "Relay was closed for 1.5 seconds, now its open again";
						shell_exec("gpio write 7 0");
						sleep(1.5);
						shell_exec("gpio write 7 1");
					}else{
						echo "Wrong Password, try again";
					}

				}

			?>
		</center>

	</body>

</html>
