<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Auction;
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
    if (!Auth::check()) {
      return redirect('/login');
    }

    $this->authorize('create', Auction::class);

    return view('pages.auctionCreate');
  }

  public function save(Request $request)
  {
    $auctionDuration = $request->input('auctionDuration');
    $now = new Carbon('Europe/Lisbon');
    $dateFinished = $now->addDays($auctionDuration);

    $validator = $request->validate([
      'pathtophoto' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
      'title' => 'required|min:4|max:25',
      'category' => 'required|exists:category,id',
      'reason' => 'required|min:5|max:25',
      'startingprice' => 'required|numeric|min:1',
      'minimumsellingprice' => 'nullable|min:'.$request['startingprice'],
      'buynow' => 'nullable|min:'.$request['minimumsellingprice']
    ]);

    $auction = Auction::create([
      'state' => 'Pending',
      'title' => $request->input('title'),
      'category' => $request['category'],
      'description' => $request->input('description'),
      'sellingreason' => $request->input('reason'),
      'startingprice' => $request->input('startingprice'),
      'minimumsellingprice' => $request->input('minimumsellingprice'),
      'buynow' => $request->input('buynow'),
      'limitdate' => $dateFinished,
      'auctioncreator' => Auth::user()->id,
    ]);

    $file_name = '';

    if ($request->file('pathtophoto')) {
      $file = $auction->id.'.'.$request->file('pathtophoto')->getClientOriginalExtension();
      $request->file('pathtophoto')->move(
        base_path().'/public/images/catalog/auctions/', $file
      );
      $file_name = '/images/catalog/auctions/'.$file;
    } else {
      $file_name = '/images/catalog/auctions/default.png';
    }

    $auction->pathtophoto = $file_name;
    $auction->save();

    return redirect('auction/' . $auction->id);
  }

  public function rate(Request $request)
  {
    $auction = Auction::find($request->input('id'));
    $auction->update(['rate' => $request->input('rate')]);
    return null;
  }

}
