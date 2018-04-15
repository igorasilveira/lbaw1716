<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class City extends Model
{
  /**
  * The table associated with the model.
  *
  * @var string
  */
  protected $table = 'city';

  /**
  * The attributes that are mass assignable.
  *
  * @var array
  */
  protected $fillable = [
    'name', 'country'
  ];
}
