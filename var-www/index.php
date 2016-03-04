<?php
if(isset($_GET['modules'])) {
    header('Content-Type: text/plain');
    $mods = array_merge(get_loaded_extensions(), get_loaded_extensions(true));
    $mods = array_map('strtolower', $mods);
    sort($mods);
    echo join("\n", $mods);
} else {
    phpinfo();
}
