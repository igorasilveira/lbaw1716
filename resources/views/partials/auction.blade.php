<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0  p-3">
    <h1 class="display-6">Auction {{ $auction->title}}</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="jumbotron">

  <div id="profile-container"
       class="w-75 mx-auto">
    <div class="row">
      <div class="col-md-6 col-sm-12 col-xs-12"> <a href="#"
           title="Item 1"><img src="{{ $auction->pathtophoto }}"
      class="mb-4 box-shadow w-border w-100" title="Auction Image"></a> </div>
      <div id="info-container"
           class="col-md-6 col-sm-12 col-xs-12 vcen container-fluid ">
        <div class="text-md-right text-xs-center">
          <section class="pb-2">
            <h5 class="text-muted">#{{ $auction->id }}</h5>
            <h4>By <a href="/users/{{ $auction->creator }}"> {{ $auction->creator->username }} </a>
              @if($auction->creator->rate != NULL)
              <span class=" mx-4 badge badge-pill badge-info">
                {{ $auction->creator->rate }}/5
              </span>
              @endif
            </h4>
          </section>
          <section>
            <p>
              {{ $auction->title }}
            </p>
            <p>
              {{ substr($auction->description,0,100) }}
            </p>
          </section>
          <h3 class="text-info pb-2">14H 23M 09S</h3>
        </div>
        <div id="buyPanel"
             class="text-center w-100 border border-dark p-2 d-inline-block">
          <h4 class="pb-2">Bidding</h4>
          <hr class="py-0" />
          <!-- BID BUTTON AREA -->
          <div class="row">
            <div class="col-lg-4 col-md-6 col-sm-12 col-xs-12 my-auto">
              <h5 class="align-bottom">Starting Bid: </h5>
            </div>
            <div class="col-lg-4 col-md-6 col-sm-12 col-xs-12 my-auto">
              <p>
                {{ $auction->startingprice }} €
              </p>
            </div>
            <div class="col-lg-4 col-md-0 col-sm-12 col-xs-12 my-auto">

            </div>
          </div>
          <hr class="my-2">
          <div class="row">
            <div class="col-lg-4 col-md-6 col-sm-12 col-xs-12 my-auto">
              <h5 class="align-bottom">Current Bid: </h5>
            </div>
            <div class="col-lg-4 col-md-6 col-sm-12 col-xs-12 my-auto">
              <p>
                @if($auction->bids->count() > 0)
                {{ $auction->bids->sortByDesc('date')->first()->value }} €
                @else
                0 €
                @endif
              </p>
            </div>
            @if($auction->state == 'Active')
            @if(Auth::id() != $auction->auctionCreator)
            <form class="col-lg-4 col-md-12 col-sm-12 col-xs-12">
                {{ csrf_field() }}
                  @if($auction->bids->count() > 0)
                  <input name="value" type="hidden" value="{{ $auction->bids->sortByDesc('date')->first()->value + 0.10*($auction->bids->sortByDesc('date')->first()->value) }}" />
                  @else
                  <input name="value" type="hidden" value="{{ $auction->startingprice }}" />
                  @endif
                <button type="submit"
                        name="placeBidBtn"
                        formaction="/auction/bid/{{ $auction->id }}"
                        formmethod="post"
                        class="btn btn-success w-100">
                        Bid
                        <span id="auctionBid">
                        @if($auction->bids->count() > 0)
                        {{ $auction->bids->sortByDesc('date')->first()->value + 0.10*($auction->bids->sortByDesc('date')->first()->value) }}
                        @else
                        {{ $auction->startingprice }}
                        @endif
                        </span>
                        €
                </button>
              </form>
          </div>
          <hr class="my-2">
          <!-- BUY NOW BUTTON AREA -->
          <form class="w-100">
            {{ csrf_field() }}
            <input name="value" type="hidden" value="{{ $auction->buynow }}"/>
            <button type="submit"
                    name="placeBidBtn"
                    formaction="/auction/buy-now/{{ $auction->id }}"
                    formmethod="post"
                    class="btn btn-info mw-75 text-center">
                    Buy Now {{ $auction->buynow }} €
            </button>
          </form>
          @endif
          @else
          @if($auction->state == 'Over')
        </div>
            <hr class="my-2">
            <div class="w-100 alert alert-dismissible alert-info">
              <p>
                Auction Over!!!
              </p>
            </div>
          @endif
          @endif
        </div>
      </div>
    </div>
  </div>
</div>
<hr class="pb-4">
<div id="auction-meta"
     class="container mx-auto">
  <ul class="nav nav-tabs">
    <li class="nav-item"><a class="nav-link active show"
         data-toggle="tab"
         href="#info">More Info</a></li>
    <li class="nav-item"><a class="nav-link"
         data-toggle="tab"
         href="#comments">Comments</a></li>
    <li class="nav-item"><a class="nav-link"
         data-toggle="tab"
         href="#contacts">Contacts</a></li>
  </ul>
  <div class="tab-content">
    <div class="tab-pane fade active show"
         id="info"
         role="tabpanel"
         aria-labelledby="info-tab">
      <div class="info">
        <section class="my-4">
          <h4>Description</h4>
          <p>
            {{ $auction->description }}
          </p>
        </section>
        <hr class="my-2">
        <section class="my-4">
          <h4>Selling Reason</h4>
          <p>
            {{ $auction->sellingreason }}
          </p>
        </section>
      </div>
    </div>
    <div class="tab-pane fade"
         id="comments"
         role="tabpanel"
         aria-labelledby="comments-tab">
      <div class="alert alert-dismissible alert-warning my-3">
        <button type="button"
                class="close"
                data-dismiss="alert">&times;</button>
        <h4 class="alert-heading">Warning!</h4>
        <p class="mb-0">All comments are supervised by the auction's moderator. Keep within the site's for the commenting section. <span class="alert-link">Breaking the rules may result in an account ban.</span>.</p>
      </div>
      <blockquote class="blockquote my-4">
        <p class="mb-0">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer posuere erat a ante.</p>
        <footer class="blockquote-footer"><cite title="Source Title"><a>anotherUser</a></cite></footer>
      </blockquote>
      <hr class="my-2">
      <blockquote class="blockquote my-4">
        <p class="mb-0">Ut lorem mauris, ultrices ac ante nec, cursus porta ipsum. Morbi felis felis, finibus ut vestibulum at, feugiat vel lorem. Nulla sapien dui, porttitor in nulla non, aliquet ultricies enim. Ut semper ac enim eget porta. Morbi arcu mauris, auctor
          eget ex sed, condimentum eleifend nibh. Aenean risus dolor, placerat sit amet nisl imperdiet, feugiat aliquam odio. Vestibulum metus ex, molestie eu tempus eu, tristique quis elit. Maecenas nec neque posuere, aliquam quam sed, lobortis velit.
          Vivamus semper quam id accumsan porta. Morbi in hendrerit orci, sit amet volutpat diam.</p>
        <footer class="blockquote-footer"><cite title="Source Title"><a>niceUsername</a></cite></footer>
      </blockquote>
      <hr class="my-2">
      <blockquote class="blockquote my-4">
        <p class="mb-0">In sollicitudin tellus nec ex lacinia rutrum. Suspendisse potenti. Ut cursus efficitur ante, at mollis ligula rhoncus quis. Integer laoreet nibh a massa feugiat, sit amet sagittis risus vulputate. Integer tincidunt metus pellentesque justo
          rutrum, eget faucibus libero porta.</p>
        <footer class="blockquote-footer">Someone famous in <cite title="Source Title"><a>Igor</a></cite></footer>
      </blockquote>
      <hr class="my-2">
    </div>
    <div class="tab-pane fade"
         id="contacts"
         role="tabpanel"
         aria-labelledby="contacts-tab">
      <section class="my-4">
        <h4>Phone Number</h4>
        <p>
          {{ $auction->creator->phonenumber }}
        </p>
      </section>
      <hr class="my-2">
      <section class="my-4">
        <h4>Email Address</h4>
        <p>
          {{ $auction->creator->email }}
        </p>
      </section>
    </div>
  </div>
</div>
