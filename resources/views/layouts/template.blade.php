<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">

  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible"
          content="IE=edge">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <!-- CSRF Token -->
    <meta name="csrf-token"
          content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- Styles -->
    <!--<link href="{{ asset('css/milligram.min.css') }}" rel="stylesheet">-->
    <link href="{{ asset('css/app.css') }}"
          rel="stylesheet">
    <link href="{{ asset('css/bootstrap.min.css') }}"
          rel="stylesheet">

    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
            integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
            integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
            crossorigin="anonymous"></script>
    <script src="https://apis.google.com/js/platform.js"
            async
            defer></script>
    <script type="text/javascript"
            src="{{ asset('js/app.js') }}"
            defer>
    </script>
    <script type="text/javascript"
            src="{{ asset('js/bootstrap.min.js') }}">
    </script>
    <script type="text/javascript">
        // Fix for Firefox autofocus CSS bug
        // See: http://stackoverflow.com/questions/18943276/html-5-autofocus-messes-up-css-loading/18945951#18945951
    </script>

  </head>
<body>
  <header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
      <div class="container-fluid">
        <a class="navbar-brand"
           href="index.html">
        <img src={{ asset('images/pcAuctions_logo.png') }} height="50"/></a>
        <div class="collapse navbar-collapse row"
             id="navbar1">
          <div class="col">
            <form class="form-inline my-2 my-lg-0">
              <input class="form-control mr-sm-2"
                     type="text"
                     placeholder="Search">
              <button class="btn btn-secondary my-2 my-sm-0 p-xs-0"
                      type="submit">Search</button>
            </form>
          </div>
        </div>
        @if (Auth::check())
            @include('auth/loggedin')
        @else
            @include('auth/loginMenu')
        @endif
        <br>
        <button class="navbar-toggler"
                type="button"
                data-toggle="collapse"
                data-target="#navbar1"
                aria-controls="navbar1"
                aria-expanded="false"
                aria-label="Toggle navigation"
                style="">
<img src="images/search-logo.png" height="25" alt="">
</button>
        <button class="navbar-toggler"
                type="button"
                data-toggle="collapse"
                data-target="#navbar2"
                aria-controls="navbar2"
                aria-expanded="false"
                aria-label="Toggle navigation"
                style="">
<span class="navbar-toggler-icon"></span>
</button>
      </div>
    </nav>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary p-md-1">
      <div class="container-fluid">
        <div class="collapse navbar-collapse"
             id="navbar2">
          <ul class="navbar-nav mr-auto">
            <li class="nav-item">
              <a class="nav-link text-white"
                 href="#">Towers w/ Components</a>
            </li>
            <li class="nav-item">
              <a class="nav-link text-white"
                 href="#">Towers</a>
            </li>
            <li class="nav-item">
              <a class="nav-link text-white"
                 href="categoryLaptops.html">Laptops</a>
            </li>
            <li class="nav-item">
              <a class="nav-link text-white"
                 href="#">Components</a>
            </li>
            <li class="nav-item">
              <a class="nav-link text-white"
                 href="#">Peripherals</a>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link  text-white dropdown-toggle"
                 id="navbarDropdownMenuLink"
                 data-toggle="dropdown"
                 aria-haspopup="true"
                 aria-expanded="false">
                            Others
              </a>
              <div class="dropdown-menu"
                   aria-labelledby="navbarDropdownMenuLink">
                <a class="dropdown-item"
                   href="#">Category</a>
                <a class="dropdown-item"
                   href="#">Another Category</a>
              </div>
            </li>
          </ul>
        </div>
    </nav>
  </header>
  @yield('content')
      <hr class="my-4">
      <footer class="page-footer">
        <div class="nav justify-content-center">
          <div class="nav-item">
            <a href="{{ url('/about') }}"> About </a>
          </div>
          <div class="nav-item">
            <a href="{{ url('/FAQ') }}"> FAQ </a>
          </div>
          <div class="nav-item">
            <a href="{{ url('/contact') }}"> Contacts </a>
          </div>
        </div>
        <hr class="my-4">
      </footer>
    </body>
  </html>
