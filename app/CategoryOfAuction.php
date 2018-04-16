<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CategoryOfAuction extends Model
{
  /**
  * The table associated with the model.
  *
  * @var string
  */
  protected $table = 'categoryofauction';

  public function auction(){
    return $this->belongsTo('App\Auction','auction');
  }

  public function category(){
    return $this->belongsTo('App\Category','category');
  }

}
