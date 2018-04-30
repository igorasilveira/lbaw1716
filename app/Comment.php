<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
  protected $table = 'comment';
  public $timestamps = false;

  protected $fillable = [
    'date', 'description', 'auctioncommented', 'usercommenter'
  ];

  public function user()
  {
    return $this->belongsTo('App\User','usercommenter');
  }

  public function auction()
  {
    return $this->belongsTo('App\Auction','auctioncommented');
  }
}
