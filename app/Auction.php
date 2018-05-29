<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Auction extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'auction';
    public $timestamps = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
    'state', 'title', 'sellingreason', 'description', 'pathtophoto', 'startingprice', 'minimumsellingprice', 'buynow', 'limitdate', 'auctioncreator', 'responsiblemoderator',
    'reasonofrefusal','refusaldate'
  ];

    /**
     * The user this auction belongs to.
     */
    public function creator()
    {
        return $this->belongsTo('App\User', 'auctioncreator');
    }

    public function categories()
    {
        return $this->morphToMany('App\Category', 'categoryofauction');
    }

    public function bids()
    {
        return $this->hasMany('App\Bid');
    }

    public function comments()
    {
        return $this->hasMany('App\Comment', 'auctioncommented');
    }

    public function timeleft()
    {
        return date('M d, Y H:i:s',strtotime($this->limitdate));
    }
}
