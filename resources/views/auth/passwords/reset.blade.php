@extends('layouts.app')

@section('content')
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card btn-round box-shadow">
                <h4 class="card-header text-primary">{{ __('Reset Password') }}</h4>

                <div class="card-body p-md-5 p-xs-2">
                    <form method="POST" action="{{ route('password.request') }}">
                        {{ csrf_field() }}

                        <fieldset>
                          <input type="hidden" name="token" value="{{ $token }}">

                          <div class="form-group">
                            <label for="email">
                              <h5>
                                {{ __('E-Mail Address') }}
                              </h5>
                            </label>

                            <input id="email" type="email" class="form-control p-2{{ $errors->has('email') ? ' is-invalid' : '' }}" name="email" value="{{ $email ?? old('email') }}"
                            placeholder="your email here"
                            required autofocus>

                            @if ($errors->has('email'))
                              <span class="invalid-feedback">
                                <strong>{{ $errors->first('email') }}</strong>
                              </span>
                            @endif

                          </div>

                          <div class="form-group">
                            <label for="password" >
                              <h5>
                                {{ __('Password') }}
                              </h5>
                            </label>


                            <input id="password" type="password" class="form-control p-2{{ $errors->has('password') ? ' is-invalid' : '' }}" name="password"
                            placeholder="your password here"
                            required>

                            @if ($errors->has('password'))
                              <span class="invalid-feedback">
                                <strong>{{ $errors->first('password') }}</strong>
                              </span>
                            @endif

                          </div>

                          <div class="form-group">
                            <label for="password-confirm">
                              <h5>
                                {{ __('Confirm Password') }}
                              </h5>
                            </label>

                            <input id="password-confirm" type="password" class="form-control" name="password_confirmation"
                            placeholder="your confirmation password"
                            required>
                          </div>
                        </fieldset>

                        <hr class="my-4">
                        <button type="submit" class="btn btn-success btn-round box-shadow w-100 text-center">
                            {{ __('Reset Password') }}
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
