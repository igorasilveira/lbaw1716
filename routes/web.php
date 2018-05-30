<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return redirect('login');
});

Route::get('home', 'Auth\LoginController@showHome');

Auth::routes();

// Module 1 :
//
// Authentication
Route::get('login', 'Auth\LoginController@showLoginForm')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::get('logout', 'Auth\LoginController@logout');
Route::get('register', 'Auth\RegisterController@showRegistrationForm')->name('auth.register');
Route::post('register', 'Auth\RegisterController@register')->name('register');

// Profile
Route::get('users/{username}/auctions', 'ProfileController@auctions');
Route::get('users/{username}/auctions/buying/search', 'SearchController@searchBuying');
Route::get('users/{username}/auctions/selling/search', 'SearchController@searchSelling');
Route::get('users/{username}/manageAuctions', 'ProfileController@manageAuctions');
Route::get('users/{username}/manageAuctions/pending/search', 'SearchController@searchPending');
Route::get('users/{username}/manageAuctions/moderating/search', 'SearchController@searchModerating');
Route::get('/users/{username}', 'ProfileController@show')->name('/users/{username}');
Route::post('/users/{username}/edit', 'ProfileController@edit');
Route::post('/users/{username}/edit/photo', 'ProfileController@editPhoto');
Route::post('/users/{username}/add_credits', 'PaypalController@add_credits');
Route::get('/users/{username}/add_credits', 'PaypalController@process_payment');

// Module 2:
//
// Auctions
Route::get('/search', 'SearchController@searchSystem');
Route::get('/category/{category}', 'CategoryController@showAuctionsFromCategory');
Route::get('/auction/new', 'AuctionController@create');
Route::post('/auction/new', 'AuctionController@save')->name('auction_create');
Route::get('/auction/{id}', 'AuctionController@show');
Route::post('/auction/buy-now/{id}', 'BidController@buynow');
Route::post('/auction/bid/{id}', 'BidController@bid');
Route::post('/auction/{id}/comments/add', 'CommentController@create');
Route::delete('/auction/{id}/comments/{comID}/remove/', 'CommentController@delete');

Route::get('/quickwins','SearchController@quickwins');
Route::get('/endingsoonest','SearchController@endingsoonest');
Route::get('/newlylisted','SearchController@newlylisted');
Route::get('/mostbids','SearchController@mostbids');
Route::get('/lowestprice','SearchController@lowestprice');
Route::get('/highestprice','SearchController@highestprice');
//Route::post('/auction/report/{id}', '');

// Module 3:
//
// Administrative Decisions
Route::get('/admin/manage', 'AdminController@show');
Route::get('/admin/auction/{id}/approve', 'AdminController@approveAuction');
Route::post('/admin/auction/{id}/reject', 'AdminController@rejectAuction');
Route::delete('/admin/manage/moderators/{username}/remove', 'AdminController@deleteModerator');
Route::delete('/admin/manage/categories/{id}/remove', 'AdminController@deleteCategory');
Route::post('/admin/manage/moderators/{username}/add', 'AdminController@addModerator');
Route::post('/admin/manage/categories/add', 'AdminController@addCategory');
Route::get('/admin/users/{id}/block', 'AdminController@blockUser');
Route::get('/admin/users/{id}/unblock', 'AdminController@unblockUser');


// Module 4:
//
// Notifications
Route::get('/users/{username}/notifications/', 'NotificationController@list');
Route::get('/users/{username}/notifications/{id}', 'NotificationController@show');
Route::delete('/users/{username}/notifications/{id}/remove', 'NotificationController@delete');


// Module 5:
//
// Static Pages
Route::get('/about', 'StaticMessages\StaticController@showAbout');
Route::get('/FAQ', 'StaticMessages\StaticController@showFAQ');
Route::get('/contact', 'StaticMessages\StaticController@showContacts');
