<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
    <h1 class="display-6"> Search Results for {{ $search }} </h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="container w-65">
  <table class="table table-hover">
    <thead>
      <tr class="table">
        <th>Item</th>
        <th>Context</th>
        <th>Go to Page</th>
      </tr>
    </thead>
    <tbody>
      @foreach($results as $result)
      @if ($result instanceof App\Auction)
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
      @elseif ($result instanceof App\User)
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
      @endif
      @endforeach
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
<br />
