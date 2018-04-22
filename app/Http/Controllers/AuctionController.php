<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Auction;
use App\Bid;

class AuctionController extends Controller
{
    /**
     * Show the about page.
     *
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $auction = Auction::find($id);

        //$this->authorize('show', $auction);

        return view('pages.auction', ['auction' => $auction]);
    }

    public function create()
    {
        return view('pages.auctionCreate');
    }

    public function save(array $data)
    {
        $auctionDuration = $data['auctionDuration'];
        $now = new DateTime();
        $date = $now->format('Y/m/d H:i:s');

        return Auction::create([
      'state' => 'Pending',
      'title' => $data['title'],
      'sellingreason' => $data['reason'],
      'pathtophoto' => $data['pathtophoto'],
      'startingprice' => $data['startingprice'],
      'minimumsellingprice' => $data['minimumsellingprice'],
      'buynow' => $data['buynow'],
      'limitdate' => $date + $auctionDuration,
      'postalcode' => $data['postalCode'],
      'auctionCreator' => Auth::user()->id,
    ]);
    }

    public function approve()
    {
    }

    public function bid($id, Request $request)
    {
        // echo $request['value'];
        //'value', 'auction_id, 'user_id', 'isBuyNow'
        return $bid = Bid::create([
          'value' => $request['value'],
          'user_id' => Auth::id(),
          'auction_id' => Auction::find($id)->id,
        ]);
    }

    public function buynow($id)
    {
        echo $request['value'];
        //'value', 'auction_id, 'user_id', 'isBuyNow'
        return Bid::create([
          'value' => $request['value'],
          'user_id' => Auth::id(),
          'auction_id' => $id,
          'isBuyNow' => true,
        ]);
    }
}
