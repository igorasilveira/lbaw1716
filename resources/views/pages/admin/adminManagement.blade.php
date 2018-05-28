@extends('layouts.app')

@section('content')
  @include('partials.admin.adminManagement',['moderators' => $moderators, 'categories' => $categories])
@endsection
