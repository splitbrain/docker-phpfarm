<?php
if(isset($_GET['modules'])) {
    header('Content-Type: text/plain');

    // Get regular (non-Zend) extensions.
    $mods = get_loaded_extensions();

    // 'zend_extensions' param only introduced in PHP 5.2.4,
    // setting the param returns NULL in PHP 5.1.
    $zend_mods = get_loaded_extensions(true);
    if ($zend_mods) {
        $mods = array_merge($mods, $zend_mods);
    }

    $mods = array_map('strtolower', $mods);

    // Remove duplicates.
    $mods = array_unique($mods);

    // Sort alphabetically.
    sort($mods);

    echo join("\n", $mods);
} else {
    phpinfo();
}
