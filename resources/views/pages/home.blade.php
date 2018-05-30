@extends('layouts.template')

@section('content')
    <div class="container-fluid ">
      <div class="hidden-xs">
        <hr class="my-3">
        <h3 class="py-3 text-center">Quick Start</h3>
        <hr class="my-3">
      </div>
        <div class="container-fluid row my-3">
        <div id="lateralNavBar"
             class="col-sm-3 bg-white p-4">
          <navbar>
            <ul class="list-group box-shadow">
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="/endingsoonest">Ending Soonest</a>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="/newlylisted">Newly Listed</a>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="/mostbids">Most Bids</a>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="/lowestprice">Lowest Price</a>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="/highestprice">Highest Price</a>
              </li>
            </ul>
            <br />
          </navbar>
        </div>

        <div id="indexCat"
             class="container-fluid row col-sm-9 my-auto bg-white p-4">
          <div id="auctionsMosaic"
               class="container-fluid row col-sm-12 row">
               @foreach(App\Category::all() as $category)
                  @if($category->auctions()->count() >= 3)
                  @include('partials.categoryCarousel', ['category' => $category])
                  <br/>
                  @endif
               @endforeach
          </div>
        </div>
      </div>
@endsection
