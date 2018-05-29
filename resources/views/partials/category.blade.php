<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0  p-3 text-center">
    <h1 class="display-6"> {{ $category->name }}</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="container">
  <div id="bidding"
       class="container-fluid">
    <div id="bidViewer">
      <ul id="auctionsMosaic"
          class="container-fluid col-sm-12 row">
        <div class="row">
          @foreach($category->active_auctions()->take(3)->get() as $auction)
          @if($category->auctions()->where('state','Active')->count()>=3)
          <li class="col-md-4 col-sm-6 col-xs-6">
          @elseif($category->auctions()->where('state','Active')->count()==2)
          <li class="col-md-6 col-sm-6 col-xs-6">
          @else
          <li class="col-md-12 col-sm-6 col-xs-6">
          @endif
          @include('partials.auctionMosaic', ['auction' => $auction])
          </li>
          @endforeach
        </div>
        <hr class="my-5">
        <div class="row">
          @if($category->auctions->count() >= 6)
          @foreach($category->active_auctions()->skip(3)->take(3)->get() as $auction)
          @if($category->auctions()->where('state','Active')->count()>=6)
          <li class="col-md-4 col-sm-6 col-xs-6">
          @elseif($category->auctions()->where('state','Active')->count()==5)
          <li class="col-md-6 col-sm-6 col-xs-6">
          @else
          <li class="col-md-12 col-sm-6 col-xs-6">
          @endif
          @include('partials.auctionMosaic', ['auction' => $auction])
          </li>
          @endforeach
          @endif
        </div>
      </ul>
      <br />
    </div>

    @if($category->auctions->count() >= 6)
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
        <table class="bidsListViewMore table-responsive table-hover">
          <thead>
            <tr class="table">
              <th scope="col">Photo of Item</th>
              <th scope="col">Name of Auction</th>
              <th scope="col">Value of last Bid</th>
              <th scope="col">Open Untill</th>
            </tr>
          </thead>
          <tbody>
            @foreach($category->active_auctions_m6() as $auction)
            <tr>
              <td scope="row"><img src="{{ $auction->pathtophoto }}"
                width="80"
                height="80"></td>
                <td width="50%"> <a href="/auction/{{ $auction->id }}"> {{ $auction->title }} </a> </td>
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
            {{ $category->active_auctions_m6()->links() }}
          </div>
        </div>
      </div>
    @endif
  </div>
