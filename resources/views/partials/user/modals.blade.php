<!-- The Modal -->
<div id="myModal" class="modal" data-backdrop="false">

  <!-- Modal content -->
  <div class="modal-content w-50">
    <div class="modal-header">
      <h2 class="text-center">Please rate the Seller</h2>
      <span class="close text-info">&times;</span>
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
            <label class="col-form-label required">Email</label><input class="form-control"
                   type="e-mail"
                   name="email" value='{{ old('email', $user->email) }}'>
                   @if ($errors->has('email'))
                   <span class="error">
                     <strong>{{ $errors->first('email') }}</strong>
                   </span>
                   @endif
            <label class="col-form-label">Phone Number</label><input class="form-control"
                   type="phone"
                   name="phoneNumber" value='{{ old('phoneNumber', $user->phonenumber) }}'>
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
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Save changes</button>
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
                   class="form-text text-muted">This is the image that will be displayed publicly on your profile.</small>
          </fieldset>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Save changes</button>
        </div>
      </form>
    </div>
  </div>
</div>
