<div class="col-md-4 col-sm-12">
  <hr class="my-3">
  <h5 class="text-shadow"> {{ $category->name }} </h5>
  <hr class="my-3">
  <div id="carouselExampleIndicators . {{ $category->id }}"
       class="carousel slide"
       data-ride="carousel . {{ $category->id }}">
    <div class="carousel-inner">
      @foreach($category->auctions()->where('state','Active')->orderby('numberofbids', 'DESC')->take(1)->get() as $auction)
      <div class="carousel-item active">
        @include('partials.auctionCarousel', ['auction' => $auction])
      </div>
      @endforeach
      @foreach($category->auctions()->where('state','Active')->orderby('numberofbids', 'DESC')->skip(1)->take(2)->get() as $auction)
      <div class="carousel-item">
        @include('partials.auctionCarousel', ['auction' => $auction])
      </div>
      @endforeach
    </div>
    <a class="carousel-control-prev"
       href="#carouselExampleIndicators . {{ $category->id }}"
       role="button"
       data-slide="prev">
      <span class="carousel-control-prev-icon bg-dark profile-pic" aria-hidden="true"></span>
      <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next"
       href="#carouselExampleIndicators . {{ $category->id }}"
       role="button"
       data-slide="next">
      <span class="carousel-control-next-icon bg-dark profile-pic" aria-hidden="true"></span>
      <span class="sr-only">Next</span>
    </a>
  </div>
</div>
<br/>
