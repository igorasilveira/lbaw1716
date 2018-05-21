<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
    <h1 class="display-6">Notifications</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>
<div id="notifications"
     class="container">
  <table class="table table-hover">
    <thead>
      <tr>
        <th scope="col">Subject</th>
        <th scope="col">Action</th>
      </tr>
    </thead>
    <tbody>
      @foreach(App\Notification::where('authenticated_userid', Auth::id())->get() as $notification)
        @include('partials.notificationTable', ['notification' => $notification])
      @endforeach
    </tbody>
  </table>
</div>