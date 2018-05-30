
<!-- Profile Editor Modal -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModal" aria-hidden="true" data-backdrop="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content"  style="border-radius: 5px">
      <form method="post"
      action=" {{ action('ProfileController@edit', ['username' => $user->username]) }}"
      enctype="multipart/form-data">
      {{ csrf_field() }}
      <input type="hidden" name="id" value="{{ $user->id }}">
        <div class="modal-header">
          <h5 class="modal-title" id="editModalLabel">Edit Profile</h5>
          <button type="button" class="close text-info" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <fieldset>
            <legend>Login Information</legend>
            <hr class="my-0" />
            <label class="col-form-label required">Username</label> <input class="form-control"
                   type="text"
                   name="username" value='{{ old('username', $user->username) }}'>
            <label class="col-form-label">New Password</label> <input class="form-control"
                   type="password"
                   name="password"
                   autocomplete="off">
                   @if ($errors->has('password'))
                   <span class="error">
                     <strong>{{ $errors->first('password') }}</strong>
                   </span>
                   @endif
            <label class="col-form-label">Confirm New Password</label> <input class="form-control"
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
                   name="completeName" value='{{ old('completeName', $user->completename) }}'>
                   @if ($errors->has('completeName'))
                   <span class="error">
                     <strong>{{ $errors->first('completeName') }}</strong>
                   </span>
                   @endif
            @if ($user->typeofuser == 'Normal')
              <label class="col-form-label required">Email</label><input class="form-control"
              type="email"
              name="email" value='{{ old('email', $user->email) }}'>
              @if ($errors->has('email'))
                <span class="error">
                  <strong>{{ $errors->first('email') }}</strong>
                </span>
              @endif
            @endif
            <label class="col-form-label">Phone Number</label><input class="form-control"
                   type="tel"
                   name="phoneNumber" value='{{ old('phoneNumber', $user->phonenumber) }}'>
                   @if ($errors->has('phoneNumber'))
                   <span class="error">
                     <strong>{{ $errors->first('phoneNumber') }}</strong>
                   </span>
                   @endif
          </fieldset>

          @if ($user->typeofuser=='Normal')
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
                          {{ ($userCountryID == $country->id) ? 'selected' : ''}}>{{ $country->name }}  </option>
                    @endforeach
              </select>
              <label class="col-form-label required">City</label>
              <input class="form-control"
                     type="text"
                     name="city" value='{{ old('city', App\City::find($user->city)->name) }}'>
              <label class="col-form-label required">Address</label>
              <input class="form-control"
                     type="text"
                     name="address" value='{{ old('address', $user->address) }}'>
                     @if ($errors->has('address'))
                     <span class="error">
                       <strong>{{ $errors->first('address') }}</strong>
                     </span>
                     @endif
            </fieldset>

        @endif

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-round" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary btn-round box-shadow">Save changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Profile Photo Modal -->
<div class="modal fade" id="photoModal" tabindex="-1" role="dialog" aria-labelledby="photoModal" aria-hidden="true" data-backdrop="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content"  style="border-radius: 5px">
      <form method="post"
      action=" {{ action('ProfileController@editPhoto', ['username' => $user->username]) }}"
      enctype="multipart/form-data">
      {{ csrf_field() }}
      <input type="hidden" name="id" value="{{ $user->id }}">
        <div class="modal-header">
          <h5 class="modal-title" id="photoModalLabel">Edit Picture</h5>
          <button type="button" class="close text-info" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="id" value="{{ $user->id }}">
          <fieldset>
            <label class="col-form-label"
                   for="image">Profile Image</label>
            <input type="file"
                   class="form-control-file"
                   id="image"
                   aria-describedby="image"
                   name="photo">
                   @if ($errors->has('photo'))
                   <span class="error">
                     <strong>{{ $errors->first('photo') }}</strong>
                   </span>
                   @endif
            <small id="fileHelp"
                   class="form-text text-muted">The supported file formats are jpeg, png, jpg, gif and svg.</small>
          </fieldset>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-round" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary btn-round box-shadow">Save changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Add Credits Modal -->
<div class="modal fade" id="creditsModal" tabindex="-1" role="dialog" aria-labelledby="creditsModal" aria-hidden="true" data-backdrop="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content"  style="border-radius: 5px">
      <form method="post"
      action="{{$user->username}}/add_credits"
      enctype="multipart/form-data">
      {{ csrf_field() }}
      <input type="hidden" name="id" value="{{ $user->id }}">
        <div class="modal-header">
          <h5 class="modal-title" id="creditsModalLabel">Add Credits </h5>
          <button type="button" class="close text-info" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body mb-4">
          <input type="hidden" name="id" value="{{ $user->id }}">
          <label class="col-form-label required">Amount</label>
          <select class="form-control"
                  name="amount">
              @for($i = 1 ; $i < 16; $i++)
                  <option value="{{ $i * 100}}"
                    {{ ($i == 1) ? 'selected' : ''}}  >{{ $i * 100 }}€  </option>
              @endfor
          </select>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-round" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary btn-round box-shadow" onclick="$('#loadingModal').modal('show');">Pay with PayPal</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Approved Paypal Modal -->
<div class="modal fade" id="approvedPaymentModal" tabindex="-1" role="dialog" aria-labelledby="approvedPaymentModal" aria-hidden="true" data-backdrop="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content"  style="border-radius: 5px">
      <form>
        <div class="modal-header">
          <h5 class="modal-title" id="approvedPaymentModalLabel">Add Credits </h5>
          <button type="button" class="close text-info" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div id="approvedPaymentAlert" class="alert alert-dismissible alert-success my-4 w-75 mx-auto box-shadow">
            <strong class="alert-link">Success!</strong> You have successfully completed the transaction of {{session()->get('paypal_amount')}}€.
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Rejected Paypal Modal -->
<div class="modal fade" id="rejectedPaymentModal" tabindex="-1" role="dialog" aria-labelledby="rejectedPaymentModal" aria-hidden="true" data-backdrop="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content"  style="border-radius: 5px">
      <form>
        <div class="modal-header">
          <h5 class="modal-title" id="rejectedPaymentModalLabel">Add Credits </h5>
          <button type="button" class="close text-info" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div id="rejectedPaymentAlert" class="alert alert-dismissible alert-danger my-4 w-75 mx-auto box-shadow">
            <strong class="alert-link">Error!</strong> The transaction of {{session()->get('paypal_amount')}}€ was not processed successfully.
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Loading Modal -->
<div class="modal fade" id="loadingModal" tabindex="-1" role="dialog" aria-labelledby="loadingModal" aria-hidden="true" data-backdrop="false" data-keyboard="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content"  style="border-radius: 5px">
      <form>
        <div class="modal-header">
          <h5 class="modal-title" id="loadingModalLabel">Waiting for PayPal </h5>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="mx-auto my-5">
              <img src="/images/loading.gif" alt="Loading Gif">
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>
