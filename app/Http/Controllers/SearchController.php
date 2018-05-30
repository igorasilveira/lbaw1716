<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Auction;
use App\User;

class SearchController extends Controller
{
    public function searchSystem(Request $request)
    {
        $search = $request->input('search');

        return view('pages.searchResults', ['search' => $search, 'results' => $this->search($search)]);
    }

    public function search($search)
    {
        $results_auctions = Auction::whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_auctions');
        $results_users = User::whereRaw('textsearchable_user_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_user_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_users');

        $results_auctions->withPath('search?search='.$search);
        $results_users->withPath('search?search='.$search);

        return ['users' => $results_users, 'auctions' => $results_auctions];
    }

    public function searchBuying($search)
    {
        $results_auctions = Auction::whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_auctions');

        $results_auctions->withPath('search?search='.$search);

        return ['users' => $results_users, 'auctions' => $results_auctions];
    }

    public function searchSelling($search)
    {
        $results_auctions = Auction::whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_auctions');
        $results_users = User::whereRaw('textsearchable_user_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_user_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_users');

        $results_auctions->withPath('search?search='.$search);
        $results_users->withPath('search?search='.$search);

        return ['users' => $results_users, 'auctions' => $results_auctions];
    }

    public function searchPending($search)
    {
        $user = Auth::user();

        $pending = $user->pending()->get();
        $moderating = $user->auctionsModerating()->get();

        $moderating_m6 = null;
        if(count($moderating) > 6)
        $moderating_m6 = $user->auctionsModerating_m6();

        $results_auctions = $user->pending()->whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_pending');
        $results_auctions->withPath('search?search='.$search);

        return view('pages.user.manageAuctions', ['user' => $user, 'pending' => $pending, 'moderating' => $moderating,'search' => $search, 'pending_m6' => $results_auctions, 'moderating_m6' => $moderating_m6]);
    }

    public function searchModerating($search)
    {
        $results_auctions = Auction::whereRaw('textsearchable_auction_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_auction_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_auctions');
        $results_users = User::whereRaw('textsearchable_user_col @@ plainto_tsquery(\'english\', ?)', [$search])->orderByRaw('ts_rank(textsearchable_user_col, plainto_tsquery(\'english\', ?)) DESC', [$search])->paginate(5, ['*'], '_users');

        $results_auctions->withPath('search?search='.$search);
        $results_users->withPath('search?search='.$search);

        return ['users' => $results_users, 'auctions' => $results_auctions];
    }
}
