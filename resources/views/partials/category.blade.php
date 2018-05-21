<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0  p-3 text-center">
    <h1 class="display-6"> {{ $category->name }}</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="container">
  <div id="bidding"
       class="container-fluid">
    <div id="bidViewer">
      <ul id="auctionsMosaic"
          class="container-fluid col-sm-12 row">
        <div class="row">
          @foreach($category->auctions()->where('state','Active')->orderby('numberofbids', 'DESC')->take(3)->get() as $auction)
          @if($category->auctions()->where('state','Active')->count()>=3)
          <li class="col-md-4 col-sm-6 col-xs-6">
          @elseif($category->auctions()->where('state','Active')->count()==2)
          <li class="col-md-6 col-sm-6 col-xs-6">
          @else
          <li class="col-md-12 col-sm-6 col-xs-6">
          @endif
          @include('partials.auctionMosaic', ['auction' => $auction])
          </li>
          @endforeach
        </div>
        <hr class="my-5">
        <div class="row">
          @if($category->auctions->count() >= 6)
          @foreach($category->auctions()->where('state','Active')->orderby('numberofbids', 'DESC')->skip(3)->take(3)->get() as $auction)
          @if($category->auctions()->where('state','Active')->count()>=6)
          <li class="col-md-4 col-sm-6 col-xs-6">
          @elseif($category->auctions()->where('state','Active')->count()==5)
          <li class="col-md-6 col-sm-6 col-xs-6">
          @else
          <li class="col-md-12 col-sm-6 col-xs-6">
          @endif
          @include('partials.auctionMosaic', ['auction' => $auction])
          </li>
          @endforeach
          @endif
        </div>
      </ul>
      <br />
    </div>
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
        <table class="bidsListViewMore table-responsive table-hover">
          <thead>
            <tr class="table">
              <th scope="col">Photo of Item</th>
              <th scope="col">Name of Auction</th>
              <th scope="col">Value of last Bid</th>
              <th scope="col">Lifetime of Auction</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td scope="row"><img src="https://static.fnac-static.com/multimedia/Images/PT/NR/57/8a/15/1411671/1540-1.jpg"
                     width="80"
                     height="80"></td>
              <td> <a href="#"> Microsoft Surface Book 2 - 13'' - i7-8650U | 8GB | 256GB </a> </td>
              <td> 1500€ </td>
              <td> 1-03-2018 </td>
            </tr>
            <tr>
              <td scope="row"><img src="https://static.fnac-static.com/multimedia/Images/PT/NR/b7/78/14/1341623/1539-1.jpg"
                     width="80"
                     height="80"></td>
              <td> <a href="#"> Laptop Acer Swift 5 SF514-52T | Core i5-8250U | 256GB </a> </td>
              <td> 1000€ </td>
              <td> 10-03-2018 </td>
            </tr>
            <tr>
              <td scope="row"><img src="https://static.fnac-static.com/multimedia/Images/PT/NR/b7/16/12/1185463/1539-1/tsp20170614164417/Apple-MacBook-Air-13-i5-1-8GHz-8GB-128GB.jpg"
                     width="80"
                     height="80"></td>
              <td> <a href="#"> Apple MacBook Air 13'' i5-1,8GHz | 8GB | 128GB </a> </td>
              <td> 500€ </td>
              <td> 5-03-2018 </td>
            </tr>
            <tr>
              <td scope="row"><img src="https://static.fnac-static.com/multimedia/Images/PT/NR/73/6e/14/1338995/1540-1.jpg"
                     width="80"
                     height="80"></td>
              <td> <a href="#"> Laptop Asus Zenbook Flip S UX370UA-78DHDAB1 </a> </td>
              <td> 100€ </td>
              <td> 1-03-2018 </td>
            </tr>
            <tr>
              <td scope="row"><img src="https://static.fnac-static.com/multimedia/Images/PT/NR/5c/76/15/1406556/1540-1.jpg"
                     width="80"
                     height="80"></td>
              <td> <a href="#"> HP Spectre 13-af002np Laptop </a> </td>
              <td> 400€ </td>
              <td> 1-03-2018 </td>
            </tr>
          </tbody>
        </table>
        <br />
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
