@extends('layouts.app')

@section('content')
  @include('partials.notification',['notification' => $notification])
@endsection
