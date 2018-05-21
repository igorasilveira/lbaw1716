<ul class="nav pull-right">
  <a href="/auction/new">
          <button type="button" name="button" class="btn btn-secondary btn-md mt-1 mr-5 btn-round">+<span class="hidden-xs"> Create Auction</span></button>
        </a>
  <li class="dropdown"
      id="menuLogin">
    <a class="dropdown-toggle text-white"
       href="#"
       data-toggle="dropdown"
       id="navLogin"
       data-devgib="tagged">Go To</a>
    <a class=""
       href="/users/{{ Auth::user()->username }}"
       data-devgib="tagged"><img src="{{ Auth::user()->pathtophoto }}" height="50" class="profile-pic img-hover" style="display: inline"/></a>
    <div class="dropdown-menu test"
         style="padding:17px;">
      <a class="dropdown-item"
         href="/users/{{ Auth::user()->username }}"> Profile </a>
      <div class="dropdown-divider"></div>
      <a class="dropdown-item"
         href="/users/{{ Auth::user()->username }}/auctions">My Auctions </a>
      <div class="dropdown-divider"></div>
      <a class="dropdown-item"
         href="{{ url('logout') }}"> Log Out </a>
   </div>
</ul>
