<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
  public $timestamps = false;

  /**
  * The table associated with the model.
  *
  * @var string
  */
  protected $table = 'notification';


  protected $fillable = [
    'date', 'description', 'type', 'auctionassociated', 'authenticated_userid', '_read'
  ];

  public function user()
  {
    return $this->belongsTo('App\User','authenticated_userid');
  }

  public function auction()
  {
    return $this->belongsTo('App\Auction','auctionassociated');
  }
}
