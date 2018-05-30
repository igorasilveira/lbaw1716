<?php

namespace App\Http\Controllers;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Auction;
use App\User;
use Carbon\Carbon;

class SearchController extends Controller
{
    public function searchSystem(Request $request)
    {
        $search = $request->input('search');

        return view('pages.searchResults', ['search' => $search, 'results' => $this->search($search)]);
    }

    public function endingsoonest()
    {
        $now = new Carbon('Europe/Lisbon');
        $results_auctions = Auction::where('state', 'Active')->where('limitdate', '>=', $now)->orderBy('limitdate', 'ASC')->take(10)->get();

        return view('pages.lateralSearch', ['search' => 'Ending Soonest', 'results' => $results_auctions->all()]);
    }

    public function newlylisted()
    {
        $now = new Carbon('Europe/Lisbon');
        $results_auctions = Auction::where('state', 'Active')->where('startdate', '<=', $now)->orderBy('startdate', 'DESC')->take(10)->get();

        return view('pages.lateralSearch', ['search' => 'Newly Listed', 'results' => $results_auctions->all()]);
    }

    public function mostbids()
    {
        $results_auctions = Auction::where('state', 'Active')->orderBy('numberofbids', 'DESC')->take(10)->get();

        return view('pages.lateralSearch', ['search' => 'Most Bids', 'results' => $results_auctions->all()]);
    }

    public function lowestprice()
    {
        $results_auctions = Auction::where('state', 'Active')->where('numberofbids', '>', 0)->get()->all();
        $result = new Collection();
        foreach ($results_auctions as $res) {
            $result->push(['auction' => $res, 'greatestvalue' => $res->bids->sortByDesc('date')->first()->value]);
        }
        $results = $result->sortBy('greatestvalue')->take(10);

        return view('pages.lateralSearch', ['search' => 'Lowest Price', 'results' => $results->pluck('auction')]);
    }

    public function highestprice()
    {
        $results_auctions = Auction::where('state', 'Active')->where('numberofbids', '>', 0)->get()->all();
        $result = new Collection();
        foreach ($results_auctions as $res) {
            $result->push(['auction' => $res, 'greatestvalue' => $res->bids->sortByDesc('date')->first()->value]);
        }
        $results = $result->sortByDesc('greatestvalue')->take(10);

        return view('pages.lateralSearch', ['search' => 'Lowest Price', 'results' => $results->pluck('auction')]);
    }

    public function search($search)
    {
        $results_auctions = Auction::whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_auctions');
        $results_users = User::whereRaw('textsearchable_user_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_user_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_users');

        $results_auctions->withPath('search?search='.$search);
        $results_users->withPath('search?search='.$search);

        return ['users' => $results_users, 'auctions' => $results_auctions];
    }

    public function searchBuying(Request $request)
    {
        $search = $request->input('search');
        $user = Auth::user();

        $buying = $user->auctionsBidding()->get();
        $selling = $user->auctionsSelling()->get();

        $selling_m6 = null;
        if (count($selling) > 6) {
            $selling_m6 = $user->auctionsSelling_m6();
        }

        $results_auctions = $user->auctionsBidding()->whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_bidding');
        $results_auctions->withPath('search?search='.$search);

        return view('pages.user.auctions', ['user' => $user, 'buying' => $buying, 'selling' => $selling, 'search' => $search, 'buying_m6' => $results_auctions, 'selling_m6' => $selling_m6]);
    }

    public function searchSelling(Request $request)
    {
        $search = $request->input('search');
        $user = Auth::user();

        $buying = $user->auctionsBidding()->get();
        $selling = $user->auctionsSelling()->get();

        $buying_m6 = null;
        if (count($buying) > 6) {
            $buying_m6 = $user->auctionsBidding_m6();
        }

        $results_auctions = $user->auctionsSelling()->whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_selling');
        $results_auctions->withPath('search?search='.$search);

        return view('pages.user.auctions', ['user' => $user, 'buying' => $buying, 'selling' => $selling, 'search' => $search, 'buying_m6' => $buying_m6, 'selling_m6' => $results_auctions]);
    }

    public function searchPending(Request $request)
    {
        $search = $request->input('search');
        $user = Auth::user();

        $pending = $user->pending()->get();
        $moderating = $user->auctionsModerating()->get();

        $moderating_m6 = null;
        if (count($moderating) > 6) {
            $moderating_m6 = $user->auctionsModerating_m6();
        }

        $results_auctions = $user->pending()->whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_pending');
        $results_auctions->withPath('search?search='.$search);

        return view('pages.user.manageAuctions', ['user' => $user, 'pending' => $pending, 'moderating' => $moderating, 'search' => $search, 'pending_m6' => $results_auctions, 'moderating_m6' => $moderating_m6]);
    }

    public function searchModerating(Request $request)
    {
        $search = $request->input('search');
        $user = Auth::user();

        $pending = $user->pending()->get();
        $moderating = $user->auctionsModerating()->get();

        $pending_m6 = null;
        if (count($pending) > 6) {
            $pending_m6 = $user->pending_m6();
        }

        $results_auctions = $user->auctionsModerating()->whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_moderating');
        $results_auctions->withPath('search?search='.$search);

        return view('pages.user.manageAuctions', ['user' => $user, 'pending' => $pending, 'moderating' => $moderating, 'search' => $search, 'pending_m6' => $results_auctions, 'moderating_m6' => $moderating_m6]);
    }
}
