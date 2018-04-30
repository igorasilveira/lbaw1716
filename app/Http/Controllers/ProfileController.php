<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

use App\User;
use App\Bid;
use App\City;
use App\Country;
use App\Auction;

class ProfileController extends Controller
{
    /**
     * Show the profile page.
     *
     * @return \Illuminate\Http\Response
     */
    public function show($username)
    {
        $user = User::get()->where('username', '=', $username)->first();
        $bought = Auction::where('state', 'Over')->where('auctionwinner', $user->id)->get();
        $sold = Auction::where('state', 'Over')->where('auctioncreator', $user->id)->get();
        $pending = [];

        return view('pages.user.profile', ['user' => $user,
        'bought' => $bought,
        'sold' => $sold,
        'pending' => $pending,
      ]);
    }

    /**
     * Show the user's live auctions page.
     *
     * @return \Illuminate\Http\Response
     */
    public function auctions($username)
    {
        $user = User::get()->where('username', '=', $username)->first();
        //$this->authorize('view', $user);

        $selling = Auction::all()->where('auctioncreator', $user->id);
        // TODO mudar query dos buying
        $buyingIds = Bid::all()->where('user_id', $user->id)->pluck('auction_id');
        $buying = Auction::whereIn('id', $buyingIds)->where('state', 'Active')->get();

        return view('pages.user.auctions', ['user' => $user, 'selling' => $selling, 'buying' => $buying]);
    }

    /**
     * update user information after form submission
     *
     * @param array $data
     *
     * @return \App\User
     */
    public function edit(Request $request)
    {
      $request->session()->flash('form', 'edit');
      $user = User::get()->where('username', '=', $request['username'])->first();

      $validator = $request->validate([
          'username' => 'required|string|max:255|unique:user,username,' . $user->id,
          'completeName' => 'required|string|max:255',
          'phoneNumber' => 'nullable|numeric|max:25',
          'city' => 'required|string|min:3',
          'address' => 'required|string|min:5|max:255',
          'email' => 'required|string|email|max:255|unique:user,email,' . $user->id,
          'password' => 'nullable|string|min:6|confirmed',
      ]);

      User::find($request['id'])
                ->update([
                  'username' => $request['username'],
                  'completename' => $request['completeName'],
                  'phonenumber' => $request['phoneNumber'],
                  'city' => $request['city'],
                  'address' => $request['address'],
                  'email' => $request['email'],
                ]);

      return view('pages.user.profile', ['username' => $request['username']]);
    }
}
