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

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'state', 'title', 'sellingreason', 'pathtophoto', 'startingprice', 'phonenumber', 'buynow', 'limitdate', 'postalcode', 'auctionCreator'
      ];

    /**
     * The user this auction belongs to.
     */
    public function user()
    {
        return $this->belongsTo('App\User');
    }
}
