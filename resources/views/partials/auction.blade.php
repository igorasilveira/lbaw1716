<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0  p-3">
    <h1 class="display-6">Auction {{ $auction->title }}</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="jumbotron">
  <div id="profile-container"
       class="w-75 mx-auto">
       <script language="javascript">
       timecounter("{{ $auction->timeleft()}}",{{ $auction->id }});
       </script>
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
            <!--<p>
              {{ substr($auction->description,0,100) }}
            </p>-->
          </section>
          <h3 id="countdown_{{$auction->id}}"class="text-info pb-2">14H 23M 09S</h3>
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
            @if(Auth::id() != $auction->auctionCreator && Auth::check() && Auth::user()->typeofuser=='Normal' && Auth::user()->blocked==false)
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
          @if($auction->bids->count() == 0 || ($auction->bids->count() > 0 && $auction->bids->sortByDesc('date')->first()->value + 0.10*($auction->bids->sortByDesc('date')->first()->value) <= $auction->buynow))
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
          @endif
          @else
        </div>
        @if($auction->state == 'Pending' && (Auth::user()->typeofuser=='Administrator' || Auth::user()->typeofuser=='Moderator' ) )
        <div id="pendingActions"
        class="container mt-md-5 mt-sm-3 mt-3">
          <div class="row">
                    <button id="rejectbtt" class="btn btn-danger mw-75 text-center">Reject</button>

                  <a href="/admin/auction/{{$auction->id}}/approve">
                    <button class="btn btn-success mw-75 text-center">Accept</button>
                  </a>
          </div>
          <div id="reasonModal" class="modal">

            <!-- Modal content -->
            <div class="modal-content">
              <span class="close">&times;</span>
              <div class="modal-body py-5 mx-md-5 mx-sm-1 mx-xs-1">
                <form method="GET"
                      action="/admin/auction/{{$auction->id}}/reject"
                      enctype="multipart/form-data"
                      class="form-group navbar-form">
                  <input type="textarea"
                         class="form-control p-2 my-2"
                         placeholder="Reason of Rejection Here"
                         id="reasonOfRefusal"
                         name="reasonOfRefusal"
                         required>
                  <button type="submit"
                          id="btnRefusal"
                          class="btn btn-success w-100 btn-round mx-auto my-3 box-shadow"
                          >Send Reason</button>
                </form>

              </div>
            </div>

          </div>
        </div>
        @endif
        @if($auction->state == 'Over')
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
      @foreach($auction->comments->sortByDesc('date') as $comment)
      <blockquote class="blockquote my-4">
        <p class="mb-0">{{$comment->description}}</p>
        <footer class="blockquote-footer"><cite title="Source Title"><a>by {{ $comment->user->username }}, in </a></cite><cite title="Source Title"><a>{{ $comment->date }}</a></cite></footer>
      </blockquote>
      @if($comment->user == Auth::user())
      <form class="form-group" action="/auction/{{ $auction->id }}/comments/{{ $comment->id }}/remove/" method="POST">
        {{ method_field('DELETE') }}
        {{ csrf_field() }}
        <input type="submit" class="btn btn-primary btn-sm" name="_method" value="delete">
      </form>
      @endif
      <hr class="my-2">
      @endforeach
      <form class="form-group">
        {{ csrf_field() }}
        <label class="text-muted" for="newcomment"> Comment as {{ @Auth::user()->username }} </label>
        <textarea class="form-control" id="newcomment" name="description" rows="2"></textarea>
        <br />
        <button type="submit"
                formaction="/auction/{{ $auction->id }}/comments/add"
                formmethod="post"
                class="btn btn-primary btn-sm">Comment</button>
      </form>
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
      <hr class="my-4">
      <section class="my-4">
        <h4>Email Address</h4>
        <p>
          {{ $auction->creator->email }}
        </p>
      </section>
    </div>
  </div>
</div>

<script>
// Get the modal
var modal = document.getElementById('reasonModal');

// Get the button that opens the modal
var btn = document.getElementById("rejectbtt");
var span = document.getElementsByClassName("close")[0];
// When the user clicks the button, open the modal
btn.onclick = function() {
    modal.style.display = "block";
}
// When the user clicks on <span> (x), close the modal
span.onclick = function() {
    modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>
