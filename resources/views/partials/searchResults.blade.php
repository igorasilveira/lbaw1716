<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
    <h1 class="display-6"> Search Results for {{ $search }} </h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="container w-65">
  <h4>{{ $search }} in Auctions</h4>
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
  <br />
  {{ $results['auctions']->fragment('_auctions')->links() }}
</div>
<br />
<div class="container w-65">
<h4>{{ $search }} in Users</h4>
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
        <a href="/user/{{ $result->id }}">
          <img src="images/goto_link.png"
          width="20"
          height="20" />
        </a>
      </td>
    </tr>
    @endforeach
  </tbody>
</table>
<br />
{{ $results['users']->fragment('_users')->links() }}
</div>
