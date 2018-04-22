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
    protected $redirectTo = '/home';

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
        return Validator::make($data, [
            'username' => 'required|string|max:255|unique:user',
            'email' => 'required|string|email|max:255|unique:user',
            'password' => 'required|string|min:6|confirmed',
        ]);
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
        $country = Country::find($data['country']);
        global $city;
        //echo City::where('name', $data['city'])->get();
        if (0 == City::where('name', $data['city'])->count()) {
            $city = new City();
            $city->name = $data['city'];
            $city->country = $country->id;
            $city->save();
        } else {
            $city = City::where('name', $data['city']);
        }

        $user = User::create([
         'typeofuser' => 'Normal',
         'username' => $data['username'],
         'email' => $data['email'],
         'password' => bcrypt($data['password']),
         'compName' => $data['compName'],
         'phoneNumber' => $data['phoneNumber'],
         'birthDate' => $data['birthDate'],
         'city' => $city->first()->id,
         'address' => $data['address'],
       ]);

        $file = $user->id . '.' . $request->file('photo')->getClientOriginalExtension();

        $request->file('photo')->move(
                base_path() . '/public/images/catalog/', $file
          );
        $file_name = '/public/images/catalog/' . $imageName;

        $user->update(['pathtophoto' => $file_name]);

        return $user;
    }

    public function register(Request $request)
    {
        return auth()->login($this->create($request, $request->all()));
    }

    public function showRegistrationForm()
    {
        return view('auth.register');
    }
}
