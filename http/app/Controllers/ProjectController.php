<?php

namespace App\Controllers;

use App\Request;
use RecursiveDirectoryIterator;

class ProjectController
{
    public function __invoke(Request $request)
    {
        $projects = array_merge($this->getProjects('app'), $this->getProjects('dev'));

        $names = array_column($projects, 'name');
        array_multisort($names, \SORT_ASC, $projects);

        return view('projects', [
            'projects' => $projects,
        ]);
    }

    protected function getProjects($type = 'app')
    {
        $path = realpath('/Users/'. get_current_user() .'/Development/http/'. $type);

        $folders = new RecursiveDirectoryIterator($path);

        $projects = [];

        foreach($folders as $name => $folder) {
            /** @var SplFileInfo $folder */
            if (! $folder->isDir() || substr(basename($name), 0, 1) === '.') continue;

            $projects[] = [
                'type' => $type,
                'path' => $name,
                'name' => $this->prettifyName(basename($name)),
                'url' => 'http://'. basename($name) .'.'. $type .'.test',
                'image' => 'https://www.gravatar.com/avatar/'. md5(basename($name)) .'?d=identicon',
            ];
        }

        return $projects;
    }

    protected function prettifyName($name)
    {
        $name = strtolower($name);
        $name = str_replace(['-', '_'], ' ', $name);

        $parts = explode(' ', $name);

        $abbreviations = ['api', 'cms', 'php'];

        foreach ($parts as $i => $part) {
            if (in_array($part, $abbreviations)) {
                $parts[$i] = strtoupper($part);
                continue;
            }

            $parts[$i] = ucwords($part);
        }



        return implode(' ', $parts);
    }
}
