@extends('layouts.template')

@section('content')
<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
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
               name="username">
        <label class="col-form-label required">Password</label> <input class="form-control"
               type="password"
               name="password">
      </fieldset>
      <hr class="my-md-4 my-sm-1">
      <fieldset>
        <legend>Personal Data</legend>
        <hr class="my-0" />
        <label class="col-form-label required">Complete Name</label> <input class="form-control"
               type="text"
               name="compName">
        <label class="col-form-label required">Email</label><input class="form-control"
               type="e-mail"
               name="email">
        <label class="col-form-label required">Phone Number</label><input class="form-control"
               type="phone"
               name="phoneNumber">
        <label class="col-form-label required">Birthdate</label> <input class="form-control"
               type="date"
               name="birthDate">
        <label class="col-form-label"
               for="image">Profile Image</label>
        <input type="file"
               class="form-control-file"
               id="image"
               aria-describedby="image"
               name="photo">
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
                <option value="{{ $country->id }}">@{{!! $country->name !!}}</option>
            @endforeach
    </select>
        <label class="col-form-label required">City</label>
        <input class="form-control"
               type="text"
               name="city">
        <label class="col-form-label required">Postal-Code</label></label>
        <input class="form-control"
               type="text"
               pattern="[0-9]{5}"
               name="postalCode">
        <label class="col-form-label required">Address</label>
        <input class="form-control"
               type="text"
               name="address">
      </fieldset>
      <hr class="my-md-4 my-xs-1">
      <input class="btn btn-primary w-100 my-4"
             type="submit"
             value="Submit Information" />
    </form>
  </div>
</div>
@endsection
