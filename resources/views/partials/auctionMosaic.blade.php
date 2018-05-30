<div class="auctionProfile">
  <script>
   timecounter("{{ $auction->timeleft()}}",{{ $auction->id }});
  </script>
  <a href="/auction/{{ $auction->id }}" class="container">
    <img class="img-fluid"
    width="246" height="280"
    src="{{ $auction->pathtophoto }}"
    alt="Auction item image"/>
  </a>
  <div
       class="container-fluid infoAuctionProfile">
    <div class="auctionName my-2">
      <a href="/auction/{{ $auction->id }}"
         class="text-info"> {{ $auction->title }} </a>
    </div>
    <div
         class="row time-bids">
      <ul class="row col-sm-12 list-inline">
        <li
            class="col-sm-7 mr-sm-1 timeLeft">
            <p id="countdown_{{$auction->id}}" class="countdown"></p>
        </li>
        <li
            class="col-sm-3 bidsDone"> {{ $auction->bids()->count() }} Bids </li>
      </ul>
    </div>
  </div>
</div>
