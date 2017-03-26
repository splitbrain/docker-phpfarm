
# Move the executables to the correct places.
cp /phpfarm/src/php-5.1.6/sapi/cgi/php /phpfarm/inst/php-5.1.6/bin/php-cgi
cp /phpfarm/src/php-5.1.6/sapi/cli/php /phpfarm/inst/php-5.1.6/bin/php

ln -fs /phpfarm/inst/php-5.1.6/bin/php-cgi /phpfarm/inst/bin/php-cgi-5.1.6

