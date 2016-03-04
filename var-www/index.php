<?php
if(isset($_GET['modules'])) {
    header('Content-Type: text/plain');
    $mods = get_loaded_extensions();
    $mods = array_map('strtolower', $mods);
    sort($mods);
    echo join("\n", $mods);
} else {
    phpinfo();
}
