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
  
  public function posts()
  {
    return $this->hasMany(Post::class);
  }
}
