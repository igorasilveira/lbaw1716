@extends('layouts.app')

@section('title', $user->username . "\'s Auction")

@section('content')
  @include('partials.user.auctions', ['user' => $user])
@endsection
