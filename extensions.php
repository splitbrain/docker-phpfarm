<?php
/**
 * This builds the table of supported PHP extensions
 */
$ports=array(8051,8052,8053,8054,8055,8056,8070,8071,8072,8073,8074,8080,8000);

# Ensure that chars show in browser correctly.
header('Content-Type: text/plain; charset=utf-8');

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

# Build table header:
# Extension | PHP 5.1 | PHP 5.2 | ... | PHP 7.1
print 'Extension    ';
foreach($ports as $port) {
    $major = substr($port,2,1);
    $minor = substr($port,3,1);
    if($major) {
        $version = "PHP $major.$minor";
    } else {
        $version = "nightly";
    }

    echo '| '.$version.' ';
}
echo "\n";

#
# Line below header.
#

# Right colon for right alignment.
echo '------------:';
foreach($ports as $port) {
    # Colons on both sides for centre alignment.
    echo '|:-------:';
}
echo "\n";

#
# Output modules table.
#
foreach($allmods as $mod => $inf) {
    # Left align mod name, and pad with spaces.
    printf('%-12s ', $mod);
    foreach($ports as $port) {
        if(isset($inf[$port])) {
            echo '|    ✓    ';
        } else {
            echo '|         ';
        }
    }
    echo "\n";
}

