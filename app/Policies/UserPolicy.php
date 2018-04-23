<?php

namespace App\Policies;

use App\User;
use App\Auction;
use Illuminate\Auth\Access\HandlesAuthorization;

class UserPolicy
{
    use HandlesAuthorization;

    /**
     * Determine whether the user can view some parts of the profiles.
     *
     * @param  \App\User  $user
     * @return mixed
     */
    public function view(User $user)
    {
      if (!Auth::check()) return false;
      return Auth::user()->id == $user->id;
    }

    /**
     * Determine whether the user can create auctions.
     *
     * @param  \App\User  $user
     * @return mixed
     */
    public function create(User $user)
    {
        //
    }

    /**
     * Determine whether the user can update the auction.
     *
     * @param  \App\User  $user
     * @param  \App\Auction  $auction
     * @return mixed
     */
    public function update(User $user, Auction $auction)
    {
        //
    }

    /**
     * Determine whether the user can delete the auction.
     *
     * @param  \App\User  $user
     * @param  \App\Auction  $auction
     * @return mixed
     */
    public function delete(User $user, Auction $auction)
    {
        //
    }
}
