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

  public function parent()
  {
    return self::find(self::parent);
  }

  public function auctions()
  {
    return $this->belongsToMany('App\Auction','categoryofauction');
  }

  public function hasChilds()
  {
    return static::where('parent', $this['id'])->count();
  }
}
