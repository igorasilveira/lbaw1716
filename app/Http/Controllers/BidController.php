<?php

namespace App\Http\Controllers;

use App\Bid;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Auction;

class BidController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request)
    {
      $user = DB::insert( DB::raw("CREATE TEMPORARY TABLE current_user(username varchar);
          INSERT INTO current_user(username) VALUES (User::find(Auth::id())->username);"));

       $this->save();
    }

    public function bid($id, Request $request)
    {
      $this->authorize('bidOrBuy', Auction::find($id));
      // echo $request['value'];
      //'value', 'auction_id, 'user_id', 'isBuyNow'
      Bid::create([
        'value' => intval($request['value']),
        'user_id' => Auth::id(),
        'auction_id' => Auction::find($id)->id,
      ]);

      return redirect()->action(
        'AuctionController@show', ['id' => $id]
      );
    }

    public function buynow($id, Request $request)
    {
      $this->authorize('bidOrBuy', Auction::find($id));
      // echo $request['value'];
      //'value', 'auction_id, 'user_id', 'isBuyNow'

      $auction = Auction::find($id);
      Bid::create([
        'value' => intval($request['value']),
        'user_id' => Auth::id(),
        'auction_id' => $auction->id,
        'isBuyNow' => true,
      ]);


      $auction->update(['auctionwinner' => Auth::id()]);
      $auction->update(['finalprice' => intval($request['value'])]);

      date_default_timezone_set('Europe/Lisbon');
      $timestamp = date('Y-m-d H:i:s', time());
      $auction->update(['finaldate' => $timestamp]);
      $auction->update(['state' => 'Over']);

      return redirect()->action(
        'AuctionController@show', ['id' => $id]
      );
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
    }

    /**
     * Display the specified resource.
     *
     * @param \App\Bid $bid
     *
     * @return \Illuminate\Http\Response
     */
    public function show(Bid $bid)
    {
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param \App\Bid $bid
     *
     * @return \Illuminate\Http\Response
     */
    public function edit(Bid $bid)
    {
    }

    /**
     * Update the specified resource in storage.
     *
     * @param \Illuminate\Http\Request $request
     * @param \App\Bid                 $bid
     *
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Bid $bid)
    {
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param \App\Bid $bid
     *
     * @return \Illuminate\Http\Response
     */
    public function destroy(Bid $bid)
    {
    }

}
