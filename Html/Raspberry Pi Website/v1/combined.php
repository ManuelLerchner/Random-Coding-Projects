<?php
	require_once('config.php');
?>

<html>

	<head>
		<link rel="icon" href="https://keyicons.com/public/img/favicon.png?v=2">
		<meta name="viewport" content="width=device-width" />
		<title>Home-Controller </title>
	</head>

	<body style="background-color:#6ca6cd">
		<center>
              		<!--  Relay Controller-->

			<h1>Control Relay</h1>

			<form class="form-signin" method="post">
				<input required type="password" id="password1" class="input-block-level"placeholder="Enter Passphrase" name="password1">
				<input type="submit" value="Close Relay" name="Send1">
				
			</form>
		


			<?php	
					
				shell_exec("gpio write 7 1");
				shell_exec("gpio mode 7 out");	

				if(isset($_POST['Send1']))			{
					$hash = hash("sha256", $_POST['password1']);
					if($hash == $APPROVED_HASH1) {
						echo "Relay was closed for 1.5 seconds, now its open again";
								shell_exec("gpio write 7 0");
								sleep(1.5);
								shell_exec("gpio write 7 1");
			
					header('Location: http://192.168.0.188/index.php');
					}else{
						echo "Wrong Password, try again";
					}
				}
			?>


			<!--  PC Controller-->

			<h1><br>Control PC</h1>
			
			<?php	
				#Get Pc State
				$pinginfo = exec("ping -c 1 192.168.0.100");
				$pcState;
				$buttonAction="";
			
				if($pinginfo==""){
					echo "Manuel-PC is currently turned off";
					$pcState=false;
					$buttonAction="Turn on PC";
				}else{
					echo "Manuel-PC is currently turned on";
					$pcState=true;
					$buttonAction="Turn off PC";
				}
			?>

			<p></p>

			<form class="form-signin" method="post">
				<input type="password" id="password2" class="input-block-level"placeholder="Enter Passphrase" name="password2">
				<input type="submit" value="<?php echo $buttonAction ?>" name="Send2">
			</form>


			<?php	
				#PC Controller

				if(isset($_POST['Send2'])){
					$hash = hash("sha256", $_POST['password2']);

					if($hash == $APPROVED_HASH2) {

						if($pcState==true){
							shell_exec($COMPUTER_CUSTOM_SLEEP_COMMAND);
						}else{
							shell_exec($COMPUTER_CUSTOM_WAKE_COMMAND);
						}
						header('Location: http://192.168.0.188/index.php');

					}else{
						echo "Wrong Password, try again";
					}
				}
			?>


		</center>

	</body>

</html>
