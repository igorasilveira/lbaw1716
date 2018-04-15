<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Country extends Model
{
  /**
  * The table associated with the model.
  *
  * @var string
  */
  protected $table = 'country';

  /**
  * Get all of the users for the country.
  */
  public function users()
  {
    return $this->hasMany('App\User');
  }
}
