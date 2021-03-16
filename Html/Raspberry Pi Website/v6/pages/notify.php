<!DOCTYPE html>
<html lang="en">

<head>
    <link rel="stylesheet" href="../style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Sofia">
    <script type="text/javascript" src="../script.js"></script>
    <link rel="shortcut icon" type="image/x-icon" href="/data/logoUrl.png" />
    <title>Notifiy Me</title>
</head>

<div id="bg"></div>

<body>

    <div id="header">

        <ul id="Links">
            <li> <a href="../index.html"> <img src="/data/haus.png"> Home </a> </li>
            <li> <a href="/pages/controller.php"> <img src="/data/controller.png"> Controller </a> </li>
            <li> <a href="/pages/notify.php"> <img src="/data/notify.png"> Notify Me </a> </li>
            <li> <a href="/pages/about.html"> <img src="/data/about.png"> About </a> </li>
        </ul>

        <img id="Logo" src="/data/logo2.png">

    </div>



    <div id="main">

        <div class="shell smaller noTransform">
            <p>> sudo notify root</p>




            <form class="form-inline" method="post">
                <p>
                    <label for="nameField"> <span style="color: whitesmoke;"> &nbsp enter Name: &#8205 &#8205 &#8205 </span> </label>
                    <input type="text" name="nameField" width="20" placeholder="_">
                </p>

                <p>
                    <label for="textField"> <span style="color: whitesmoke;"> &nbsp enter Message:</span> </label>
                    <textarea id="textField" name="textField" rows="4"></textarea>
                </p>
                <p>
                    <label for="SendNotification"> <span style="color: whitesmoke;"> &nbsp confirm: &#8205 &#8205 &#8205 &#8205 &#8205 &#8205 </span> </label>
                    <input id="wideInput" type="submit" name="SendNotification" value="▢">
                </p>

            </form>


            <?php if (isset($_POST['SendNotification'])) {
                $name = $_POST['nameField'];
                $message = $_POST['textField'];
                $send = $name . ' sends: ' . $message;
                echo '<p>> ' . $send . '</p>';

                shell_exec($email);
                shell_exec('sudo nullmailer-send');
                echo shell_exec(
                    "python ../serverside/sendEmail.py 'RaspberryPi Messenger-Service' '" .
                        $send .
                        "'"
                );
                echo '<p> >  Notified Admin </p>';
            } ?>


        </div>


    </div>



    <div id="footer">

        <ul id="References">
            <li> <a id="Twitter" href="https://twitter.com/ManuelLerchner"> <img src="/data/twitter.png"> Twitter </a>
            </li>
            <li> <a id="Youtube" href="https://www.youtube.com/channel/UCvIGqQ5pelOqwaKOFaqiP4w"> <img src="/data/youtube.png"> Youtube </a>
            </li>
        </ul>

    </div>




</body>


</html>