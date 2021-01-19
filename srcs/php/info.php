<?php
$user = "root";
$database = "site";
$table = "books";
$password = "password";

try {
  $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
  echo "<h2>BOOKS</h2><ol>";
  foreach($db->query("SELECT title FROM $table") as $row) {
    echo "<li>" . $row['title'] . "</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
?>

