<?php

use App\Controllers\ProjectController;
use App\Request;

$router->get('/', function () {
    return view('home', [
        'phpVersions' => php_versions(),
    ]);
});

$router->get('/projects', function () {
    return new ProjectController();
});

$router->post('/finder', function (Request $request) {
    if (! empty($path = $request->input('path'))) {
        exec('open -R '. realpath($path));
    }

    return [
        'path' => $path,
    ];
});

$router->get('/php', function () {
    return view('php');
});

$router->get('/404', function () {
    return view('404');
});
