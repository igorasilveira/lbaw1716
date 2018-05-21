<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use App\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function list()
    {
        return view('pages.notifications');
    }

    /**
     * Display the specified resource.
     *
     * @param \App\Notification $notification
     *
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request)
    {
        $notification = Notification::find($request['id']);
        $notification->_read = true;
        $notification->save();

        return view('pages.notification', ['notification' => $notification]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param \App\Notification $notification
     *
     * @return \Illuminate\Http\Response
     */
    public function edit(Notification $notification)
    {
    }

    /**
     * Update the specified resource in storage.
     *
     * @param \Illuminate\Http\Request $request
     * @param \App\Notification        $notification
     *
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Notification $notification)
    {
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param \App\Notification $notification
     *
     * @return \Illuminate\Http\Response
     */
    public function delete(Request $request)
    {
        if (!Auth::check()) {
            return redirect('/login');
        } elseif (Auth::id() == Notification::find($request['id'])->authenticated_userid) {
            self::destroy(Notification::find($request['id']));
        }

        return redirect()->action('NotificationController@list',['username' => Auth::user()->username]);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param \App\Notification $notification
     *
     * @return \Illuminate\Http\Response
     */
    public function destroy(Notification $notification)
    {
        $notification->delete();
    }
}
