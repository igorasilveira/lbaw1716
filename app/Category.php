<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'category';

    protected $fillable = ['name', 'parent'];

    public $timestamps = false;

    public function parent()
    {
        return self::find(self::parent);
    }

    public function auctions()
    {
        return $this->belongsToMany('App\Auction', 'categoryofauction');
    }

    public function active_auctions()
    {
        return $this->auctions()->where('state', 'Active')->orderby('numberofbids', 'DESC')->orderby('limitdate', 'ASC');
    }

    public function active_auctions_m6()
    {
        $active_auctions = $this->active_auctions()->skip(5)->take(1)->get()->first();
        $numberofbids_6 = $active_auctions->numberofbids;
        $limitdate_6 = $active_auctions->limitdate;

        return $this->active_auctions()->where('numberofbids', '<=', $numberofbids_6)->where('limitdate', '>', $limitdate_6)->paginate(5);
    }

    public function hasChilds()
    {
        return static::where('parent', $this['id'])->count();
    }
}
