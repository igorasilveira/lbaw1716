<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3 text-center">
    <h1 class="display-6"> Search Results for "{{ $search }}" </h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="container w-75">
  <h4> In Auctions</h4>
  @if (count($results['auctions']) == 0)
    <div class="alert alert-info my-5 w-75 mx-auto">
      <strong class="alert-link">Ups!</strong> There are no results here for your search.
    </div>
  @else
    <table class="table table-hover">
      <thead>
        <tr class="table">
          <th>Item</th>
          <th>Context</th>
          <th>Go to Page</th>
        </tr>
      </thead>
      <tbody>
        @foreach($results['auctions'] as $result)
        <tr>
          <td>{{ $result->title }}</td>
          <td>Auction</td>
          <td>
            <a href="/auction/{{ $result->id }}">
              <img src="images/goto_link.png"
              width="20"
              height="20" />
            </a>
          </td>
        </tr>
        @endforeach
      </tbody>
    </table>
  @endif
  <div class="container-fluid my-4">
    {{ $results['auctions']->fragment('_auctions')->links() }}
  </div>
</div>
<div class="container w-75">
<h4> In Users </h4>
@if (count($results['users']) == 0)
  <div class="alert alert-info my-5 w-75 mx-auto">
    <strong class="alert-link">Ups!</strong> There are no results here for your search.
  </div>
@else
  <table class="table table-hover">
    <thead>
      <tr class="table">
        <th>Item</th>
        <th>Context</th>
        <th>Go to Page</th>
      </tr>
    </thead>
    <tbody>
      @foreach($results['users'] as $result)
      <tr>
        <td>{{ $result->username }}</td>
        <td>User</td>
        <td>
          <a href="/users/{{ $result->username }}">
            <img src="images/goto_link.png"
            width="20"
            height="20" />
          </a>
        </td>
      </tr>
      @endforeach
    </tbody>
  </table>
@endif
<div class="container-fluid my-4">
  {{ $results['users']->fragment('_users')->links() }}
</div>
</div>
