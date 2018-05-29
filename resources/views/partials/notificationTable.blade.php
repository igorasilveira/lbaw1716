<tr class="table">
  <th scope="row">
      @if($notification->_read == false)
        <span class="text-danger">
      @else
        <span class="text-muted">
      @endif
      {{ $notification->description }}
      </span>
  </th>
  <td class="form-check-inline">
    <a href="/users/{{Auth::user()->username}}/notifications/{{$notification->id}}">
      <img src="{{ asset('images/confirm_edit.png') }}"
      alt="Confirm edit."
      width="20"
      height="20"
      class="removeBtt"
      title='View'>
    </a>
    <form class="col-1" action="/users/{{Auth::user()->username}}/notifications/{{$notification->id}}/remove" method="POST">
      {{ method_field('DELETE') }}
      {{ csrf_field() }}
      <button class="link-button">
        <img src="{{ asset('images/remove_logo.png') }}"
        alt="Remove logo."
        width="20"
        height="20"
        class="removeBtt"
        title='Remove'>
      </button>
    </form>
  </td>
</tr>
