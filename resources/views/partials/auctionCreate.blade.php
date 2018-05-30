  <div class="hidden-xs">
    <hr class="my-md-4 my-sm-2 my-xs-1">
    <div class="title jumbotron my-0 p-3 text-center">
      <h1 class="display-6">New Auction</h1>
    </div>
    <hr class="my-md-4 my-sm-2 my-xs-1">
  </div>

    <div class="alert alert-warning alert-dismissible fade show container mx-auto mt-4"
         role="alert">
      <button class="close"
              type="button"
              data-dismiss="alert"
              aria-label="Close">&times;</button>
      <h4 class="alert-heading">Notice!</h4>
      <p class="mb-0">All new auctions are submitted for review to one of our moderators. <span class="alert-link">They will only become public once accepted</span> and you will be notified at the time.</p>
    </div>
    <div id="auction-form"
         class="container">
         <!-- action="{{ route('auction_create') }}" -->
      <form
            method="post"
            enctype="multipart/form-data"
            class="mx-auto py-2">
        <fieldset>

          <div class="form-group">
            <h4>
              <label class="col-form-label required"
              for="title">Title</label>
            </h4>
            <input type="text"
            class="form-control"
            placeholder="In a few words, what are you selling?"
            @if (old('title') != "")
              value="{{ old('title') }}"
            @endif
            id="title"
            name="title" min="5" max="25"
            required>
            @if ($errors->has('title'))
            <span class="error">
              <strong>{{ $errors->first('title') }}</strong>
            </span>
            @endif
            <h4>
              <label class="col-form-label required"
              for="category">Select a Category</label>
            </h4>
            <select class="form-control"
            id="category"
            name="category"
            required>
            <option value=""
            @if (old('category') == "")
              selected
            @endif
             disabled hidden>Category</option>
            @foreach(App\Category::all() as $category)
              <option value="{{ $category->id }}"
                @if (old('category') == $category->id)
                  selected
                @endif> {{ $category->name }} </option>
            @endforeach
          </select>
          @if ($errors->has('category'))
          <span class="error">
            <strong>{{ $errors->first('category') }}</strong>
          </span>
          @endif
          <h4>
            <label class="col-form-label required"
            for="description">
            Description</label>
          </h4>
          <textarea name="description"
          rows="8"
          cols="80"
          maxlength="254"
          class="form-control"
          @if (old('description') == "")
            placeholder="Explain the users a bit more about the product"
          @endif
          required>@if (old('description') != ""){{old('description')}}@endif</textarea>
        @if ($errors->has('description'))
          <span class="error">
            <strong>{{ $errors->first('description') }}</strong>
          </span>
        @endif
        <h4>
          <label class="col-form-label required"
          for="reason">Selling Reason</label>
        </h4>
        <input type="text"
        class="form-control"
        placeholder="Why are you selling it?"
        id="reason"
        name="reason"
        @if (old('reason') != "")
          value="{{ old('reason') }}"
        @endif
        required>
        @if ($errors->has('reason'))
        <span class="error">
          <strong>{{ $errors->first('reason') }}</strong>
        </span>
        @endif
        <h4>
          <label class="col-form-label required"
          for="image">Auction Image</label>
        </h4>
        <input type="file"
        class="form-control-file"
        id="image"
        aria-describedby="image"
        name="pathtophoto"
        @if (old('pathtophoto') != "")
          {{ old('pathtophoto') }}
        @endif
        required>
        <small id="fileHelp"
        class="form-text text-muted">This is the image that will be displayed has the main auction image.
      </small>
      @if ($errors->has('pathtophoto'))
        <span class="error">
          <strong>{{ $errors->first('pathtophoto') }}</strong>
        </span>
      @endif
      <div class="row">
        <div class="col-lg-4 col-md-12 col-sm-12">
          <h4>
            <label class="col-form-label required">Starting Price</label>
          </h4>
          <div class="form-group">
            <div class="input-group mb-3">
              <div class="input-group-prepend">
                <span class="input-group-text">€</span>
              </div>
              <input type="number"
              class="form-control no-radius"
              aria-label="Amount (to the nearest euro)"
              name="startingprice"
              @if (old('startingprice'))
                value="{{old('startingprice')}}"
              @endif
              required
              min=1
              value=0>
              <div class="input-group-append">
                <span class="input-group-text">.00</span>
              </div>
            </div>
          </div>
        </div>
        <div class="col-lg-4 col-md-12 col-sm-12">
          <h4>
            <label class="col-form-label">Min Selling Price
              <span class="badge badge-info" data-toggle="tooltip" data-placement="left" title="No transaction is processed if this amount is not met.  Leave empty to disable this option.">?</span></label>
            </h4>
            <div class="form-group">
              <div class="input-group mb-3">
                <div class="input-group-prepend">
                  <span class="input-group-text">€</span>
                </div>
                <input type="number"
                class="form-control no-radius"
                aria-label="Amount (to the nearest euro)"
                name="minimumsellingprice"
                min=0
                @if (old('minimumsellingprice'))
                  value="{{old('minimumsellingprice')}}"
                @endif>

                <div class="input-group-append">
                  <span class="input-group-text">.00</span>
                </div>
              </div>
              @if ($errors->has('minimumsellingprice'))
                <span class="error">
                  <strong>{{ $errors->first('minimumsellingprice') }}</strong>
                </span>
              @endif
            </div>
          </div>
          <div class="col-lg-4 col-md-12 col-sm-12">
            <h4>
              <label class="col-form-label">Buy Now Price
                <span class="badge badge-info" data-toggle="tooltip" data-placement="left" title="A user can end the auction automatically and buy at this value. Leave empty to disable this option.">?</span></label>
              </h4>
              <div class="form-group">
                <div class="input-group mb-3">
                  <div class="input-group-prepend">
                    <span class="input-group-text">€</span>
                  </div>
                  <input type="number"
                  class="form-control no-radius"
                  aria-label="Amount (to the nearest euro)"
                  name="buynow"
                  @if (old('buynow'))
                    value="{{old('buynow')}}"
                  @endif
                  min=0>
                  <div class="input-group-append">
                    <span class="input-group-text">.00</span>
                  </div>
                </div>
                @if ($errors->has('buynow'))
                  <span class="error">
                    <strong>{{ $errors->first('buynow') }}</strong>
                  </span>
                @endif
              </div>
            </div>
          </div>
        </div>
        <h4>
          <label class="col-form-label required"
          for="category">Select Auction Duration</label>
        </h4>
        <select class="form-control"
        id="auctionDuration"
        name="auctionDuration"
        required>
        <option value="" selected disabled hidden># Days</option>
        @for ($i=1; $i < 8; $i++)
          <option value="{{$i}}"
          @if (old('auctionDuration') == $i)
            selected
          @endif>{{$i}} Day{{$i == 1 ? "" : "s"}}</option>
        @endfor
      </select>
      <hr class="my-4">
      <div class="row mt-5 container-fluid mx-auto">
        <button class="btn btn-primary btn-round box-shadow w-100"
        type="submit"
        formaction="{{ route('auction_create') }}">Send for Review</button>
      </div>
        </fieldset>
        {{ csrf_field() }}
      </form>
    </div>
