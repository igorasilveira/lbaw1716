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
Route::get('/users/{username}', 'ProfileController@show')->name('/users/{username}');
Route::post('/users/{username}/edit', 'ProfileController@edit');
Route::post('/users/{username}/edit/photo', 'ProfileController@editPhoto');
/*Route::get('/users/{id}/add_credits', '')->name('');
Route::post('/users/add_credits/{id}', '');
*/
// Module 2:
//
// Auctions
//Route::get('/search', '')->name('');
Route::get('/category/{category}', 'CategoryController@showAuctionsFromCategory');
Route::get('/auction/new', 'AuctionController@create');
Route::post('/auction/new', 'AuctionController@save')->name('auction_create');
Route::post('/auction/new/preview', 'AuctionController@preview')->name('auction_preview');
Route::get('/auction/{id}', 'AuctionController@show');
Route::post('/auction/buy-now/{id}', 'BidController@buynow');
Route::post('/auction/bid/{id}', 'BidController@bid');
Route::post('/auction/{id}/comments/add', 'CommentController@create');
Route::delete('/auction/{id}/comments/{comID}/remove/', 'CommentController@delete');
/*Route::post('/auction/report/{id}', '');

// Module 3:
//
// Administrative Decisions
Route::get('/admin/auctions', '')->name('');
Route::put('/admin/auction/{id}/approve', '');
Route::put('/admin/auction/{id}/reject', '');
Route::get('/admin/users/{id}', '')->name('');
Route::put('/admin/users/{id}/block', '');
Route::put('/admin/users/{id}/unblock', '');
Route::get('/admin/manage', '')->name('');
Route::post('/admin/manage/moderators/add', '');
Route::delete('/admin/manage/moderators/{id}/remove', '');
Route::post('/admin/manage/categories/add', '');
Route::delete('/admin/manage/categories/{id}/remove', '');

// Module 4:
//
// Notifications
Route::get('/users/{id}/notifications/', '')->name('');
Route::get('/users/{id}/notifications/{notID}', '')->name('');
Route::delete('/users/{id}/notifications/{notID}/remove', '');
*/

// Module 5:
//
// Static Messages
Route::get('/about', 'StaticMessages\StaticController@showAbout');
Route::get('/FAQ', 'StaticMessages\StaticController@showFAQ');
Route::get('/contact', 'StaticMessages\StaticController@showContacts');
