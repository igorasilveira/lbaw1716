<?php
  $password = "1234";
  $options = ['cost' => 12];
  $hash = password_hash($password, PASSWORD_DEFAULT, $options);
  echo $hash;
?>
