<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use App\Comment;
use App\Auction;
use Illuminate\Http\Request;
use Carbon\Carbon;


class CommentController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request)
    {
        if (!Auth::check()) {
            return redirect('/login');
        }

        $now = new Carbon('Europe/Lisbon');

        $comment = Comment::create([
          'date' => $now,
          'description' => $request['description'],
          'auctioncommented' => $request['id'],
          'usercommenter' => Auth::user()->id,
        ]);

        return redirect()->action(
          'AuctionController@show', ['id' => $request['id']]
        );
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Comment  $comment
     * @return \Illuminate\Http\Response
     */
    public function show(Comment $comment)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Comment  $comment
     * @return \Illuminate\Http\Response
     */
    public function edit(Comment $comment)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Comment  $comment
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Comment $comment)
    {
        //
    }

    /**
    * Remove the specified resource from storage.
    *
    * @param  \App\Comment  $comment
    * @return \Illuminate\Http\Response
    */
    public function delete(Request $request)
    {
      if (!Auth::check()) {
        return redirect('/login');
      } else if (Auth::id() == Comment::find($request['comID'])->usercommenter) {
        self::destroy(Comment::find($request['comID']));
      }
      return redirect()->action(
          'AuctionController@show', ['id' => $request['id']]
      );
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Comment  $comment
     * @return \Illuminate\Http\Response
     */
    public function destroy(Comment $comment)
    {
        $comment->delete();
    }
}
