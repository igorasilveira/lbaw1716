@extends('layouts.app')

@section('content')
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card box-shadow btn-round">
                <div class="card-header">
                  <h4>
                    {{ __('Reset Password') }}
                  </h4></div>

                <div class="card-body p-md-5 p-xs-2">
                    @if (session('status'))
                        <div class="alert alert-success">
                            {{ session('status') }}
                        </div>
                    @endif

                    <form method="POST" action="{{ route('password.email') }}"
                    class="form-group navbar-form">
                        {{ csrf_field() }}
                        <fieldset>
                          <div class="form-group">
                            <label for="email">
                              <h5>{{__('Email Address')}}</h5>
                            </label>
                            <input id="email" type="email" class="form-control p-2{{ $errors->has('email') ? ' is-invalid' : '' }}"
                            name="email" value="{{ old('email') }}"
                            placeholder="your email here"
                            required>

                            @if ($errors->has('email'))
                              <span class="invalid-feedback">
                                <strong>{{ $errors->first('email') }}</strong>
                              </span>
                            @endif
                          </div>
                        </fieldset>

                        <hr class="my-4">

                        <button type="submit" class="btn btn-success btn-round box-shadow w-100 text-center">
                            {{ __('Send Password Reset Link') }}
                        </button>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>
@endsection
