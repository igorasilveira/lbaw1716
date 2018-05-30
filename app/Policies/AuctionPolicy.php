<?php

namespace App\Policies;

use App\User;
use App\Auction;
use Illuminate\Auth\Access\HandlesAuthorization;
use Illuminate\Support\Facades\Auth;

class AuctionPolicy
{
  use HandlesAuthorization;

  /**
  * Determine whether the user can view the auction.
  *
  * @param  \App\User  $user
  * @param  \App\Auction  $auction
  * @return mixed
  */
  public function view(User $user, Auction $auction)
  {
    if($user->typeofuser=='Normal'){

      if($auction->state == 'Active')
      return true;
      else
      if($auction->state == 'Over' && ($user->id == $auction->auctioncreator || $user->id == $auction->auctionwinner) )
      return true;
      else
      if($auction->state == 'Pending' && ($user->id == $auction->auctioncreator) )
      return true;
      else
      return false;


      //return $this->auth->guest();

    }else {
      return true;
    }

  }

  /**
  * Determine whether the user can create auctions.
  *
  * @param  \App\User  $user
  * @return mixed
  */
  public function create(User  $user)
  {
    return Auth::check();
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

  public function approveOrReject(User $user, Auction $auction)
  {
    if($user->typeofuser=='Moderator' || $user->typeofuser=='Administrator'){

      if($auction->state == 'Pending')
      return true;
      else {
        return false;
      }
    }else {
      return false;
    }

  }


  public function bidOrBuy(User $user, Auction $auction)
  {
    if($user->typeofuser=='Normal'){

      if($auction->state == 'Active'){

        if($user->id == $auction->auctioncreator){
          return false;
        }else {
          return true;
        }

      }else {
        return false;
      }

    }else {
      return false;
    }
  }
