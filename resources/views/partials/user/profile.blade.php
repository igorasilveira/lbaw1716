@if ($user->typeofuser == 'Normal')
  <script>
  $( document ).ready(function() {
    @if (count($errors) != 0)
    @if (session()->get('form') == 'edit')
    $('#editModal').modal('show');
    @endif
    @endif
    @if (session()->has('paypal'))
    @if (session()->get('paypal') == "approved")
    $("#approvedPaymentModal").modal('show');
    @elseif (session()->get('paypal') == "rejected")
    $("#rejectedPaymentModal").modal('show');
    @endif
    {{ session()->forget('paypal') }}
    @endif
  });
</script>
@endif
<hr class="my-md-4 my-sm-2 my-xs-1">
@if (Auth::check())
  @if (Auth::user()->id == $user->id)

    @if($user->typeofuser=='Normal' && $user->blocked==false && count($pending) > 0)
    <div id="warningPendingTop" class="alert alert-dismissible alert-danger my-4 w-75 mx-auto">
      <strong class="alert-link">Attention!</strong> You have pending actions required on finished auctions.
    </div>
    <hr class="my-md-4 my-sm-2 my-xs-1">
    @elseif($user->typeofuser=='Normal' && $user->blocked==true)
    <div id="warningPendingTop" class="alert alert-dismissible alert-danger my-4 w-75 mx-auto">
      <strong class="alert-link">Attention!</strong> You are currently blocked!
    </div>
    <hr class="my-md-4 my-sm-2 my-xs-1">
    @endif
  @endif
@endif
<div id="profile-container"
class="jumbotron">
<div class="row">
  <div class="col-md-6 col-sm-12 col-xs-12">
    @if (Auth::check() && (Auth::user()->id == $user->id))<img data-toggle="modal" data-target="#photoModal" src="{{ $user->pathtophoto }}" alt="User photo"
      class="profile-pic mb-4 box-shadow mx-auto w-border img-hover" title="Change Profile Picture">
    @else
      <img src="{{ $user->pathtophoto }}"
      alt="User photo"
      class="profile-pic mb-4 box-shadow mx-auto w-border" title="Profile Picture">
    @endif
    </div>
    <div id="info-container"
    class="col-md-6 col-sm-12 col-xs-12 vcen container-fluid ">
      <div class="pb-2">
        <h5 class="text-muted">#{{ $user->id }}</h5>
        <h3>{{ $user->username}}
          <span class=" mx-4 badge badge-pill badge-info box-shadow">
            @if ($user->typeofuser == 'Normal')
              @if ($user->rating != NULL)
                {{ $user->rating }}/5
              @else
                Not Rated
              @endif
            @else
              {{ $user->typeofuser }}
            @endif
          </span>
        </h3>
      </div>

        <div class="pb-2">
          <p>
            {{ $user->completename}}

            @if (Auth::check())
              @if (Auth::user()->id == $user->id)
              <a href="#" data-toggle="modal" data-target="#editModal"><img src="/images/logo_edit.png" alt="Logo edit" height="20" width="20" class="ml-4 pointer"/></a>
              @endif
            @endif
          </p>
          <p>
            {{ $user->email}}
          </p>
        </div>
        @if (Auth::check() && (Auth::user()->id == $user->id))
        @if ($user->typeofuser=='Normal' && $user->blocked==false)
      <div id="balance"
      class="text-center w-50 border border-dark btn-round box-shadow">
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
            @if (Auth::check())
              @if (Auth::user()->id == $user->id)
              <a href="#" data-toggle="modal" data-target="#creditsModal"
              class="btn btn-success w-100 box-shadow btn-round">Add Credits</a>
              @endif
            @endif
          </div>
        </div>
      </div>
      @endif
      @endif
      @if (Auth::user()->id != $user->id)
      @if (Auth::user()->typeofuser == 'Moderator' || Auth::user()->typeofuser =='Administrator' )
      @if ($user->typeofuser=='Normal')
      <div id="report"
                     class="text-center w-50">
        <div class="col">
          @if ($user->blocked)
          <a href="/admin/users/{{$user->id}}/unblock">
            <button type="button"
                    class="btn btn-danger w-100 box-shadow mt-4  btn-round box-shadow">UnBlock User</button>
          </a>
          @else
          <a href="/admin/users/{{$user->id}}/block">
            <button type="button"
                    class="btn btn-danger w-100 box-shadow mt-4 btn-round box-shadow">Block User</button>
          </a>
          @endif
        </div>

      </div>
      @endif
      @endif
      @endif
    </div>
  </div>
</div>

@if (Auth::check())
  @if (Auth::user()->id == $user->id)
    <hr class="mb-5">
    <div class="row">
      <span class="col-md-2 col-sm-0 col-xs-0"></span>
        <a @if($user->typeofuser=='Normal')
          href="{{ $user->username }}/auctions"
          @else
            href="{{ $user->username }}/manageAuctions"
          @endif
          class="col-md-8 col-sm-12 col-xs-12 btn btn-info w-100 box-shadow btn-round">
          My Live Auctions
        </a>

      <span class="col-md-2 col-sm-0 col-xs-0"></span>
    </div>

    <div id="myModal" class="modal">

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

      <hr class="my-5">
      <div id="statistics"
      class="container">
        <h3 class="pb-2">Auction History</h3>
        @if ($user->typeofuser=='Normal')
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
          aria-labelledby="sold">

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
            <div id="warningNoSold" class="alert alert-info my-5 w-75 mx-auto ">
              <strong class="alert-link">Ups!</strong> You have not <strong>sold</strong> any items yet.
            </div>
            @endif
          </div>
          <div class="tab-pane fade"
            id="bought"
            role="tabpanel"
            aria-labelledby="bought">
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
            <div id="warningNoBought" class="alert alert-info my-5 w-75 mx-auto">
              <strong class="alert-link">Ups!</strong> You have not <strong>bought</strong> any items yet.
            </div>
            @endif
          </div>
            <div class="tab-pane fade active show"
              id="pending"
              role="tabpanel"
              aria-labelledby="pending">
              @if (count($pending) > 0)
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
                  @for ($i = 0; $i < min(6, count($pending)); $i++)
                  <tr class="table">
                    <th scope="row">#{{ $pending->slice($i, 1)->first()->id }}</th>
                    <td>{{ $pending->slice($i, 1)->first()->title }}</td>
                    <td>{{ substr($pending->slice($i, 1)->first()->finaldate, 0, 10) }}</td>
                    <td style="cursor: pointer"><a onclick="getModal(this)"><img src="{{ asset('images/confirm_edit.png') }}" height="20px" /><span class="px-4 text-success align-bottom">Rate Seller</span></a></td>
                  </tr>
                  @endfor
                </tbody>
              </table>
              @if (count($pending) > 6)
              <a href="myhistory_user.html"><button class="btn btn-outline-primary w-100">See More</button></a>
              @endif
              @else
              <div id="warningNoPending" class="alert alert-info my-5 w-75 mx-auto">
                <strong class="alert-link">Good!</strong> You have no <strong>pending</strong> businesses.
              </div>
              @endif
            </div>
          </div>
      @else
          <ul class="nav nav-tabs">
            <li class="nav-item">
              <a class="nav-link active show"
                data-toggle="tab"
                href="#responsible">Former Responsible Auctions
              </a>
            </li>
          </ul>
          <div class=" table-responsive tab-content ">
            <div class="tab-pane fade active show"
            id="responsible"
            role="tabpanel"
            aria-labelledby="responsible">
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
                <div id="warningNoManage" class="alert alert-info my-5 w-75 mx-auto">
                  <strong class="alert-link">Ups!</strong> You have managed any auctions yet.
                </div>
              @endif
            </div>
          </div>
        </div>
      @endif
  @endif
@endif
