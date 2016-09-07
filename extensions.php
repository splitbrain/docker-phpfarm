<?php
/**
 * This builds the table of supported PHP extensions
 */
$ports=array(8052,8053,8054,8055,8056,8070,8071);

# fetch extension info
$allmods = array();
foreach($ports as $k => $port) {
    $mods = @file("http://localhost:$port/?modules");
    if(!$mods || substr(trim($mods[0]),0,1) == '<') {
        # not the response we're looking for
        unset($ports[$k]);
        continue;
    }
    foreach($mods as $mod) {
        $mod = trim($mod);
        if($mod == 'core') continue;
        $allmods[$mod][$port] = 1;
    }
}
$ports = array_values($ports);
ksort($allmods);

# build table header
printf('     %10s ', 'Extension');
foreach($ports as $port) {
    echo '| PHP '.substr($port,2,1).'.'.substr($port,3,1).' ';
}
echo "\n    ";
echo '------------';
foreach($ports as $port) {
    echo '+---------';
}
echo "\n";

# output table
foreach($allmods as $mod => $inf) {
    printf('     %10s ', $mod);
    foreach($ports as $port) {
        if(isset($inf[$port])) {
            echo '|    ✓    ';
        } else {
            echo '|         ';
        }
    }
    echo "\n";
}

