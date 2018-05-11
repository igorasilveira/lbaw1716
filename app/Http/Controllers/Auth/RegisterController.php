<?php

namespace App\Http\Controllers\Auth;

use App\User;
use App\Country;
use App\City;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Http\Request;

class RegisterController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;

    /**
     * Where to redirect users after registration.
     *
     * @var string
     */
    protected $redirectTo = 'home';

    /**
     * Create a new controller instance.
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param array $data
     *
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param array $data
     *
     * @return \App\User
     */
    protected function create(Request $request, array $data)
    {

        $validator = $request->validate([
            'username' => 'required|string|max:255|unique:user',
            'completeName' => 'required|string|max:255',
            'phoneNumber' => 'required|string|max:25',
            'birthDate' => 'required|string|date|min:10|max:10',
            'city' => 'required|string|min:3',
            'address' => 'required|string|min:5|max:255',
            'email' => 'required|string|email|max:255|unique:user',
            'password' => 'required|string|min:6|confirmed',
            'photo' => 'image|mimes:jpg,png',
        ]);

        $country = Country::find($data['country']);
        $city;
        //echo City::where('name', $data['city'])->get();
        if (0 == City::where('name', $data['city'])->count()) {
            $GLOBALS['city'] = new City();
            $GLOBALS['city']->name = $data['city'];
            $GLOBALS['city']->country = $country->id;
            $GLOBALS['city']->save();
        } else {
            $GLOBALS['city'] = City::where('name', $data['city'])->firstOrFail();
        }

        $user = User::create([
         'typeofuser' => 'Normal',
         'username' => $data['username'],
         'email' => $data['email'],
         'password' => bcrypt($data['password']),
         'completename' => $data['completeName'],
         'phoneNumber' => $data['phoneNumber'],
         'birthDate' => $data['birthDate'],
         'city' => $city->first()->id,
         'address' => $data['address'],
       ]);

       $filename = "";

       if ($request->file('photo')) {
         $file = $user->id.'.'.$request->file('photo')->getClientOriginalExtension();

         $request->file('photo')->move(
           base_path().'/public/images/catalog/users/', $file
         );
         $file_name = '/images/catalog/users/'.$file;
       } else {
         $file_name = '/images/catalog/users/default.png';
       }

        $user->update(['pathtophoto' => $file_name]);

        return $user;
    }

    public function register(Request $request)
    {
        auth()->login($this->create($request, $request->all()));
        return redirect('/');
    }

    public function showRegistrationForm()
    {
        return view('auth.register');
    }
}
