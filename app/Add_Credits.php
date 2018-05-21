<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Add_Credits extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'add_credits';
    public $timestamps = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
    'value', 'date', 'paypalid', 'user', 'trasactionID',
  ];
}
