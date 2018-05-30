<?php

namespace App\Providers;

use Illuminate\Support\Facades\Gate;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use App\Auction;
use App\Bid;
use App\User;
use App\Notification;
use App\Policies\AuctionPolicy;
use App\Policies\BidPolicy;
use App\Policies\UserPolicy;
use App\Policies\NotificationPolicy;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The policy mappings for the application.
     *
     * @var array
     */
    protected $policies = [
      'App\Auction' => 'App\Policies\AuctionPolicy',
      'App\Bid' => 'App\Policies\BidPolicy',
      'App\User' => 'App\Policies\UserPolicy',
      'App\Notification' => 'App\Policies\NotificationPolicy'
    ];

    /**
     * Register any authentication / authorization services.
     *
     * @return void
     */
    public function boot()
    {
        $this->registerPolicies();
    }
}
