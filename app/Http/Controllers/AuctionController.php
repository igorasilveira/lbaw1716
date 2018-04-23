<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Auction;
use App\Bid;
use Carbon\Carbon;

class AuctionController extends Controller
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
    public function show($id)
    {
        $auction = Auction::find($id);

        //$this->authorize('view', $auction);

        return view('pages.auction', ['auction' => $auction]);
    }

    public function create()
    {
        $this->authorize('create');
        return view('pages.auctionCreate');
    }

    public function save(Request $request)
    {
        $auctionDuration = $request->input('auctionDuration');
        $now = new Carbon('Europe/Lisbon');
        $dateFinished = $now->addDays($auctionDuration);


        $file_name = "";

        if ($request->file('photo')) {
          $file = 'auctions/' . $auction->id.'.'.$request->file('photo')->getClientOriginalExtension();

          $request->file('photo')->move(
            base_path().'/public/images/catalog/', $file
          );
          $file_name = '/images/catalog/auctions/'.$file;
        } else {
          $file_name = '/images/catalog/auctions/default.png';
        }

       $auction = Auction::create([
        'state' => 'Pending',
        'title' => $request->input('title'),
        'description' => $request->input('description'),
        'sellingreason' => $request->input('reason'),
        'pathtophoto' => $file_name,
        'startingprice' => $request->input('startingprice'),
        'minimumsellingprice' => $request->input('minimumsellingprice'),
        'buynow' => $request->input('buynow'),
        'limitdate' => $dateFinished,
        'auctioncreator' => Auth::user()->id,
    ]);

      return self::show($auction->id);
    }

    public function approve()
    {
    }

}
