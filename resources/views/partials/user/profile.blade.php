@if (count($errors) != 0)
  @if (Session::get('form') == 'edit')
    <script>
      $( document ).ready(function() {
        $('#editModal').modal('show');
      });
    </script>
  @endif
@endif
<hr class="my-md-4 my-sm-2 my-xs-1">

@if (Auth::check())
@if (Auth::user()->id == $user->id)

@if($user->typeofuser=='Normal')
<div id="warningPendingTop" class="alert alert-dismissible alert-danger my-4 w-75 mx-auto box-shadow">
  <strong class="alert-link">Attention!</strong> You have pending actions required on finished auctions.
</div>
@endif
<hr class="my-md-4 my-sm-2 my-xs-1">
@endif
@endif
<div id="profile-container"
class="jumbotron">

<div class="row">
  <div class="col-md-6 col-sm-12 col-xs-12">
    @if (Auth::check() && (Auth::user()->id == $user->id))<img data-toggle="modal" data-target="#photoModal" src="{{ $user->pathtophoto }}"
      class="profile-pic mb-4 box-shadow mx-auto w-border img-hover" title="Change Profile Picture">
    @else
      <img src="{{ $user->pathtophoto }}"
      class="profile-pic mb-4 box-shadow mx-auto w-border" title="Profile Picture">
    @endif</div>
    <div id="info-container"
    class="col-md-6 col-sm-12 col-xs-12 vcen container-fluid ">
      <section class="pb-2">
        <h5 class="text-muted">#{{ $user->id }}</h5>
        <h3>{{ $user->username}}<span class=" mx-4 badge badge-pill badge-info">
          @if ($user->rating != NULL)
          {{ $user->rating }}/5
          @else
          Not Rated
          @endif</span></h3>
        </section>
        <section class="pb-2">
          <p>
            {{ $user->completename}}

            @if (Auth::check())
              @if (Auth::user()->id == $user->id)
              <a href="#" data-toggle="modal" data-target="#editModal"><img src="/images/logo_edit.png" height="20" width="20" class="ml-4 pointer"/></a>
              @endif
            @endif
          </p>
          <p>
            {{ $user->email}}
          </p>
        </section>
        @if ($user->typeofuser=='Normal')
      <div id="balance"
      class="text-center w-50 border border-dark">
        <h4 class="pb-2">Balance</h4>
        <hr class="py-0" />
        <div class="row">
          <div class="col-md-6 col-sm-12 col-xs-12 my-md-2">
            @if ($user->balance == NULL)
            <h5 class="align-bottom">No Credits</h5>
            @else
            <h4 class="align-bottom">
              {{ $user->balance }}€
            </h4>
            @endif
          </div>
          <div class="col-md-6 col-sm-12 col-xs-12">
            <button type="button"
            class="btn btn-success w-100">Add Credit</button>
          </div>
        </div>
      </div>
      @endif
    </div>
  </div>
</div>

@if (Auth::check())
@if (Auth::user()->id == $user->id)
<hr class="mb-5">
<div class="row">
  <span class="col-md-2 col-sm-0 col-xs-0"></span>
  @if($user->typeofuser=='Normal')
  <a href="{{ $user->username }}/auctions"
    class="col-md-8 col-sm-12 col-xs-12">
    <button class="btn btn-info w-100 box-shadow">My Live Auctions
    </button>
  </a>
  @else
  <a href="{{ $user->username }}/manageAuctions"
    class="col-md-8 col-sm-12 col-xs-12">
    <button class="btn btn-info w-100 box-shadow">My Live Auctions
    </button>
  </a>
  @endif

  <span class="col-md-2 col-sm-0 col-xs-0"></span>
</div>

@if ($user->typeofuser=='Normal')
<hr class="my-5">
<div id="statistics"
class="container">
  <h3 class="pb-2">Auction History</h3>
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active show"
        data-toggle="tab"
        href="#pending">Pending Action
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link"
        data-toggle="tab"
        href="#bought">Bought
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link"
        data-toggle="tab"
        href="#sold">Sold
      </a>
    </li>
  </ul>
  <div class=" table-responsive tab-content ">
    <div class="tab-pane fade"
    id="sold"
    role="tabpanel"
    aria-labelledby="sold-tab">

      @if (count($sold) > 0)
      <table class="table table-hover">
        <thead>
          <tr>
            <th scope="col">Auction</th>
            <th scope="col">Item</th>
            <th scope="col">Date</th>
          </tr>
        </thead>
        <tbody>
          @for ($i = 0; $i < min(6, count($sold)); $i++)
          <tr class="table">
            <th scope="row">#{{ $sold->slice($i, 1)->first()->id }}</th>
            <td>{{ $sold->slice($i, 1)->first()->title }}</td>
            <td>{{ substr($sold->slice($i, 1)->first()->finaldate, 0, 10) }}</td>
          </tr>
          @endfor
        </tbody>
      </table>
        @if (count($sold) > 6)
        <a href="myhistory_user.html"><button class="btn btn-outline-primary w-100">See More</button></a>
        @endif
      @else
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> You have not <strong>sold</strong> any items yet.
      </div>
      @endif
    </div>
    <div class="tab-pane fade"
      id="bought"
      role="tabpanel"
      aria-labelledby="bought-tab">
      @if (count($bought) > 0)
      <table class="table table-hover">
        <thead>
          <tr>
            <th scope="col">Auction</th>
            <th scope="col">Item</th>
            <th scope="col">Date</th>
          </tr>
        </thead>
        <tbody>
          @for ($i = 0; $i < min(6, count($bought)); $i++)
          <tr class="table">
            <th scope="row">#{{ $bought->slice($i, 1)->first()->id }}</th>
            <td>{{ $bought->slice($i, 1)->first()->title }}</td>
            <td>{{ substr($bought->slice($i, 1)->first()->finaldate, 0, 10) }}</td>
          </tr>
          @endfor
        </tbody>
      </table>
      @if (count($bought) > 6)
      <a href="myhistory_user.html">
        <button class="btn btn-outline-primary w-100">See More
        </button>
      </a>
      @endif
      @else
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> You have not <strong>bought</strong> any items yet.
      </div>
      @endif
    </div>
    @else
    <hr class="my-5">
    <div id="statistics"
    class="container">
      <h3 class="pb-2">Auction History</h3>
      <ul class="nav nav-tabs">
        <li class="nav-item">
          <a class="nav-link active show"
            data-toggle="tab"
            href="#pending">Former Responsible Auctions
          </a>
      </ul>
      <div class=" table-responsive tab-content ">
        <div class="tab-pane fade"
        id="responAuct"
        role="tabpanel"
        aria-labelledby="sold-tab">

          @if (count($responAuct) > 0)
          <table class="table table-hover">
            <thead>
              <tr>
                <th scope="col">Auction</th>
                <th scope="col">Item</th>
                <th scope="col">Date</th>
              </tr>
            </thead>
            <tbody>
              @for ($i = 0; $i < min(6, count($responAuct)); $i++)
              <tr class="table">
                <th scope="row">#{{ $responAuct->slice($i, 1)->first()->id }}</th>
                <td>{{ $responAuct->slice($i, 1)->first()->title }}</td>
                <td>{{ substr($responAuct->slice($i, 1)->first()->finaldate, 0, 10) }}</td>
              </tr>
              @endfor
            </tbody>
          </table>
            @if (count($responAuct) > 6)
            <a href="myhistory_user.html"><button class="btn btn-outline-primary w-100">See More</button></a>
            @endif
          @else
          <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
            <strong class="alert-link">Ups!</strong> You have not any items yet.
          </div>
          @endif
        </div>
        @endif
    <div class="tab-pane fade active show"
      id="pending"
      role="tabpanel"
      aria-labelledby="pending-tab">
    <!--
      <table class="table table-hover">
        <thead>
          <tr>
            <th scope="col">Auction</th>
            <th scope="col">Item</th>
            <th scope="col">Date</th>
            <th scope="col">Action Required</th>
          </tr>
        </thead>
        <tbody>

        </tbody>
      </table>
    -->
    @if($user->typeofuser=='Normal')
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Good!</strong> You have no <strong>pending</strong> businesses.
      </div>
    @endif
    </div>
  </div>
</div>
@endif
@endif
