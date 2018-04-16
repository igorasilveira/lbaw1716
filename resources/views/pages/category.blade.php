@extends('layouts.app')

@section('title', $category->name)

@section('content')
  @include('partials.category', ['category' => $category])
@endsection
