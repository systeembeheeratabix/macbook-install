<?php

namespace App\Exceptions;

use RuntimeException;

class UndefinedRouteException extends RuntimeException
{
    protected $message = 'The provided route has not been defined.';
}
