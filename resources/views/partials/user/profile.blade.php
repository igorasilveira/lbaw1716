
<hr class="my-md-4 my-sm-2 my-xs-1">

@if (Auth::check())
@if (Auth::user()->id == $user->id)
<div id="warningPendingTop" class="alert alert-dismissible alert-danger my-4 w-75 mx-auto box-shadow">
  <strong class="alert-link">Attention!</strong> You have pending actions required on finished auctions.
</div>
<hr class="my-md-4 my-sm-2 my-xs-1">
@endif
@endif
<div id="profile-container"
class="jumbotron">

<div class="row">
  <div class="col-md-6 col-sm-12 col-xs-12"> <a href="{{ $user->username }}/edit"
    title="Item 1"><img src="{{ $user->pathtophoto }}"
    class="profile-pic mb-4 box-shadow mx-auto w-border " title="Change Profile Picture"></a> </div>
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
    </div>
  </div>
</div>

@if (Auth::check())
@if (Auth::user()->id == $user->id)
<hr class="mb-5">
<div class="row">
  <span class="col-md-2 col-sm-0 col-xs-0"></span>
  <a href="{{ $user->id }}/auctions"
    class="col-md-8 col-sm-12 col-xs-12">
    <button class="btn btn-info w-100 box-shadow">My Live Auctions
    </button>
  </a>
  <span class="col-md-2 col-sm-0 col-xs-0"></span>
</div>

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
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Good!</strong> You have no <strong>pending</strong> businesses.
      </div>

    </div>
  </div>
</div>
@endif
@endif

<!-- The Modal -->
<div id="myModal" class="modal" data-backdrop="false">

  <!-- Modal content -->
  <div class="modal-content w-50">
    <div class="modal-header">
      <h2 class="text-center">Please rate the Seller</h2>
      <span class="close text-success">&times;</span>
    </div>
    <div class="modal-body mx-auto my-3">
      <div class="rating mr-3">
        <input type="radio"
        id="star5"
        name="rating"
        value="5" /><label for="star5"
        title="Excellent!">5 stars</label>
        <input type="radio"
        id="star4"
        name="rating"
        value="4" /><label for="star4"
        title="Pretty good">4 stars</label>
        <input type="radio"
        id="star3"
        name="rating"
        value="3" /><label for="star3"
        title="Meh">3 stars</label>
        <input type="radio"
        id="star2"
        name="rating"
        value="2" /><label for="star2"
        title="Bad">2 stars</label>
        <input type="radio"
        id="star1"
        name="rating"
        value="1" /><label for="star1"
        title="Really bad">1 star</label>
      </div>
      <button class="btn btn-primary my-4 mx-auto"
        onclick="checkRating()">
        Submit Rating
      </button>
    </div>

    <div class="modal-footer row" id="complain">
      <h3 class="col col-sm-12 col-xs-12">Complain:</h3>

      <textarea class="form-control col col-sm-12 col-xs-12" id="complainID" rows="3" cols="40"> </textarea>
      <button class="btn btn-primary my-4 col col-sm-12 col-xs-12"
      onclick="eliminatePending()">
      Send Complain
      </button>
    </div>
  </div>
</div>

<!-- Modal -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModal" aria-hidden="true" data-backdrop="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editModalLabel">Edit Profile</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <fieldset>
          <legend>Log in Information</legend>
          <hr class="my-0" />
          <label class="col-form-label required">Username</label> <input class="form-control"
                 type="text"
                 name="username" value='{{{ $user->username }}}'>
          <label class="col-form-label required">Password</label> <input class="form-control"
                 type="password"
                 name="password">
                 @if ($errors->has('password'))
                 <span class="error">
                   <strong>{{ $errors->first('password') }}</strong>
                 </span>
                 @endif
          <label class="col-form-label required">Password Confirmation</label> <input class="form-control"
                 type="password"
                 name="password_confirmation">
                 @if ($errors->has('password_confirmation'))
                 <span class="error">
                   <strong>{{ $errors->first('password_confirmation') }}</strong>
                 </span>
                 @endif
        </fieldset>
        <hr class="my-md-4 my-sm-1">
        <fieldset>
          <legend>Personal Data</legend>
          <hr class="my-0" />
          <label class="col-form-label required">Complete Name</label> <input class="form-control"
                 type="text"
                 name="completeName" value='{{{ $user->completename }}}'>
                 @if ($errors->has('completeName'))
                 <span class="error">
                   <strong>{{ $errors->first('completeName') }}</strong>
                 </span>
                 @endif
          <label class="col-form-label required">Email</label><input class="form-control"
                 type="e-mail"
                 name="email" value='{{{ $user->email }}}'>
                 @if ($errors->has('email'))
                 <span class="error">
                   <strong>{{ $errors->first('email') }}</strong>
                 </span>
                 @endif
          <label class="col-form-label required">Phone Number</label><input class="form-control"
                 type="phone"
                 name="phoneNumber" value='{{{ $user->phonenumber }}}'>
                 @if ($errors->has('phoneNumber'))
                 <span class="error">
                   <strong>{{ $errors->first('phoneNumber') }}</strong>
                 </span>
                 @endif
        </fieldset>

        <hr class="my-md-4 my-sm-1">
        <fieldset>
          <legend>Location information</legend>
          <hr class="my-0" />
          <label class="col-form-label required">Country</label>
          <select class="form-control"
                  name="country">
                  {{ $userCountryID = App\Country::find(App\City::find($user->city)->country)->id }}
              @foreach(App\Country::all() as $country)
                  <option value="{{ $country->id }}"
                    {{ ($userCountryID == $country->id) ? 'selected' : ''}}
                    >{{ $country->name }}
                  </option>
              @endforeach
          </select>
          <label class="col-form-label required">City</label>
          <input class="form-control"
                 type="text"
                 name="city" value='{{{ App\City::find($user->city)->name }}}'>
          <label class="col-form-label required">Address</label>
          <input class="form-control"
                 type="text"
                 name="address" value='{{{ $user->address }}}'>
                 @if ($errors->has('address'))
                 <span class="error">
                   <strong>{{ $errors->first('address') }}</strong>
                 </span>
                 @endif
        </fieldset>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>
