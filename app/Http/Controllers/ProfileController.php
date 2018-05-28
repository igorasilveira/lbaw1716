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
        $us_type =  User::find($user->id)->typeofuser;

        if($us_type=='Normal'){
          $bought = Auction::where('state', 'Over')->where('auctionwinner', $user->id)->get();
          $sold = Auction::where('state', 'Over')->where('auctioncreator', $user->id)->get();
          $pending = [];

          return view('pages.user.profile', ['user' => $user,
          'bought' => $bought,
          'sold' => $sold,
          'pending' => $pending,
        ]);
      } else{

        $responAuct = Auction::where('state', 'Over')->where('responsiblemoderator', $user->id)->get();

        return view('pages.user.profile', ['user' => $user, 'responAuct' => $responAuct]);
      }
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
     * Show the moderator/admin's live auctions page.
     *
     * @return \Illuminate\Http\Response
     */
    public function manageAuctions($username)
    {
        $user = User::get()->where('username', '=', $username)->first();
        //$this->authorize('view', $user);

        $pending = Auction::all()->where('state', 'Pending');
        // TODO mudar query dos buying
        $moderating = Auction::all()->where('responsiblemoderator', $user->id)->where('state', 'Active' );

        return view('pages.user.manageAuctions', ['user' => $user, 'pending' => $pending, 'moderating' => $moderating]);
    }

    /**
     * update user information after form submission
     *
     * @param array $data
     *
     * @return \App\User
     */
    public function edit(Request $request, $username)
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


      $country = Country::find($request['country']);

      $city;
      //echo City::where('name', $data['city'])->get();
      if (0 == City::where('name', $request['city'])->count()) {
          $city = new City();
          $city->name = $request['city'];
          $city->country = $country->id;
          $city->save();
      } else {
          $city = City::where('name', $request['city'])->firstOrFail();
      }

      User::find($request['id'])
                ->update([
                  'username' => $request['username'],
                  'completename' => $request['completeName'],
                  'phonenumber' => $request['phoneNumber'],
                  'city' => $city->id,
                  'address' => $request['address'],
                  'email' => $request['email'],
                ]);

      return redirect('/users/' . $request['username']);
    }

    /**
     * update user profile picture after form submission
     *
     * @param array $data
     *
     * @return \App\User
     */
    public function editPhoto(Request $request)
    {
      $request->session()->flash('form', 'editPhoto');
      $user = User::find($request['id']);

      $validator = $request->validate([
        'photo' => 'image|mimes:jpg,png',
      ]);

      $filename = "";

      if ($request->file('photo')) {
        $file = $user->id.'.'.$request->file('photo')->getClientOriginalExtension();

        $request->file('photo')->move(
          base_path().'/public/images/catalog/users/', $file
        );
        $file_name = '/images/catalog/users/'.$file;
      } else {
        $file_name = '/images/catalog/users/default.png';
      }

       $user->update(['pathtophoto' => $file_name]);

       return redirect('/users/' . $request['username']);
    }
}
