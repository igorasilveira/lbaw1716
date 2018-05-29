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
        return $this->auctions()->where('state', 'Active')->orderby('numberofbids', 'DESC');
    }

    public function active_auctions_m6()
    {
        return $this->auctions()->where('state', 'Active')->orderby('numberofbids', 'DESC')->offset(6)->paginate(5);
    }

    public function hasChilds()
    {
        return static::where('parent', $this['id'])->count();
    }
}
