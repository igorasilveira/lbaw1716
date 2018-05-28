<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\User;
use App\Category;
use App\Auction;
use Carbon\Carbon;

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
    $moderators = User::where('typeofuser', 'Moderator')->get();
    $categories = Category::all();

    return view('pages.admin.adminManagement',[
    'moderators' => $moderators,
    'categories' => $categories]);
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
    //$user = User::delete()->where('username', $username)->first();
    User::where('username', $username)->delete();


  }

  public function approveAuction($auctionid)
  {
    $auction = Auction::find($auctionid);
    $mod = Auth::user()->id;
    $auction->update(['state' => 'Active']);
    $auction->update(['responsiblemoderator' => $mod]);


    return redirect()->action(
      'ProfileController@manageAuctions', ['username' => Auth::user()->username]
    );


  }

  public function preview(Request $request)
  {
    $auction = $request;

    return view('pages.auction', ['auction' => $auction]);
  }
}
