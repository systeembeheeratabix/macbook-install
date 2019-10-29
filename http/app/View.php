<?php

namespace App;

class View
{
    protected $path;
    protected $variables;

    public function __construct($path, array $variables = [])
    {
        $this->path = $this->parsePath($path);
        $this->variables = $variables;
    }

    protected function parsePath($path)
    {
        $path = \str_replace('.', '/', $path);
        $path = $path . '.php';

        return app_path('views/'. \ltrim($path, '/'));
    }

    protected function load($filename)
    {
        if (\is_file($filename)) {
            \ob_start();
            \extract($this->variables);
            include $filename;

            return \ob_get_clean();
        }

        return 'Undefined template "'. $this->path .'"';
    }

    public function __invoke()
    {
        return $this->__toString();
    }

    public function __toString()
    {
        return $this->load($this->path);
    }
}
