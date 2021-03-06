<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Illuminate\Http\Request;
use App\User;
use App\Category;
use App\Auction;
use App\Edit_Categories;
use App\CategoryOfAuction;
use App\Mail\EMail;


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
        $this->authorize('adminPowers', User::class);
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
        $this->authorize('checkIfCanBlock', User::find($id));
        User::where('id', $id)->update(['blocked' => true]);

        $username = User::find($id)->username;

        return redirect()->action(
        'ProfileController@show', ['username' => $username]
      );
    }

    public function unblockUser($id)
    {
        $this->authorize('checkIfCanBlock', User::find($id));
        User::where('id', $id)->update(['blocked' => false]);

        $username = User::find($id)->username;

        return redirect()->action(
        'ProfileController@show', ['username' => $username]
      );
    }

    public function deleteModerator($username)
    {
        $this->authorize('adminPowers', User::class);
        $this->authorize('checkIfNotAdmin', User::where('username', $username)->get());
        User::where('username', $username)->update(['blocked' => true]);

        return null;
    }

    public function deleteCategory($id)
    {
        $this->authorize('adminPowers', User::class);
        Edit_Categories::where('category', $id)->delete();
        CategoryOfAuction::where('category_id', $id)->delete();

        $cats = Category::where('parent', $id)->get();
        foreach ($cats as $cat) {
            $cat->parent = null;
            $cat->save();
        }

        Category::find($id)->delete();

        return null;
    }

    public function addModerator(Request $request)
    {
        $this->authorize('adminPowers', User::class);
        $validator = $request->validate([
        'username' => 'required|string|max:255|unique:user',
        'email' => 'required|string|email|max:255|unique:user',
      ]);

        $password = $this->randomPassword();

        $user = User::create([
        'typeofuser' => 'Moderator',
        'username' => $request->input('username'),
        'email' => $request->input('email'),
        'password' => bcrypt($password),
        'pathtophoto' => '/images/catalog/users/default.png',
      ]);

        $email = $request->input('email');
        Mail::to($email)->send(new EMail($user,$password));

        return null;
    }

    public function randomPassword()
    {
        $alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
        $pass = array(); //remember to declare $pass as an array
      $alphaLength = strlen($alphabet) - 1; //put the length -1 in cache
      for ($i = 0; $i < 8; ++$i) {
          $n = rand(0, $alphaLength);
          $pass[] = $alphabet[$n];
      }

        return implode($pass); //turn the array into a string
    }

    public function addCategory(Request $request)
    {
        $this->authorize('adminPowers', User::class);
        $category = new Category();
        $category->name = $request->input('categoryName');
        if ('N/A' != $request->input('parent')) {
            $category->parent = Category::where('name', $request->input('parent'))->first()->id;
        }
        $category->save();

        return null;
    }

    public function approve()
    {
    }

    public function approveAuction($auctionid)
    {
        $auction = Auction::find($auctionid);
        $this->authorize('approveOrReject', $auction);
        $mod = Auth::user()->id;
        $auction->update(['state' => 'Active']);
        $auction->update(['responsiblemoderator' => $mod]);

        return redirect()->action(
        'ProfileController@manageAuctions', ['username' => Auth::user()->username]
      );
    }

    public function rejectAuction(Request $request, $auctionid)
    {
        $auction = Auction::find($auctionid);
        $this->authorize('approveOrReject', $auction);
        
        $mod = Auth::user()->id;
        $reason = $request->input('reasonOfRefusal');

        date_default_timezone_set('Europe/Lisbon');
        $timestamp = date('Y-m-d H:i:s', time());

        $auction->update(['responsiblemoderator' => $mod]);
        $auction->update(['reasonofrefusal' => $reason]);
        $auction->update(['refusaldate' => $timestamp]);
        $auction->update(['state' => 'Rejected']);

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
