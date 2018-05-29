<!DOCTYPE html>
<html>
<head>
  <title>Welcome Email</title>
  <link href="{{ asset('css/bootstrap.min.css') }}"
  rel="stylesheet">
</head>

<body>
<h2>Welcome to PC_Auctions</h2>
<br/>
<div>
  <p >
    We are very pleased you will be working with us as a moderator.
  </p>
  <p>
    Your username is: <strong> {{ $username }} </strong>
  </p>
  <p>
    Your password is: <strong> {{ $password }} </strong>
    <br />
    Change it after the first login, please.
  </p>
  <p>
    Go and Login at <a href="http://lbaw1716.lbaw-prod.fe.up.pt/"> PC_Auctions </a>!
  </p>
  <p>
    The Direction of PC_Auctions
  </p>
</div>
</body>
</html>
