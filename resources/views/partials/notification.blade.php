<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
    <h1 class="display-6">Message</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>

<div id="message"
class="container my-md-5 my-sm-3 my-xs-2">
<div class="row">
  <h5 class="col-md-6 col-sm-12 col-xs-12">Sender:
    <a class="text-muted small" href="#">System</a>
  </h5>
  <h5 class="col-md-6 col-sm-12 col-xs-12 text-md-right text-sm-left text-xs-left">
    Date:
    <span class="text-muted small">
      {{ date("Y-m-d H:i:s", strtotime($notification->date)) }}
    </span>
  </h5>
</div>
<h5 class="my-md-4 my-sm-3 my-xs-2">Subject:
  <span class="text-muted small">{{ $notification->type }}</span>
</h5>
<h5 class="my-md-4 my-sm-3 my-xs-2">Message:</h5>
<div id="message-body" class="my-md-3 my-sm-4">
  <p class="lead">
    <?php  echo $notification->description ?>
  </p>
</div>
<div class="row my-md-5 my-sm-4">
  <form class="form-group col-md-12 col-sm-12 col-xs-12" action="/users/{{Auth::user()->username}}/notifications/{{$notification->id}}/remove" method="POST">
    {{ method_field('DELETE') }}
    {{ csrf_field() }}
    <input type="submit" class="btn btn-danger col-md-12 col-sm-12 col-xs-12 box-shadow my-sm-1 my-xs-1 mx-auto" name="_method" value="delete">
  </form>
</div>
<form class="form-group col-md-12 col-sm-12 col-xs-12" action="/users/{{Auth::user()->username}}/notifications/" method="GET">
  {{ csrf_field() }}
  <input type="submit" class="btn btn-info col-md-12 col-sm-12 col-xs-12 box-shadow my-sm-1 my-xs-1 mx-auto" name="_method" value="Return">
</form>
</div>
