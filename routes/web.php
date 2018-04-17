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
Route::get('login', 'Auth\LoginController@showLoginForm')->name('auth.loginMenu');
Route::post('login', 'Auth\LoginController@login')->name('login');
Route::post('logout', 'Auth\LoginController@logout');
Route::get('register', 'Auth\RegisterController@showRegistrationForm')->name('auth.register');
Route::post('register', 'Auth\RegisterController@register')->name('register');
/*
// Profile
Route::get('/users/{id}', '')->name('');
Route::get('/users/{id}/edit', '')->name('');
Route::post('/users/edit/{id}', '');
Route::get('/users/{id}/add_credits', '')->name('');
Route::post('/users/add_credits/{id}', '');

// Module 2:
//
// Auctions
//Route::get('/', '')->name('');
Route::get('/search', '')->name('');*/
Route::get('/{category}', 'CategoryController@showAuctionsFromCategory');
Route::get('/auction/new', 'AuctionController@create')->name('');
Route::post('/auction/add', 'AuctionController@save')->name('/auction/add');
Route::get('/auction/{id}', 'AuctionController@show');
Route::post('/auction/buy-now/{id}', 'AuctionController@buynow');
Route::post('/auction/bid/{id}', 'AuctionController@bid');
/*Route::post('/auction/{id}/comments/add', '');
Route::delete('/auction/{id}/comments/{comID}/remove/', '');
Route::post('/auction/report/{id}', '');

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
