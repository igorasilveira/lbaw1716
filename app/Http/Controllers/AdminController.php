<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\User;
use App\Category;
use App\Edit_Categories;

class AdminController extends Controller
{
    public function __construct()
    {
        $this->middleware('guest');
    }

    /**
     * Show the about page.
     *
     * @return \Illuminate\Http\Response
     */
    public function show()
    {
        $moderators = User::where('typeofuser', 'Moderator')->where('blocked', 'false')->get();
        $categories = Category::all();

        return view('pages.admin.adminManagement', [
    'moderators' => $moderators,
    'categories' => $categories, ]);
    }

    public function create()
    {
        if (!Auth::check()) {
            return redirect('/login');
        }

        $this->authorize('create', Auction::class);

        return view('pages.auctionCreate');
    }

    public function deleteModerator($username)
    {
        User::where('username', $username)->update(['blocked' => true]);
        return null;
    }

    public function deleteCategory($id)
    {
        Edit_Categories::where('category',$id)->delete();
        Category::find($id)->delete();
        return null;
    }

    public function approve()
    {
    }

    public function preview(Request $request)
    {
        $auction = $request;

        return view('pages.auction', ['auction' => $auction]);
    }
}
