<!DOCTYPE HTML>

<html>
<head>
<title>Database</title>
<meta charset="utf-8" />
</head>

<body>
<div class="main">
<h2>Real-time content of the database :</h2>
<?php
$user = "root";
$database = "site";
$table = "books";
$password = "password";

echo "<ol>";
try {
		$db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
		foreach($db->query("SELECT title FROM $table") as $row) {
				echo "<li>" . $row['title'] . "</li>";
		}
		echo "</ol>";
} catch (PDOException $e) {
		print "Error!: " . $e->getMessage() . "<br/>";
		die();
}
?>
</div>
</body>
</html>

