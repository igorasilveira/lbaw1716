@extends('layouts.app')

@section('title', $user->username)

@section('content')
  @include('partials.user.profile', ['user' => $user])
  @if (Auth::check())
    @if (Auth::user()->id == $user->id)
      @include('partials.user.modals', ['user' => $user])
    @endif
  @endif
@endsection
