<?php

use App\View;

function view(string $path, array $variables = [])
{
    return new View($path, $variables);
}

function base_path(string $path)
{
    global $baseDir;

    return \rtrim($baseDir, '/') .'/'. \ltrim($path, '/');
}

function public_path(string $path)
{
    global $publicDir;

    return \rtrim($publicDir, '/') .'/'. \ltrim($path, '/');
}

function php_versions()
{
    $path = realpath('/usr/local/Cellar');

    $folders = new RecursiveDirectoryIterator($path);
    $versions = [];
    foreach($folders as $name => $folder){
        if (strpos($name, 'php@') === false) {
            continue;
        }
        $name = explode('@', $name);
        if (isset($name[1])) {
            $versions[] = $name[1];
        }
    }
    sort($versions);
    return $versions;
}

function dd($data)
{
    echo '<pre>';
    print_r($data);
    exit;
}

function redirect($url)
{
    header('Location: '. $url);
    exit;
}
