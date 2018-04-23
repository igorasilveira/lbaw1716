<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\User;
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
        $user = User::where('username', '=', $username)->first();

        return view('pages.user.profile', ['user' => $user]);
    }

    /**
     * Show the profile page.
     *
     * @return \Illuminate\Http\Response
     */
    public function auctions($id)
    {
        $user = User::find($id);
        //$this->authorize('view', $user);

        $selling = Auction::all()->where('auctioncreator', '=', $id);
        // TODO mudar query dos buying
        $buying = Auction::all()->where('auctioncreator', '=', $id);

        return view('pages.user.auctions', ['user' => $user, 'selling' => $selling, 'buying' => $buying]);
    }
}
