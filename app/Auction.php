<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Auction extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'auction';

      /**
       * The user this card belongs to
       */
      public function user() {
        return $this->belongsTo('App\User');
      }
}
