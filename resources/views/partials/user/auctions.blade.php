<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
    <h1 class="display-6">My Auctions</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>
<div class="container">
  <div id="bidding"
       class="container-fluid">
    <div id="bidViewer">
      <h2> Bidding </h2>
      @if (count($buying) > 0)
      <ul id="auctionsMosaic"
          class="container-fluid row col-sm-12 row">
          @for ($i = 0 ; $i < min(6, count($buying)); $i++)
          <li class="col-sm-4">
            @include('partials.auctionMosaic', ['auction' => $buying->slice($i, 1)->first()])
      </li>
          @endfor
      </ul>
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
              @for ($j = $i; $j < count($buying); $j++)
                <tr>
                  <td scope="row"><img src="{{ $selling->slice($j, 1)->first()->pathtophoto }}"
                    width="80"
                    height="80"></td>
                    <td> <a href="#">{{$buying->slice($j, 1)->first()->title}}</a> </td>
                    <td>{{$buying->slice($j, 1)->first()->minimumsellingprice}}€</td>
                    <!-- TODO value of last bid-->
                    <td>€</td>
                    <!-- TODO lifetime-->
                    <td>5-03-2018</td>
                </tr>
              @endfor
              </tbody>
            </table>
            <div id="pagination">
          <ul class="pagination pagination-sm">
            <li class="page-item disabled">
              <a class="page-link"
                 href="#">&laquo;</a>
            </li>
            <li class="page-item active">
              <a class="page-link"
                 href="#">1</a>
            </li>
            <li class="page-item">
              <a class="page-link"
                 href="#">2</a>
            </li>
            <li class="page-item">
              <a class="page-link"
                 href="#">3</a>
            </li>
            <li class="page-item">
              <a class="page-link"
                 href="#">4</a>
            </li>
            <li class="page-item">
              <a class="page-link"
                 href="#">5</a>
            </li>
            <li class="page-item">
              <a class="page-link"
                 href="#">&raquo;</a>
            </li>
          </ul>
        </div>
        </div>
      </div>
    </div>
    @endif
  </div>
  @else
    <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
      <strong class="alert-link">Ups!</strong> You are currently not <strong>bidding</strong> on any items.
    </div>
  @endif
  <hr class="my-5">
  <div id="selling"
       class="container-fluid">
    <h2> Selling </h2>
    @if (count($selling) > 0)
      <ul id="auctionsMosaic"
      class="container-fluid row col-sm-12 row">
      @for ($i = 0 ; $i < min(6, count($selling)); $i++)
      <li class="col-sm-4">
        @include('partials.auctionMosaic', ['auction' => $selling->slice($i, 1)->first()])
  </li>
      @endfor
  </ul>

   <!-- Mostrar restantes auctions se existirem -->
  @if (count($selling) > 6)
    <button type="button"
    class="btn
    btn-block
    btn-primary
    dropdown-toggle
    my-4"
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
      <table class="sellsListViewMore table table-hover">
      <thead>
        <tr class="table-dark">
          <th scope="col">Photo of Item</th>
          <th scope="col">Name of Auction</th>
          <th scope="col">Minimum Value</th>
          <th scope="col">Value of last Bid</th>
          <th scope="col">Lifetime of Auction</th>
        </tr>
      </thead>
      <tbody>
        @for ($j = $i; $j < count($selling); $j++)
          <tr>
            <td scope="row"><img src="{{ $selling->slice($j, 1)->first()->pathtophoto }}"
              width="80"
              height="80"></td>
              <td> <a href="#">{{$selling->slice($j, 1)->first()->title}}</a> </td>
              <td>{{$selling->slice($j, 1)->first()->minimumsellingprice}}€</td>
              <!-- TODO value of last bid-->
              <td>€</td>
              <!-- TODO lifetime-->
              <td>5-03-2018</td>
          </tr>
        @endfor

                </tbody>
              </table>
              <div id="pagination">
                <ul class="pagination pagination-sm">
                  <li class="page-item disabled">
                    <a class="page-link"
                    href="#">&laquo;</a>
                  </li>
                  <li class="page-item active">
                    <a class="page-link"
                    href="#">1</a>
                  </li>
                  <li class="page-item">
                    <a class="page-link"
                    href="#">2</a>
                  </li>
                  <li class="page-item">
                    <a class="page-link"
                    href="#">3</a>
                  </li>
                  <li class="page-item">
                    <a class="page-link"
                    href="#">4</a>
                  </li>
                  <li class="page-item">
                    <a class="page-link"
                    href="#">5</a>
                  </li>
                  <li class="page-item">
                    <a class="page-link"
                    href="#">&raquo;</a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
    </div>
    @endif
    @else
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> You are currently not <strong>selling</strong> any items.
      </div>
    @endif
</div>
