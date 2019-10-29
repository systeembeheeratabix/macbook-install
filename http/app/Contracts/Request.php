<?php

namespace App\Contracts;

interface Request
{
    public function getBody();

    public function setUri($uri);

    public function setMethod($method);
}
