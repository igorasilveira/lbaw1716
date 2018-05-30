<script>
  $( document ).ready(function() {
    @if (count($errors) != 0)
      @if (session()->has('form'))
        @if (session()->get('form') != 'register')
          $('#loginModal').modal('show');
        @else
          {{ session()->forget('form') }}
        @endif
      @endif
    @endif
  });
</script>
<a href="#" class="btn btn-secondary btn-round" data-toggle="modal" data-target="#loginModal">Login</a>
<!-- Approved Paypal Modal -->
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="loginModal" aria-hidden="true" data-backdrop="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content"  style="border-radius: 5px">
      <div class="modal-header">
        <h4 class="modal-title" id="loginModalLabel">Welcome! </h4>
        <button type="button" class="close text-success" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body py-5 mx-md-5 mx-sm-1 mx-xs-1">
        <form method="POST"
              action=" /login"
              enctype="multipart/form-data"
              class="form-group navbar-form"
              id="signin">
              {{ csrf_field() }}
              <fieldset>
                <div class="form-group">
                  <label for="username">
                    <h5>Username</h5>
                  </label>
                  <input type="text"
                  class="form-control p-2"
                  placeholder="your username here"
                  id="username"
                  name="username"
                  required>
                  @if ($errors->has('username'))
                    <span class="error">
                      <strong>{{ $errors->first('username') }}</strong>
                    </span>
                  @endif
                </div>
                <div class="form-group">
                  <label for="password">
                    <h5>Password</h5>
                  </label>
                  <input type="password"
                  class="form-control p-2"
                  placeholder="your password here"
                  id="password"
                  name="password"
                  required>
                  @if ($errors->has('password'))
                    <span class="error">
                      <strong>{{ $errors->first('password') }}</strong>
                    </span>
                  @endif
                </div>
              </fieldset>
          <button type="submit"
                  id="btnLogin"
                  class="btn btn-success w-100 btn-round mx-auto my-3 box-shadow text-center"
                  >Sign In</button>
        </form>
        <h6 class="text-center my-3">
          <a id="registerNav"
           href="{{ url('/register') }}"> No account yet? Sign Up here! </a>
        </h6>
        <h6 class="text-center my-3">
          <a
           href="{{ route('password.request') }}">{{ __('Forgot Your Password?') }} </a>
        </h6>
      </div>
    </div>
  </div>
</div>
