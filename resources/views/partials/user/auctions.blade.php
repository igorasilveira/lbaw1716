<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
    <h1 class="display-6">My Auctions</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>
<div class="container">
  <div id="bidding" class="container-fluid">
    <h2> Bidding </h2>
    <div id="bidViewer">
      @if (count($buying) > 0)
      <ul id="auctionsMosaic"
      class="container-fluid row col-sm-12 row">
      @foreach($buying->take(6) as $auction)
      <li class="col-sm-4">
        @include('partials.auctionMosaic', ['auction' => $auction])
      </li>
      @endforeach
    </ul>
    @else
    <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
      <strong class="alert-link">Ups!</strong> You are currently not <strong>bidding</strong> on any items.
    </div>
    @endif
  </div>
  @if (count($buying) > 6)
  <button type="button"
  class="btn
  btn-block
  btn-secondary
  dropdown-toggle"
  data-toggle="collapse"
  data-target=".bidsListViewMore">
  View More
</button>
<div>
  <div class="bidsListViewMore container-fluid collapse">
    <div class="container-fluid">
      <hr class="my-3">
      <form class="form-inline my-2 my-lg-0">
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
      @if(count($buying_m6) == 0)
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> You are not <strong>bidding</strong> on any auctions with {{ $search }} in title or description.
      </div>
      @else
      <table class="bidsListViewMore table-responsive table-hover">
        <thead>
          <tr class="table-info">
            <th scope="col">Photo of Item</th>
            <th scope="col">Name of Auction</th>
            <th scope="col">Name of Seller</th>
            <th scope="col">Value of my Bid</th>
            <th scope="col">Date of my Bid</th>
            <th scope="col">Value of last Bid</th>
            <th scope="col">Lifetime of Auction</th>
          </tr>
        </thead>
        <tbody>
          @foreach($buying_m6 as $auction)
          <tr>
            <td scope="row"><img src="{{ $auction->pathtophoto }}"
              alt="Auction Item Image"
              width="80"
              height="80"></td>
              <td width="30%"> <a href="/auction/{{ $auction->id }}"> {{ $auction->title }} </a> </td>
              <td> {{ App\User::find($auction->auctioncreator)->username }} </td>
              <td> {{ Auth::user()->lastBidUserAuction($auction)->value }} € </td>
              <td> {{ Auth::user()->lastBidUserAuction($auction)->date }} </td>
              <td> {{ $auction->bids->sortByDesc('date')->first()->value }} € </td>
              <td> {{ $auction->timeleft() }} </td>
            </tr>
            @endforeach
          </tbody>
        </table>
        <br />
        <div class="container-fluid my-4">
          {{ $buying_m6->links() }}
        </div>
        @endif
      </div>
      @endif
    </div>
    <hr class="my-5">
    <div id="selling" class="container-fluid">
      <h2> Selling </h2>
      <div id="bidViewer">
        @if (count($selling) > 0)
        <ul id="auctionsMosaic"
        class="container-fluid row col-sm-12 row">
        @foreach($selling->take(6) as $auction)
        <li class="col-sm-4">
          @include('partials.auctionMosaic', ['auction' => $auction])
        </li>
        @endforeach
      </ul>
      @else
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> You are currently not <strong>selling</strong> any items.
      </div>
      @endif
    </div>
    @if (count($selling) > 6)
    <button type="button"
    class="btn
    btn-block
    btn-secondary
    dropdown-toggle"
    data-toggle="collapse"
    data-target=".sellsListViewMore">
    View More
  </button>
  <div class="sellsListViewMore container-fluid collapse">
    <div class="container-fluid">
      <hr class="my-3">
      <form class="form-inline my-2 my-lg-0">
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
      @if(count($selling_m6) == 0)
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> You have no <strong>selling</strong> auctions with {{ $search }} in title or description.
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
          @foreach($selling_m6 as $auction)
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
                N/A
                @endif
              </td>
              <td> {{ $auction->timeleft() }} </td>
            </tr>
            @endforeach
          </tbody>
        </table>
        <br />
        <div class="container-fluid my-4">
          {{ $selling_m6->links() }}
        </div>
        @endif
      </div>
    </div>
    @endif
  </div>
</div>
