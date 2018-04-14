<?php

namespace App\Http\Controllers\StaticMessages;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class StaticController extends Controller
{
  /**
  * Show the about page.
  *
  * @return \Illuminate\Http\Response
  */
  public function showAbout()
  {
    return view('pages/about');
  }

  /**
  * Show the FAQ page.
  *
  * @return \Illuminate\Http\Response
  */
  public function showFAQ()
  {
    return view('pages/FAQ');
  }

  /**
  * Show the FAQ page.
  *
  * @return \Illuminate\Http\Response
  */
  public function showContacts()
  {
    return view('pages/contacts');
  }
}
