  <div class="hidden-xs">
    <hr class="my-md-4 my-sm-2 my-xs-1">
    <div class="title jumbotron my-0 p-3">
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
      <form action="{{ action('AuctionController@save') }}"
            method="post"
            class="mx-auto py-2">
        <div class="form-group">

          <label class="col-form-label required"
                 for="title">Title</label>
          <input type="text"
                 class="form-control"
                 placeholder="Default input"
                 id="title"
                 name="title"
                 required>

          <label class="col-form-label required"
                 for="category">Select a Category</label>
          <select class="form-control"
                  id="category"
                  required>
            <option value="" selected disabled hidden>Category</option>
            @foreach(App\Category::all() as $category)
            <option value="{{ $category->id }}"> {{ $category->name }} </option>
            @endforeach
          </select>

          <label class="col-form-label required"
                 for="description">Description</label>
          <textarea name="description"
                    rows="8"
                    cols="80"
                    maxlength="254"
                    class="form-control"
                    placeholder="Max. 254 characters"
                    required></textarea>

          <label class="col-form-label required"
          for="reason">Selling Reason</label>
          <input type="text"
          class="form-control"
          placeholder="Default input"
          id="reason"
          name="reason"
          required>
          <label class="col-form-label"
                 for="image">Auction Image</label>
          <input type="file"
                 class="form-control-file"
                 id="image"
                 aria-describedby="image"
                 name="pathtophoto">
          <small id="fileHelp"
                 class="form-text text-muted">This is the image that will be displayed has the main auction image.</small>

          <div class="row">
            <div class="col-lg-4 col-md-12 col-sm-12">
              <label class="col-form-label required">Starting Price</label>
              <div class="form-group">
                <div class="input-group mb-3">
                  <div class="input-group-prepend">
                    <span class="input-group-text">€</span>
                  </div>
                  <input type="number"
                         class="form-control"
                         aria-label="Amount (to the nearest euro)"
                         name="startingprice"
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
              <label class="col-form-label">Minimum Selling Price
              <span class="badge badge-info" data-toggle="tooltip" data-placement="left" title="No transaction is processed if this amount is not met">?</span></label>
              <div class="form-group">
                <div class="input-group mb-3">
                  <div class="input-group-prepend">
                    <span class="input-group-text">€</span>
                  </div>
                  <input type="number"
                         class="form-control"
                         aria-label="Amount (to the nearest euro)"
                         name="minimumsellingprice"
                         value=0>
                  <div class="input-group-append">
                    <span class="input-group-text">.00</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-lg-4 col-md-12 col-sm-12">
              <label class="col-form-label">Buy Now Price
              <span class="badge badge-info" data-toggle="tooltip" data-placement="left" title="A user can end the auction automatically and buy at this value">?</span></label>
              <div class="form-group">
                <div class="input-group mb-3">
                  <div class="input-group-prepend">
                    <span class="input-group-text">€</span>
                  </div>
                  <input type="number"
                         class="form-control"
                         aria-label="Amount (to the nearest euro)"
                         name="buynow"
                         value=0>
                  <div class="input-group-append">
                    <span class="input-group-text">.00</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <label class="col-form-label required"
               for="category">Select Auction Duration</label>
        <select class="form-control"
                id="auctionDuration"
                name="auctionDuration"
                required>
          <option value="" selected disabled hidden># Days</option>
          <option value="1">1 Day</option>
          <option value="2">2 Days</option>
          <option value="3">3 Days</option>
          <option value="4">4 Days</option>
          <option value="5">5 Days</option>
          <option value="6">6 Days</option>
          <option value="7">7 Days</option>
        </select>
        <hr class="my-4">
        <div class="row mt-5 container-fluid mx-auto">
          <button class="btn btn-outline-primary col-md-6 col-sm-12"
                  type="button">Preview Auction</button>
          <button class="btn btn-primary  col-md-6 col-sm-12"
                  type="submit">Send for Review</button>
        </div>
        {{csrf_field() }}
      </form>
    </div>
