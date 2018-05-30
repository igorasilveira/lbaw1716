@extends('layouts.app')

@section('content')
  @include('partials.lateralSearch',['results' => $results])
@endsection
