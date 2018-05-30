<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
    <h1 class="display-6">My Auctions</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>
<div class="container">
  <div id="bidding" class="container-fluid">
    <h2> Pending </h2>
    <div id="bidViewer">
      @if (count($pending) > 0)
        <ul id="auctionsMosaic"
        class="container-fluid row col-sm-12 row">
        @foreach($pending->take(6) as $auction)
        <li class="col-sm-4">
          @include('partials.auctionMosaic', ['auction' => $auction])
        </li>
        @endforeach
      </ul>
      @else
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> There are no <strong>pending</strong> auctions currently.
      </div>
    @endif
  </div>
  @if (count($pending) > 6)
  <button type="button"
  class="btn
  btn-block
  btn-secondary
  dropdown-toggle"
  data-toggle="collapse"
  data-target=".pendingListViewMore">
  View More
</button>
<div>
  <div class="pendingListViewMore container-fluid collapse">
    <div class="container-fluid">
      <hr class="my-3">
      <form class="form-inline my-2 my-lg-0"
      action="manageAuctions/pending/search" method="GET">
        <input class="form-control col-7"
        placeholder="Search"
        name="search"
        type="text">
        <span class="col-1"></span>
        <button class="btn btn-primary my-2 col-4"
        type="submit">Search</button>
      </form>
      <hr class="my-3">
    </div>
    <div class="table-responsive">
      @if(count($pending_m6) == 0)
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> There are no <strong>pending</strong> auctions with that word in title or description.
      </div>
      @else
      <table class="bidsListViewMore table-responsive table-hover">
        <thead>
          <tr class="table-info">
            <th scope="col">Photo of Item</th>
            <th scope="col">Name of Auction</th>
            <th scope="col">Name of Seller</th>
            <th scope="col">Lifetime of Auction</th>
          </tr>
        </thead>
        <tbody>
          @foreach($pending_m6 as $auction)
          <tr>
            <td scope="row"><img src="{{ $auction->pathtophoto }}"
              alt="Auction Item Image"
              width="80"
              height="80"></td>
              <td width="50%"> <a href="/auction/{{ $auction->id }}"> {{ $auction->title }} </a> </td>
              <td width="15%"> {{ App\User::find($auction->auctioncreator)->username }} </td>
              <td width="15%"> {{ $auction->timeleft() }} </td>
            </tr>
            @endforeach
          </tbody>
        </table>
        <br />
        <div class="container-fluid my-4">
          {{ $pending_m6->links() }}
        </div>
        @endif
      </div>
      @endif
    </div>
    <hr class="my-5">
    <div id="selling" class="container-fluid">
      <h2> Selling </h2>
      <div id="bidViewer">
        @if (count($moderating) > 0)
        <ul id="auctionsMosaic"
        class="container-fluid row col-sm-12 row">
        @foreach($moderating->take(6) as $auction)
        <li class="col-sm-4">
          @include('partials.auctionMosaic', ['auction' => $auction])
        </li>
        @endforeach
      </ul>
      @else
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> You are currently not <strong>moderating</strong> any auctions.
      </div>
      @endif
    </div>
    @if (count($moderating) > 6)
    <button type="button"
    class="btn
    btn-block
    btn-secondary
    dropdown-toggle"
    data-toggle="collapse"
    data-target=".moderatingListViewMore">
    View More
  </button>
  <div class="moderatingListViewMore container-fluid collapse">
    <div class="container-fluid">
      <hr class="my-3">
      <form class="form-inline my-2 my-lg-0"
      action="manageAuctions/moderating/search" method="GET">
        <input class="form-control col-7"
        placeholder="Search"
        type="text">
        <span class="col-1"></span>
        <button class="btn btn-primary my-2 col-4"
        type="submit">Search</button>
      </form>
      <hr class="my-3">
    </div>
    <div class="table-responsive">
      @if(count($moderating_m6) == 0)
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> You have no <strong>moderating</strong> auctions with that word in title or description.
      </div>
      @else
      <table class="sellsListViewMore table-responsive table-hover">
        <thead>
          <tr class="table-info">
            <th scope="col">Photo of Item</th>
            <th scope="col">Name of Auction</th>
            <th scope="col">Minimum Value</th>
            <th scope="col">Value of last Bid</th>
            <th scope="col">Lifetime of Auction</th>
          </tr>
        </thead>
        <tbody>
          @foreach($moderating_m6 as $auction)
          <tr>
            <td scope="row"><img src="{{ $auction->pathtophoto }}"
              alt="Auction Item Image"
              width="80"
              height="80"></td>
              <td width="50%"> <a href="/auction/{{ $auction->id }}"> {{ $auction->title }} </a> </td>
              <td> {{ $auction->minimumsellingprice }} </td>
              <td>
                @if($auction->bids->count() > 0)
                {{ $auction->bids->sortByDesc('date')->first()->value }} €
                @else
                0 €
                @endif
              </td>
              <td> {{ $auction->timeleft() }} </td>
            </tr>
            @endforeach
          </tbody>
        </table>
        <br />
        <div class="container-fluid my-4">
          {{ $moderating_m6->links() }}
        </div>
        @endif
      </div>
    </div>
    @endif
  </div>
</div>
