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
      $this->description = "Your Auction <a href='/auction/" . $this->auctionassociated . "'> #" . $this->auctionassociated . "</a> was rejected because ". Auction::find($this->auctionassociated)->reasonofrefusal ."!";
      break;
      case 'Auction Created':
      $this->description = "Your Auction <a href='/auction/" . $this->auctionassociated . "'> #" . $this->auctionassociated . "</a> was created and is now pending approval!";
      break;
      case 'Auction Over':
      $this->description = "Your Auction <a href='/auction/" . $this->auctionassociated . "'> #" . $this->auctionassociated . "</a> is now finished! The Winner is ". User::find(Auction::find($this->auctionassociated)->auctionwinner) ."!";
      break;
      case 'Bid Exceeded':
      $this->description = "Your Bid on <a href='/auction/" . $this->auctionassociated . "'> #" . $this->auctionassociated . "</a> was surpassed. Try again!";
      break;
      case 'Won Auction':
      $this->description = "You win the auction <a href='/auction/" . $this->auctionassociated . "'> #" . $this->auctionassociated . "</a>. Don't forget to rate it!";
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
