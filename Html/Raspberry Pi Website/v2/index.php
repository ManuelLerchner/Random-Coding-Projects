<?php
	require_once('config.php');	
?>
<html>
	<script>
		//Clear Cache
	    if ( window.history.replaceState ) {
			window.history.replaceState( null, null, window.location.href );
	    }
	</script>

	<head>
		<title> Raspberry Pi </title>
		<link rel="stylesheet" type="text/css" href="style.css" />
		<script type="text/javascript" src="script.js"></script> 
	</head>
	
	
	<body onload="show('Home')()">
		
		<div id ="container">
		
			<div id="header">
				<h1> Raspberry Pi </h1>
			</div>
			
			<div id="content">
			
				<div id = "nav">
					<h3> Navigation: </h3>
					<ul>
					<li> <a id="HomeLink" onclick="show('Home')()">Home </a> </li>
					<li> <a id="ControllerLink" onclick="show('Controller')()">Controller </a> </li>
					<li> <a id="AboutLink" onclick="show('About')()">About </a> </li>
					</ul>							
				</div>
				
				<div id="main"></div>
			
			</div>
			
			<div id="footer">
				<p>Copyright &copy; 2020 Manuel Lerchner &nbsp&nbsp </p>
			</div>

	</body>

</html>


<!------------Different Sheets-------------->

<div id="empty" style="display:none">
</div>



<div id="Home" style="display:none">
	<h2> Home </h2>
	<h4>About me:</h4>
	<p> Hello my Name is Manuel Lerchner and I am a Student and Software Developer from South Tyrol </p>
</div>




<div id="Controller" style="display:none">
	<h2> Controller </h2>
	
			<!--  Relay Controller -->
			<h4>Control Relay:</h4>
	
			
			<!--  Relay Password/Button -->
			<form class="form-signin" method="post">
				<input type="password" id="password1" class="input-block-level"placeholder="Enter Passphrase" name="password1">
				<input type="submit" value="Close Relay" name="Send1" >
			</form>
			
			
			<!--  Relay Controller -->
			<?php	
				shell_exec("gpio write 7 1");
				shell_exec("gpio mode 7 out");	


				if(isset($_POST['Send1'])){
					
						
					$hash = hash("sha256", $_POST['password1']);
					if($hash == $APPROVED_HASH1) {
						echo '<p2 style="color:blue;"> Relay was closed for 1.5 seconds, now its open again </p2>';
								$IP = $_SERVER['REMOTE_ADDR']; 		
								shell_exec("gpio write 7 0");
								sleep(1.5);
								shell_exec("gpio write 7 1");
								shell_exec('python send.py "'.$IP.'"');	
								
					}else{
						echo '<p1 style="color:red;">
							Wrong Password, try again!
						      </p1>';
					}
				  echo "<script> window.onload = show('Controller'); </script>";	
				}
			
			?>
			
			
			<!--  PC Controller -->
			<h4>Control PC:</h4>
			
			<?php	
				#Get Pc State
				$pinginfo = exec("ping -c 1 192.168.0.100");
				$pcState;
				$buttonAction="";
			
				if($pinginfo==""){
					echo '<p3 style="color:green";>Manuel-PC is currently turned off</p3>';
					$pcState=false;
					$buttonAction="Turn on PC";
				}else{
					echo '<p3 style="color:green">Manuel-PC is currently turned on</p3>';
					$pcState=true;
					$buttonAction="Turn off PC";
				}
			?>
			
			<!--  PC Password/Button -->
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
					}else{
						echo '<p1 style="color:red;">
							Wrong Password, try again!
						      </p1>';
					}
				echo "<script> window.onload = show('Controller'); </script>";
					
				
				}
				
			?>
			
			
		
</div>



<div id="About" style="display:none">
	<h2> About </h2>
	
	<h4> Contact me:</h4>
	<address>
		Written by <a href="mailto:manuel.lerchner1111@gmail.com">Manuel Lerchner</a><br>
		Visit us at: <br> 
		<a href="http://www.fliesenleger-lerchner.it/fliesen/unternehmen-lerchner.php"> www.fliesenleger-lerchner.it </a><br>
		Bachla 28, 39030 Pfalzen<br>
		ITALY
	</address>
</div>