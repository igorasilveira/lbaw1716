<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\User;
use App\Category;
use App\Auction;
use Carbon\Carbon;
use App\Edit_Categories;
use App\CategoryOfAuction;

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

    public function blockUser($id)
    {
        User::where('id', $id)->update(['blocked' => true]);

        $username = User::find($id)->username;

        return redirect()->action(
          'ProfileController@show', ['username' => $username]
        );
    }

    public function unblockUser($id)
    {
        User::where('id', $id)->update(['blocked' => false]);

        $username = User::find($id)->username;

        return redirect()->action(
          'ProfileController@show', ['username' => $username]
        );
    }

    public function deleteModerator($username)
    {
        User::where('username', $username)->update(['blocked' => true]);

        return null;
    }

    public function deleteCategory($id)
    {
        Edit_Categories::where('category', $id)->delete();
        CategoryOfAuction::where('category_id', $id)->delete();

        $cats = Category::where('parent', $id)->get();
        foreach($cats as $cat){
          $cat->parent = null;
          $cat->save();
        }

        Category::find($id)->delete();

        return null;
    }

    public function addModerator($username)
    {
      //User::where('username', $username)->update(['blocked' => true]);

      /*User::create([
       'typeofuser' => 'Moderator',
       'username' => $username,
       //'email' => $email,
     ]); */

      return null;
    }

    public function addCategory($id)
    {
      Edit_Categories::where('category', $id)->delete();
      CategoryOfAuction::where('category_id', $id)->delete();

      $cats = Category::where('parent', $id)->get();
      foreach($cats as $cat){
        $cat->parent = null;
        $cat->save();
      }

      Category::find($id)->delete();

      return null;
    }

    public function approve()
    {
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

  public function rejectAuction($auctionid, $reason)
  {
    $auction = Auction::find($auctionid);
    $mod = Auth::user()->id;



    dd($mod);

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
rn view('pages.auction', ['auction' => $auction]);
    }
}
