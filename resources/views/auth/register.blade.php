@extends('layouts.template')

@section('content')
<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3 text-center">
    <h1 class="display-6">Sign Up</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div class="container mx-auto">
  <div id="new_user">
    <form method="POST"
          action="{{ route('register') }}"
          class="mx-auto"
          enctype="multipart/form-data">
      {{ csrf_field() }}
      <fieldset>
        <legend>Log in Information</legend>
        <hr class="my-0" />
        <label class="col-form-label required">Username</label> <input class="form-control"
               type="text"
               name="username" value='{{{ old('username') }}}'>
               @if ($errors->has('username'))
               <span class="error">
                 <strong>{{ $errors->first('username') }}</strong>
               </span>
               @endif
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
               name="completeName" value='{{{ old('completeName') }}}'>
               @if ($errors->has('completeName'))
               <span class="error">
                 <strong>{{ $errors->first('completeName') }}</strong>
               </span>
               @endif
        <label class="col-form-label required">Email</label><input class="form-control"
               type="e-mail"
               name="email" value='{{{ old('email') }}}'>
               @if ($errors->has('email'))
               <span class="error">
                 <strong>{{ $errors->first('email') }}</strong>
               </span>
               @endif
        <label class="col-form-label">Phone Number</label><input class="form-control"
               type="phone"
               name="phoneNumber" value='{{{ old('phoneNumber') }}}'>
               @if ($errors->has('phoneNumber'))
               <span class="error">
                 <strong>{{ $errors->first('phoneNumber') }}</strong>
               </span>
               @endif
        <label class="col-form-label required">Birthdate</label> <input class="form-control"
               type="date"
               name="birthDate" value='{{{ old('birthDate') }}}'>
               @if ($errors->has('birthDate'))
               <span class="error">
                 <strong>{{ $errors->first('birthDate') }}</strong>
               </span>
               @endif
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

      <hr class="my-md-4 my-sm-1">
      <fieldset>
        <legend>Location information</legend>
        <hr class="my-0" />
        <label class="col-form-label required">Country</label>
        <select class="form-control"
                name="country">
            @foreach(App\Country::all() as $country)
                <option value="{{ $country->id }}">{{ $country->name }}</option>
            @endforeach
    </select>
        <label class="col-form-label required">City</label>
        <input class="form-control"
               type="text"
               name="city" value='{{{ old('city') }}}'>
        <label class="col-form-label required">Address</label>
        <input class="form-control"
               type="text"
               name="address" value='{{{ old('address') }}}'>
               @if ($errors->has('address'))
               <span class="error">
                 <strong>{{ $errors->first('address') }}</strong>
               </span>
               @endif
      </fieldset>
      <hr class="my-md-4 my-xs-1">
      <input class="btn btn-primary w-100 my-4 btn-round box-shadow"
             type="submit"
             value="Submit Information" />
    </form>
  </div>
</div>
@endsection
