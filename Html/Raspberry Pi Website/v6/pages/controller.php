<!DOCTYPE html>
<html>

<head>
    <link rel="stylesheet" href="../style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Sofia">
    <script type="text/javascript" src="../script.js"></script>
    <link rel="shortcut icon" type="image/x-icon" href="/data/logoUrl.png" />
    <?php
    require_once("../serverside/functions.php");
    ?>
    <title>Controller</title>
    <script>
        //Clear Cache
        if (window.history.replaceState) {
            window.history.replaceState(null, null, window.location.href);
        }
    </script>



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

        <!-- Relay Controller -->
        <div class="shell smaller noTransform">
            <p> > sudo relay_controller.py</p>

            <form class="form-inline" method="post">
                <p>
                    <label for="password1"> <span style="color: whitesmoke;"> &nbsp password:</span> </label>
                    <input type="password" class="PasswordField" name="password1" placeholder="_">
                    <input type="submit" name="Send1" value="▢">
                </p>
            </form>

            <?php
            if (isset($_POST['Send1'])) {
                if (isCorrect("password1", 1)) {
                    closeRelay();
                } else {
                    echo '<p> > <span style="color:red;">  Wrong Password, try again!</span> </p>';
                }
            }
            ?>

        </div>


        <!-- PC Controller -->
        <div class="shell smaller noTransform">
            <p> > sudo pc_controller.py toggle</p>

            <?php
            echo getPCState("Message");
            ?>

            <form class="form-inline" method="post">
                <p>
                    <label for="password2"> <span style="color: whitesmoke;"> &nbsp password:</span> </label>
                    <input type="password" class="PasswordField" name="password2" size="20" placeholder="_">
                    <input type="submit" name="Send2" value="▢">
                </p>
            </form>


            <?php
            if (isset($_POST['Send2'])) {
                if (isCorrect("password2", 2)) {
                    togglePc(getPCState("State"));
                } else {
                    echo '<p> > <span style="color:red;">  Wrong Password, try again!</span> </p>';
                }
            }
            ?>


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