<?php

namespace App\Http\Controllers;

use App\Category;

class CategoryController extends Controller
{
    public function showAuctionsFromCategory($id)
    {
        $category = Category::find($id);

        return view('pages.category', ['category' => $category]);
    }
}
