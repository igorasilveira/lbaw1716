@extends('layouts.app')

@section('title', $user->username)

@section('content')
  @include('partials.user.profile', ['user' => $user])
@endsection
