@extends('layouts.template')
@section('content')

<div class="hidden-xs">
  <hr class="my-md-4 my-sm-2 my-xs-1">
  <div class="title jumbotron my-0 p-3">
    <h1 class="display-6 text-center">FAQ's</h1>
  </div>
  <hr class="my-md-4 my-sm-2 my-xs-1">
</div>
<!-- ou mudar para w-75 -->
<hr class="my-3">
<div class="container-fluid mt-3 mx-auto">

  <div id="FAQ_questions">


    <div id="questions">
      <div class="card mb-1 my-2">
        <div class="card-header ">

          <button class="btn btn-link collapsed"
                  data-toggle="collapse"
                  data-target="#questionOne"
                  aria-expanded="false">
        <span>How can I use Pc Auction?</span>
      </button>
          </h5>
        </div>

        <div id="questionOne"
             class="collapse">
          <div class="card-body">
            You can use Pc Auction either to buy or sell Pc relatable items.
          </div>
        </div>
      </div>
      <div class="card mb-1  my-2">
        <div class="card-header">

          <button class="btn btn-link collapsed"
                  data-toggle="collapse"
                  data-target="#questionTwo"
                  aria-expanded="false">
        <span>Do I have to pay to have an account?</span>
      </button>
          </h5>
        </div>
        <div id="questionTwo"
             class="collapse">
          <div class="card-body">
            No, it is completely free!
          </div>
        </div>
      </div>
      <div class="card mb-1 my-2">
        <div class="card-header">

          <button class="btn btn-link collapsed"
                  data-toggle="collapse"
                  data-target="#questionThree"
                  aria-expanded="false">
      <span>  My personal information is kept secret from everyone?</span>
      </button>
          </h5>
        </div>
        <div id="questionThree"
             class="collapse">
          <div class="card-body">
            Yes! Your personal information is secure, we guarantee that.
          </div>
        </div>
      </div>
      <div class="card mb-1 my-2">
        <div class="card-header">

          <button class="btn btn-link"
                  data-toggle="collapse"
                  data-target="#questionFour">
        <span> How can I search for a specific item?</span>
      </button>
          </h5>
        </div>

        <div id="questionFour"
             class="collapse">
          <div class="card-body">
            On top of the website, there is a search bar where you can type the name of the item you want, and check if there is an auction relatable to it. You can also check the different categories to go there.
          </div>
        </div>
      </div>
      <div class="card mb-1 my-2">
        <div class="card-header">

          <button class="btn btn-link collapsed"
                  data-toggle="collapse"
                  data-target="#questionFive"
                  aria-expanded="false">
      <span>  If an item is broke/in bad condition, what services does this website provide? </span>
      </button>
          </h5>
        </div>
        <div id="questionFive"
             class="collapse">
          <div class="card-body">
            In that case, you should contact the seller by checking his profile, and ask for a refund, he has that kind of obligation towards you.
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</div>
    @endsection
