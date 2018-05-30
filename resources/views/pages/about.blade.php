@extends('layouts.template')
@section('content')
    <div class="hidden-xs">
      <hr class="my-md-4 my-sm-2 my-xs-1">
      <div class="title jumbotron my-0 p-3">
        <h1 class="display-6">About</h1>
      </div>
      <hr class="my-md-4 my-sm-2 my-xs-1">
    </div>

		<div id="about">
			<div class="container p-5 ">
				<h2>About Pc Auctions </h2>
				<p class="text-justify">Pc Auctions is a website developed for the Curricular Unit LBAW, part of the Integrated Masters in Inphormatics Engineering. Made with love, care and a lot of coffee by 4 students, this website intends to be an online auction service that lets users
					buy and sell PCs, either pre-made (by which we intend laptops and towers with and without peripheral devices) or by buying components and peripheral devices on their own, for an accessible and dynamic pricing competing with major electronics stores
					on used parts.</p>
				<p class="text-justify">This system lets the users create an account, enter auctions in order to buy and/or sell items, evaluate the listed items and the sellers, register comments for the items and consult information about other users and items.
				</p>
			</div>
			<hr class="my-3">
			<h3 class="text-center"> Website creators</h3>
			<hr class="my-3">
			<div id="aboutphotos"
			     class="container-fluid mx-auto my-5">

				<div class="row">
					<div class="col">
						<div class="card box-shadow">
							<img src="images/photos/igor_foto.jpg"
							     alt="Igor"
							     class="profile-pic w-border max-img-size mx-auto my-4 box-shadow">
							<div class="container">
								<hr class="my-2">
								<h2>Igor Silveira</h2>
								<hr class="my-2">
								<p class="title">CEO &amp; Founder</p>
								<p>LBAW Student at FEUP.</p>
								<p>igorsilveira@pcauctions.com</p>
							</div>
						</div>
					</div>
					<div class="col">
						<div class="card box-shadow">
							<img src="images/photos/nadia_foto.jpg"
							     alt="Nadia"
							     class="profile-pic w-border max-img-size mx-auto my-4 box-shadow">
							<div class="container">
								<hr class="my-2">
								<h2>Nadia Carvalho</h2>
								<hr class="my-2">
								<p class="title">CEO &amp; Founder</p>
                <p>LBAW Student at FEUP.</p>
								<p>igorsilveira@pcauctions.com</p>
							</div>
						</div>
					</div>
					<div class="col">
						<div class="card box-shadow">
							<img src="images/photos/pedro_foto.jpg"
							     alt="Pedro"
							     class="profile-pic w-border max-img-size mx-auto my-4 box-shadow">
							<div class="container">
								<hr class="my-2">
								<h2>Pedro Silva</h2>
								<hr class="my-2">
								<p class="title">CEO &amp; Founder</p>
                <p>LBAW Student at FEUP.</p>
								<p>igorsilveira@pcauctions.com</p>
							</div>
						</div>
					</div>
					<div class="col">
						<div class="card box-shadow">
							<img src="images/photos/diogo_foto.jpg"
							     alt="Diogo"
							     class="profile-pic w-border max-img-size mx-auto my-4 box-shadow">
							<div class="container">
								<hr class="my-2">
								<h2>Diogo Pereira</h2>
								<hr class="my-2">
								<p class="title">CEO &amp; Founder</p>
                <p>LBAW Student at FEUP.</p>
                <p>igorsilveira@pcauctions.com</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
    @endsection
