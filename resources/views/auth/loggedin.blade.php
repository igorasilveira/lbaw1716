<ul class="nav pull-right">
  @if (Auth::user()->typeofuser=='Normal' && Auth::user()->blocked==false)
    <li>
      <a href="/auction/new"
      class="btn btn-secondary btn-md mt-1 mr-5 btn-round">+<span class="hidden-xs"> Create Auction</span>
      </a>
    </li>
  @elseif(Auth::user()->typeofuser=='Administrator')
    <li>
      <a href="/admin/manage"
       class="btn btn-secondary btn-md mt-1 mr-5 btn-round"><span class="hidden-xs"> Admin Management</span>
      </a>
    </li>
  @elseif(Auth::user()->typeofuser=='Moderator')
    <li>
      <a href="/users/{{ Auth::user()->username }}/manageAuctions"
       class="btn btn-secondary btn-md mt-1 mr-5 btn-round"><span class="hidden-xs"> See Auctions</span>
      </a>
    </li>
  @endif
  <li class="dropdown row"
      id="menuLogin">
@php
  $count = count(App\Notification::where('authenticated_userid', Auth::id())->where('_read',false)->get())
@endphp
<a class="dropdown-toggle text-white p-2
  "
   href="#"
   data-toggle="dropdown"
   id="navLogin"
   data-devgib="tagged">
   @if( $count > 0)
     <span class="badge badge-pill badge-danger btn">{{ $count }}</span>
   @endif
    Go To</a>

    <a class=""
       href="/users/{{ Auth::user()->username }}"
       data-devgib="tagged"><img src="{{ Auth::user()->pathtophoto }}" alt="User photo" height="50" class="profile-pic img-hover" style="display: inline"/></a>
    <div class="dropdown-menu test box-shadow"
         style="padding:12px; border-radius: 10px">
      <a class="dropdown-item"
         href="/users/{{ Auth::user()->username }}"> Profile </a>
      <div class="dropdown-divider"></div>
      @if(Auth::user()->typeofuser == 'Normal')
      <a class="dropdown-item"
      href="/users/{{ Auth::user()->username }}/auctions">My Auctions </a>
      @else
      <a class="dropdown-item"
      href="/users/{{ Auth::user()->username }}/manageAuctions">My Auctions </a>
      @endif
      <div class="dropdown-divider"></div>

      <a class="dropdown-item"
         href="/users/{{ Auth::user()->username }}/notifications"> Notifications
         @if($count > 0)
           ({{$count}})
         @endif
       </a>
      <div class="dropdown-divider"></div>
      <a class="dropdown-item"
         href="{{ url('logout') }}"> Log Out </a>
   </div>
</ul>
