<ul class="nav pull-right">
  @if (Auth::user()->typeofuser=='Normal')
  <a href="/auction/new">
          <button type="button" name="button" class="btn btn-secondary btn-md mt-1 mr-5 btn-round">+<span class="hidden-xs"> Create Auction</span></button>
        </a>
  @elseif(Auth::user()->typeofuser=='Administrator')
  <a href="/admin/manage">
          <button type="button" name="button" class="btn btn-secondary btn-md mt-1 mr-5 btn-round">+<span class="hidden-xs"> Admin Management</span></button>
        </a>
  @endif
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
    <div class="dropdown-menu test box-shadow"
         style="padding:12px; border-radius: 10px">
      <a class="dropdown-item"
         href="/users/{{ Auth::user()->username }}"> Profile </a>
      <div class="dropdown-divider"></div>
      @if (Auth::user()->typeofuser=='Normal')
      <a class="dropdown-item"
         href="/users/{{ Auth::user()->username }}/auctions">My Auctions </a>
      @else
      <a class="dropdown-item"
         href="/users/{{ Auth::user()->username }}/manageAuctions">My Auctions </a>
      @endif   
      <div class="dropdown-divider"></div>
      <a class="dropdown-item"
         href="{{ url('logout') }}"> Log Out </a>
   </div>
</ul>
