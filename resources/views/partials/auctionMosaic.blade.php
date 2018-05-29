<div id="auctionProfile">
  <script language="javascript">
   timecounter("{{ $auction->timeleft()}}",{{ $auction->id }});
  </script>
  <img class="img-fluid"
       width="246" height="280"
       href="/auction/{{ $auction->id }}"
       src="{{ $auction->pathtophoto }}"/>
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
            class="col-sm-7 mr-sm-1">
            <p id="countdown_{{$auction->id}}" class="countdown"></p>
        </li>
        <li id="bidsDone"
            class="col-sm-3"> {{ $auction->bids()->count() }} Bids </li>
      </ul>
    </div>
  </div>
</div>
