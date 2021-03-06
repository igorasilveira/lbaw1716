  <div class="hidden-xs">
    <hr class="my-md-4 my-sm-2 my-xs-1">
    <div class="title jumbotron my-0 p-3">
      <h1 class="display-6 text-center">Managing Area</h1>
    </div>
    <hr class="my-md-4 my-sm-2 my-xs-1">
  </div>

  <div class="container">
    <h3 class="py-2">Registered Moderators</h3>
    <div class="table-responsive btn-round box-shadow">
      @if (count($moderators) == 0)
      <div id="warningNoAuctions" class="alert alert-info my-5 w-75 mx-auto box-shadow">
        <strong class="alert-link">Ups!</strong> There are <strong>no moderators</strong>.
      </div>
      @else
      <table id="moderatorsList"
      class="table  table-hover box-shadow">
      <thead>
        <tr class="table">
          <th scope="col">Photo</th>
          <th scope="col">Username</th>
          <th scope="col">Nr Auctions</th>
          <th><img src="{{ asset('images/logo_edit.png') }}"
            alt="Edit Image"
            width="20"
            height="20"
            class="editModBtt"
            title='Edit Moderators'
            onclick="editModerators()"> </th>
          </tr>
        </thead>
        <tbody>
          @for ($j = 0; $j < count($moderators); $j++)
          <tr>
            <td scope="row"><img src="{{ $moderators->slice($j, 1)->first()->pathtophoto }}"
              alt="Moderator slice"
              width="70"
              height="70"
              class="profile-pic box-shadow"></td>
              <td>{{ $moderators->slice($j, 1)->first()->username }}</td>
              <td>{{ App\Auction::all()->where('responsiblemoderator', $moderators->slice($j, 1)->first()->id)->where('state', 'Active' )->count() }}</td>
              <td><img src="{{ asset('images/remove_logo.png') }}"
                alt="Remove Image"
                width="20"
                height="20"
                class="removeBtt"
                title='Remove Moderator'
                onclick="delModerator(this)"> </td>
              </tr>
            @endfor
            </tbody>
            </table>
          @endif

    </div>

    <button class="btn btn-info btn-round box-shadow w-100 my-md-4 my-sm-2"
            id="createModBtt"
            onclick="addModerator()">Create Moderator</button>
  </div>

  <hr class="my-4">
  <div class="container">
  <h3 class="py-2">Categories</h3>
  <div class="table-responsive btn-round box-shadow">
  <table id="categoriesList"
  class="table  table-hover box-shadow">
  <thead>
    <tr class="table">
      <th scope="col">Name</th>
      <th scope="col">Parent</th>
      <th scope="col">Nr Items</th>
      <th><img src="{{ asset('images/logo_edit.png') }}"
        alt="Edit Image"
        width="20"
        height="20"
        class="editCatBtt pointer"
        title='Edit Categories'
        onclick="editCategories()"> </th>
      </tr>
    </thead>
    <tbody>
      @for ($j = 0; $j < count($categories); $j++)
      <tr>
        <td scope="row">{{ $categories->slice($j, 1)->first()->name }}</td>
        <td>@if($categories->slice($j, 1)->first()->parent==null)
          N/A
          @else
          {{  App\Category::find($categories->slice($j, 1)->first()->parent)->name }}
          @endif
        </td>
        <td>{{ $categories->slice($j, 1)->first()->auctions()->where('state','Active')->count() }}</td>
        <td><img src="{{ asset('images/remove_logo.png') }}"
          alt="Remove Image"
          width="20"
          height="20"
          class="removeBtt pointer"
          title='Remove Category'
          onclick="delCategory(this,{{$categories->slice($j, 1)->first()->id}})"> </td>
        </tr>
        @endfor
      </tbody>
    </table>
  </div>
  <button class="btn btn-info btn-round box-shadow w-100 my-md-4 my-sm-2"
        id="createCategoryBtt"
        onclick="addCategory()">Create Category</button>
  </div>
