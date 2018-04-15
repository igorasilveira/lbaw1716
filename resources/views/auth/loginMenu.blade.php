<ul class="nav pull-right">
  <li class="dropdown"
      id="menuLogin">
    <a class="dropdown-toggle text-white"
       href="#"
       data-toggle="dropdown"
       id="navLogin"
       data-devgib="tagged">Login</a>
    <div class="dropdown-menu test"
         style="padding:17px;">
      <form method="POST"
            action="{{ url('/login') }}"
            enctype="multipart/form-data"
            class="form-group navbar-form"
            id="signin">
            {{ csrf_field() }}
        <input type="text"
               class="form-control p-2 my-2"
               placeholder="Username"
               id="username"
               name="username"
               required>
        <input type="password"
               class="form-control p-2 my-2"
               placeholder="Password"
               id="password"
               name="password"
               required>
        <button type="button"
                id="btnLogin"
                class="btn btn-success w-100">Sign In</button>
      </form>

      <a id="registerNav"
         href="{{ url('/register') }}"> No account yet? Sign Up here! </a>
    </div>
  </li>
</ul>
