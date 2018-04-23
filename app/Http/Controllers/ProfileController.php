<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\User;
use App\Bid;
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

        return view('pages.user.profile', ['user' => $user, 'bought' => $bought, 'sold' => $sold, 'pending' => $pending]);
    }

    /**
     * Show the user's live auctions page.
     *
     * @return \Illuminate\Http\Response
     */
    public function auctions($id)
    {
        $user = User::find($id);
        //$this->authorize('view', $user);

        $selling = Auction::all()->where('auctioncreator', $id);
        // TODO mudar query dos buying
        $buyingIds = Bid::all()->where('user_id', $id)->pluck('auction_id');
        $buying = Auction::whereIn('id', $buyingIds)->where('state', 'Active')->get();

        return view('pages.user.auctions', ['user' => $user, 'selling' => $selling, 'buying' => $buying]);
    }

    /**
     * Show the profile edit page.
     *
     * @return \Illuminate\Http\Response
     */
    public function edit($username)
    {
      $user = User::where('username', $username)->first();
        return view('pages.user.edit', ['user' => $user]);
    }
}
