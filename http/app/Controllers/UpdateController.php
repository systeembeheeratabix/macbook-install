<?php

namespace App\Controllers;

use App\Request;

class UpdateController
{
    public function __invoke(Request $request)
    {
        return $request->method('POST')
            ? $this->update($request)
            : $this->fetch($request);
    }

    public function fetch(Request $request)
    {
        $remoteComposer = json_decode(file_get_contents('https://raw.githubusercontent.com/brysem/macbook-install/master/composer.json'));
        $localComposer = json_decode(file_get_contents(base_path('composer.json')));

        $remoteVersion = isset($remoteComposer->version) ? $remoteComposer->version : '0.0.0';
        $localVersion = isset($localComposer->version) ? $localComposer->version : '0.0.0';

        return [
            'is_updateable' => $remoteVersion > $localVersion,
            'version' => [
                'remote' => $remoteVersion,
                'local' => $localVersion,
            ]
        ];
    }

    public function update(Request $request)
    {
        $currentCwd = getcwd();
        chdir(base_path());

        exec('git pull', $output, $return);

        chdir($currentCwd);

        return [
            'success' => ! $return,
            'output' => $output,
        ];
    }
}
