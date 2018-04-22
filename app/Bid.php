<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Bid extends Model
{

  // Don't add create and update timestamps in database.
  public $timestamps = false;

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
    'value', 'auction_id', 'user_id', 'isBuyNow'
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
