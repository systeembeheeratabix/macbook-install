<?php

use App\Request;
use App\Router;

$baseDir = __DIR__;

require __DIR__ .'/../vendor/autoload.php';
require __DIR__ .'/helpers.php';

(function() {
    $router = new Router(new Request());
    require base_path('/routes.php');
})();

