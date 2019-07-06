<?php

namespace App\Contracts;

interface Request
{
    public function getBody();

    public function setUri(string $uri);

    public function setMethod(string $method);
}
