<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'root' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          'J8DM;nS,x=_nFM55#u]D`&eg+BG~Sfd9!k]r5/}G|dk0:X)mOV1SoqW&V.^G!_Gc' );
define( 'SECURE_AUTH_KEY',   '4A~o(=>]efRcQj]F~0boo[F4HTV*.`Rrq>d4Q_gO8%&sCv+ZMTNj0$$M=0dQ*bi7' );
define( 'LOGGED_IN_KEY',     'v(PWCL-o+MW4{D]CD%S$j.Hn=^5N79`Z*owH])}[uneWr j4BxoXj|b0YK]_7v<k' );
define( 'NONCE_KEY',         'ig.fEJ)k%v44?El-Dn&Zq`/*h56&~dV^B^-:u#o0+!@(|Yieu@RQzp/d6(/8Ig20' );
define( 'AUTH_SALT',         'gQCgTMT(8)$Cz8PszW--z5;:;&Hy[!T!`*(AM|ufG+~_3>A +)X@PPVE|+ld#E6s' );
define( 'SECURE_AUTH_SALT',  '-X({nvNqN2c21=pH,90FhOA3$cWzuW;{{tb^E2VIU|.)~$>G0R.J%@=~x%5}ObFJ' );
define( 'LOGGED_IN_SALT',    'M=x/saB$4f<%S;3q|D,P| o]9n8nPSo9D@mc`6-vk8Pr$t.ii<bK2E<@b/>U.LDD' );
define( 'NONCE_SALT',        'x+Nc kj#OxKR ^GKDKmh~c;Z4tv^yXD>#<Z9=B^n$@L%<sa~A/NO,cGXbn&:doQv' );
define( 'WP_CACHE_KEY_SALT', 'b?vi4i4<Bn9j;&_aNYcq:7=m`zWKoQiOj5XN/q1oQL|HF>g6ub?za~/Wx@8)!Nol' );

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );


/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
