<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
  use Notifiable;

  // Don't add create and update timestamps in database.
  public $timestamps = false;

  /**
  * The table associated with the model.
  *
  * @var string
  */
  protected $table = 'user';

  /**
  * The attributes that are mass assignable.
  *
  * @var array
  */
  protected $fillable = [
    'typeofuser','username', 'email', 'password', 'completename', 'phonenumber', 'birthdate', 'pathtophoto', 'city', 'address', 'postalcode',
  ];

  /**
  * The attributes that should be hidden for arrays.
  *
  * @var array
  */
  protected $hidden = [
    'password', 'remember_token',
  ];

  public function city()
  {
    return $this->belongsTo('App\City');
  }

}
