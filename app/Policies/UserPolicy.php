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
    public function view(User $user, User $user2)
    {
      /*if (!Auth::check()) return false;
      return Auth::user()->id == $user->id;*/
      return $user->id == $user2->id;
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

    public function adminPowers(User $user)
    {
        if($user->typeofuser=='Administrator')
        return true;
        else
        return false;
    }

    public function checkIfNotAdmin(User $user,User $user2)
    {
        if($user2->typeofuser=='Moderator')
        return true;
        else
        return false;
    }

    public function checkIfCanBlock(User $user,User $user2)
    {
        if($user->typeofuser=='Moderator' || $user->typeofuser=='Administrator'){

          if($user2->typeofuser=='Normal')
            return true;
            else {
              return false;
            }
        }else
          return false;
    }
}
