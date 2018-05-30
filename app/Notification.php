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
    'date', 'description', 'type', 'auctionassociated', 'authenticated_userid', '_read',
  ];


  function descriptionCont() {

    switch($this->type){
      case 'Auction Accepted':
      $this->description = "Your Auction <a href='/auction/" . $this->auctionassociated . "'> #" . $this->auctionassociated . "</a> was accepted!";
      break;
      case 'Auction Rejected':
      break;
      case 'Auction Created':
      break;
      case 'Auction Over':
      break;
      case 'Bid Exceeded':
      break;
      case 'Won Auction':
      break;
      default:
      break;
    }
    $this->save();

  }

  public function user()
  {
    return $this->belongsTo('App\User', 'authenticated_userid');
  }

  public function auction()
  {
    return $this->belongsTo('App\Auction', 'auctionassociated');
  }
}
