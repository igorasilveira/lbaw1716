<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3 text-center">
    <h1 class="display-6"> Search Results for "{{ $search }}" </h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="container w-75">
  <h4> In Auctions</h4>
  @if (count($results) == 0)
    <div class="alert alert-info my-5 w-75 mx-auto">
      <strong class="alert-link">Ups!</strong> There are no results here for your search.
    </div>
  @else
    <table class="table table-hover">
      <thead>
        <tr class="table">
          <th>Item</th>
          <th>Limit Date</th>
          <th>Number Of Bids</th>
          <th>Current Bid Value</th>
          <th>Go to Page</th>
        </tr>
      </thead>
      <tbody>
        @foreach($results as $result)
        <tr>
          <td>{{ $result->title }}</td>
          <td>{{ $result->limitdate }}</td>
          <td>{{ $result->bids->count() }}</td>
          <td>
            @if($result->bids->count() > 0)
            {{ $result->bids->sortByDesc('date')->first()->value }} €
            @else
            0 €
            @endif
          </td>
          <td>
            <a href="/auction/{{ $result->id }}">
              <img src="images/goto_link.png"
              alt="Search Image"
              width="20"
              height="20" />
            </a>
          </td>
        </tr>
        @endforeach
      </tbody>
    </table>
  @endif
</div>
