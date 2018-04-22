<?php

namespace App;

use Carbon\Carbon;
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
    'state', 'title', 'sellingreason', 'pathtophoto', 'startingprice', 'phonenumber', 'buynow', 'limitdate', 'auctioncreator',
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

    public function timeleft()
    {
        return ceil((strtotime($this->limitdate) - strtotime('now')) / 60 / 60);
    }

    public function undo_tz(Carbon $date)
    {
        $me = \Auth::user();
        $tz = $me->timezone ?: \Cookie::get('tz');

        return $date->subHours($tz);
    }
}
