@extends('layouts.app')

@section('content')
  @include('partials.searchResults',['results' => $results])
@endsection
