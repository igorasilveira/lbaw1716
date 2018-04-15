@extends('layouts.template')

@section('content')
    <div class="container-fluid">
      <div class="hidden-xs">
        <hr class="my-3">
        <h3 class="py-3 text-center">Quick Start</h3>
        <hr class="my-3">
      </div>
        <div class="container-fluid row my-3">
        <div id="lateralNavBar"
             class="col-sm-3 bg-white p-4">
          <navbar>
            <ul class="list-group box-shadow">
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="#">Quick Wins</a>
                <span class="badge badge-primary badge-pill">14</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="#">Ending Soonest</a>
                <span class="badge badge-primary badge-pill">2</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="#">Newly Listed</a>
                <span class="badge badge-primary badge-pill">1</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="#">Most Bids</a>
                <span class="badge badge-primary badge-pill">14</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="#">Lowest Price</a>
                <span class="badge badge-primary badge-pill">2</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="#">Highest Price</a>
                <span class="badge badge-primary badge-pill">1</span>
              </li>
            </ul>
            <br />
          </navbar>
        </div>

        <div id="indexCat"
             class="container-fluid row col-sm-9 my-auto bg-white p-4">
          <div id="auctionsMosaic"
               class="container-fluid row col-sm-12 row">
            <div class="col-md-4 col-sm-12">
            <hr class="my-3">
              <h5 class="text-shadow"> Towers with Components</h5>
              <hr class="my-3">
              <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner">
                  <div class="carousel-item active">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://images-na.ssl-images-amazon.com/images/I/41WtKtFCKoL._AC_SR160,160_.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Ryzen & GTX 1050 Ti Edition SkyTech ArchAngel Computer</a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://images-na.ssl-images-amazon.com/images/I/81Pz14q%2B%2BHL._AC_SR201,266_.jpg"
                           height="20" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> CYBERPOWERPC Gamer Xtreme GXIVR8020A4 Gaming</a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://images-na.ssl-images-amazon.com/images/I/51P963Jq89L._AC_SR201,266_.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Dell Premium Desktop Tower with Keyboard&Mouse</a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
                  <span class="carousel-control-prev-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
                  <span class="carousel-control-next-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
              </div>
            </div>
            <br/>
            <div class="col-md-4 col-sm-12">
            <hr class="my-3">
              <h5 class="text-shadow"> Towers Only </h5>
              <hr class="my-3">
              <div id="carouselExampleIndicators2" class="carousel slide" data-ride="carousel2">
                <div class="carousel-inner">
                  <div class="carousel-item active">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSYkvZPYNcIa0gD6hduh3i3OMiMp6kQRlC3xeDrOj9m9Ta0zioQaPwhEv7XVTUQLNrhVxWtT4g&usqp=CAc" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> NOX Hummer TGX </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://img1.banggood.com/thumb/view/oaupload/banggood/images/2D/28/3c232b3d-34ee-4427-aaa4-2fb61d1ccf78.jpg"
                           height="20" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Clear Side Gaming Black Micro ATX ITX PC Case </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://images10.newegg.com/ProductImageCompressAll300/11-133-327-V20.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Thermaltake Tower 900 Snow Edition</a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <a class="carousel-control-prev" href="#carouselExampleIndicators2" role="button" data-slide="prev">
                  <span class="carousel-control-prev-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleIndicators2" role="button" data-slide="next">
                  <span class="carousel-control-next-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
              </div>
            </div>
            <br/>
            <div class="col-md-4 col-sm-12">
            <hr class="my-3">
              <h5 class="text-shadow"> Laptops </h5>
              <hr class="my-3">
              <div id="carouselExampleIndicators3" class="carousel slide" data-ride="carousel2">
                <div class="carousel-inner">
                  <div class="carousel-item active">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://static.fnac-static.com/multimedia/Images/PT/NR/d9/16/12/1185497/1540-1/tsp20170623132310/Apple-MacBook-Pro-13-Retina-i5-3-1GHz-8GB-256GB-Intel-Iris-Plus-650-com-Touch-Bar-e-Touch-ID-Cinzento-Sideral.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Apple MacBook Pro 13'</a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://static.fnac-static.com/multimedia/Images/PT/NR/23/05/13/1246499/1540-1.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Laptop Asus Zenbook  </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://static.fnac-static.com/multimedia/Images/PT/NR/fe/e3/14/1369086/1540-1.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Laptop Asus S410UN-78AM5CB1 </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <a class="carousel-control-prev" href="#carouselExampleIndicators3" role="button" data-slide="prev">
                  <span class="carousel-control-prev-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleIndicators3" role="button" data-slide="next">
                  <span class="carousel-control-next-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
              </div>
            </div>
            <br/>
            <div class="col-md-4 col-sm-12">
            <hr class="my-3">
              <h5 class="text-shadow"> Components</h5>
              <hr class="my-3">
              <div id="carouselExampleControls4" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner">
                  <div class="carousel-item active">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://2.bp.blogspot.com/-d5PF-eydq78/WQtZbOqsYwI/AAAAAAAAIkA/E_jyk_rXk4g60oukZ4yVH5TrBMT7IFXgACK4B/s320/Asus%2BB350%2BPlus.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Motherboard - ASUS PRIME B350-PLUS</a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_71153/0-761345-05055-5.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Fonte Alim. Antec 550W</a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://static.lvengine.net/aquario/thumb/&w=555&h=555&src=/Imgs/produtos/product_97919/0-761345-10106-6.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Antec ISK110 Vesa-U3 </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <a class="carousel-control-prev" href="#carouselExampleControls4" role="button" data-slide="prev">
                  <span class="carousel-control-prev-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleControls4" role="button" data-slide="next">
                  <span class="carousel-control-next-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
              </div>
            </div>
            <br/>
            <div class="col-md-4 col-sm-12">
            <hr class="my-3">
              <h5 class="text-shadow"> Towers with Components</h5>
              <hr class="my-3">
              <div id="carouselExampleControls5" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner">
                  <div class="carousel-item active">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://2.bp.blogspot.com/-d5PF-eydq78/WQtZbOqsYwI/AAAAAAAAIkA/E_jyk_rXk4g60oukZ4yVH5TrBMT7IFXgACK4B/s320/Asus%2BB350%2BPlus.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Motherboard - ASUS PRIME B350-PLUS </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://1.bp.blogspot.com/-wrxKaUtdJPI/WRNCILD7jhI/AAAAAAAAIpc/mBn7HHLv80wwqALCxpqxeG7c6RxV63upACK4B/s320/Toshiba%2B2TB%2B7200RPM.jpg"
                           height="20" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> HDD - Toshiba 2TB 7200RPM </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://3.bp.blogspot.com/-XSGH_w2pt_U/WQtZ3062d4I/AAAAAAAAIkg/utBZvxuF_UUfCliU9Prjwoovkhpq5-xrgCK4B/s320/MSI%2BRX%2B580%2BGAMING%2BX.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> MSI RX 580 </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <a class="carousel-control-prev" href="#carouselExampleControls5" role="button" data-slide="prev">
                  <span class="carousel-control-prev-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleControls5" role="button" data-slide="next">
                  <span class="carousel-control-next-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
              </div>
            </div>
            <br />
            <div class="col-md-4 col-sm-12">
            <hr class="my-3">
              <h5 class="text-shadow"> Peripherals </h5>
              <hr class="my-3">
              <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner">
                  <div class="carousel-item active">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://images10.newegg.com/ProductImageCompressAll300/23-839-039-02.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> AZIO MK HUE Red USB Backlit Keyboard </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/ABMK_131315093470614500kdOObwcTNO.jpg"
                           height="20" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Mini Numeric Keypad 23Keys</a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="carousel-item">
                    <div id="auctionProfile">
                      <img class="img-fluid"
                           href="#"
                           src="https://images10.newegg.com/NeweggImage/ProductImageCompressAll300/26-104-914-03.jpg" />
                      <div id="infoAuctionProfile"
                           class="container-fluid">
                        <div id="auctionName">
                          <a href="#"
                             class="text-info"> Logitech G602 Black </a>
                        </div>
                        <div id="time-bids"
                             class="row">
                          <ul class="row col-sm-12 list-inline">
                            <li id="timeLeft"
                                class="col-sm-5 mr-sm-1"> 5d 09h </li>
                            <li id="bidsDone"
                                class="col-sm-5"> 14 Bids </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
                  <span class="carousel-control-prev-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
                  <span class="carousel-control-next-icon bg-dark profile-pic" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
@endsection
