@extends('layouts.app')

@section('title', $auction->name)

@section('content')
  @include('partials.auction', ['auction' => $auction])
@endsection
