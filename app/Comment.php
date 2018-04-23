<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
  protected $table = 'comment';

  public function user()
  {
    return $this->belongsTo('App\User','usercommenter');
  }

  public function auction()
  {
    return $this->belongsTo('App\Auction','auctioncommented');
  }
}
