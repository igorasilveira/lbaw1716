<div id="auctionProfile">
  <script language="javascript">
  timecounter("{{ $auction->timeleft()}}",{{ $auction->id }});
  </script>
  <img class="img-fluid"
       href="/auction/{{ $auction->id }}"
       width="246" height="280"
       src="{{ $auction->pathtophoto }}"
       alt="Auction item image"/>
  <div id="infoAuctionProfile"
       class="container-fluid">
    <div id="auctionName">
      <a href="/auction/{{ $auction->id }}"
         class="text-info"> {{ $auction->title }} </a>
    </div>
    <div id="time-bids"
         class="row">
      <ul class="row col-sm-12 list-inline">
        <li id="timeLeft"
            class="col-sm-5 mr-sm-1">
            <p id="countdown_{{$auction->id}}" class="countdown"></p>
        </li>
        <li id="bidsDone"
            class="col-sm-5"> {{ $auction->bids()->count() }} Bids </li>
      </ul>
    </div>
  </div>
</div>
