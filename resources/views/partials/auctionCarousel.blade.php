<div id="auctionProfile">
  <img class="img-fluid"
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
            class="col-sm-5 mr-sm-1">
            <!--<script> timecounter({{-- $auction->timeleft() --}}); </script>-->
            <p id="demo">

            </p>
        </li>
        <li id="bidsDone"
            class="col-sm-5"> {{ $auction->bids()->count() }} Bids </li>
      </ul>
    </div>
  </div>
</div>
