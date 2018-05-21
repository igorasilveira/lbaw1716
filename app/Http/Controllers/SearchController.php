<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Auction;
use App\User;

class SearchController extends Controller
{
  public function searchSystem(Request $request)
  {
    $search = $request->input('search');
    return view('pages.searchResults',['search' => $search,'results' => $this->search($search)]);
  }

  public function search($search){
    return User::whereRaw('textsearchable_user_col @@ plainto_tsquery(\'english\', ?)',[$search])->orderByRaw('ts_rank(textsearchable_user_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->get()->merge(Auction::whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)',[$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->get());
  }
}
