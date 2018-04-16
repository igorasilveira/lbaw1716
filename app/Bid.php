<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Bid extends Model
{
  /**
  * The table associated with the model.
  *
  * @var string
  */
  protected $table = 'bid';

  /**
  * The attributes that are mass assignable.
  *
  * @var array
  */
  protected $fillable = [
    'value', 'username', 'bidder', 'isBuyNow'
  ];

  public function user()
  {
    return $this->belongsTo('App\User');
  }

  public function auction()
  {
    return $this->belongsTo('App\Auction','auctionbidded');
  }

}
