<?php

use App\View;

function view($path, array $variables = [])
{
    return new View($path, $variables);
}

function app_path($path = '')
{
    global $baseDir;

    return \rtrim($baseDir, '/') .'/'. \ltrim($path, '/');
}

function base_path($path = '')
{
    global $baseDir;

    $basePath = \realpath($baseDir . '/..');

    return \rtrim($basePath, '/') .'/'. \ltrim($path, '/');
}

function public_path($path = '')
{
    global $publicDir;

    return \rtrim($publicDir, '/') .'/'. \ltrim($path, '/');
}

function php_versions()
{
    exec('brew --prefix', $output);
    $brewPath = reset($output);
    $path = \realpath("{$brewPath}/Cellar");

    $folders = new RecursiveDirectoryIterator($path);
    $versions = [];
    foreach ($folders as $name => $folder) {
        if (\strpos($name, 'php@') === false) {
            continue;
        }
        $name = \explode('@', $name);
        if (isset($name[1])) {
            $versions[] = $name[1];
        }
    }
    \sort($versions);

    return $versions;
}

function dd(...$data)
{
    foreach ($data as $row) {
        echo '<pre>';
        \print_r($row);
        echo '</pre>';
    }

    exit;
}

function redirect($url)
{
    \header('Location: '. $url);
    exit;
}
