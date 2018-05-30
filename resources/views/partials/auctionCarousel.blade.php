<div class="auctionProfile">
  <script>
  timecounter("{{ $auction->timeleft()}}",{{ $auction->id }});
  </script>
  <img class="img-fluid"
       href="/auction/{{ $auction->id }}"
       width="246" height="280"
       src="{{ $auction->pathtophoto }}"
       alt="Auction item image"/>
  <div
       class="container-fluid infoAuctionProfile">
    <div class="auctionName p-2">
      <a href="/auction/{{ $auction->id }}"
         class="text-info"> {{ $auction->title }} </a>
    </div>
    <div
         class="row time-bids">
      <ul class="row col-sm-12 list-inline">
        <li
            class="col-sm-5 mr-sm-1 timeLeft">
            <p id="countdown_{{$auction->id}}" class="countdown"></p>
        </li>
        <li
            class="col-sm-5 bidsDone"> {{ $auction->bids()->count() }} Bids </li>
      </ul>
    </div>
  </div>
</div>
