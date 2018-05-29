<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
  use Notifiable;

  // Don't add create and update timestamps in database.
  public $timestamps = false;

  public $remember_token=false;

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
    'typeofuser', 'username', 'email', 'password', 'completename',
    'phonenumber', 'birthdate', 'pathtophoto', 'city', 'address', 'postalcode',
    'balance', 'blocked'
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

  public function auctions()
  {
    return $this->hasMany('App\Auction');
  }

  public function bids()
  {
    return $this->hasMany('App\Bid');
  }

  public function auctionsSelling()
  {
    return Auction::where('auctioncreator', $this->id)->where('state', 'Active')->orderBy('limitdate','ASC');
  }

  public function auctionsSelling_m6()
  {
    return $this->auctionsSelling()->offset(6)->paginate(5);
  }

  public function auctionsBidding()
  {
    $buyID = $this->bids()->pluck('auction_id');
    return Auction::whereIn('id', $buyID)->where('state', 'Active')->orderBy('limitdate','ASC');
  }

  public function auctionsBidding_m6()
  {
    return $this->auctionsBidding()->offset(6)->paginate(5);
  }

  public function lastBidUserAuction(Auction $auction)
  {
    return $this->bids()->where('auction_id',$auction->id)->orderBy('date','DESC')->first();
  }

  public function auctionsModerating()
  {
    return Auction::where('responsiblemoderator', $this->id)->where('state', 'Active')->orderBy('limitdate','ASC');
  }

  public function auctionsModerating_m6()
  {
    return $this->auctionsModerating()->offset(6)->paginate(5);
  }

  public function pending()
  {
    return Auction::all()->where('state', 'Pending')->orderBy('limitdate','ASC');
  }

  public function pending_m6()
  {
    return $this->pending()->offset(6)->paginate(5);
  }
}
