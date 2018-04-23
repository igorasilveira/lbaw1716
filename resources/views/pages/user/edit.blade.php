@extends('layouts.app')

@section('title', $user->username)

@section('content')
  @include('partials.user.edit', ['user' => $user])
@endsection
