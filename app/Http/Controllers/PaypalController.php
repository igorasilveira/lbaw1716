<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;

use App\User;
use App\Add_Credits;

use Carbon\Carbon;

// Used to process plans
use PayPal\Api\Amount;
use PayPal\Api\Details;
use PayPal\Api\Item;
use PayPal\Api\ItemList;
use PayPal\Api\Payer;
use PayPal\Api\Payment;
use PayPal\Api\RedirectUrls;
use PayPal\Api\Transaction;
use PayPal\Api\ExecutePayment;
use PayPal\Api\PaymentExecution;
use PayPal\Rest\ApiContext;
use PayPal\Auth\OAuthTokenCredential;

class PaypalController extends Controller
{
    private $apiContext;
    private $mode;
    private $client_id;
    private $secret;

    // Create a new instance with our paypal credentials
    public function __construct()
    {
        // Detect if we are running in live mode or sandbox
        if(config('paypal.settings.mode') == 'live'){
            $this->client_id = config('paypal.live_client_id');
            $this->secret = config('paypal.live_secret');
        } else {
            $this->client_id = config('paypal.sandbox_client_id');
            $this->secret = config('paypal.sandbox_secret');
        }

        // Set the Paypal API Context/Credentials
        $this->apiContext = new ApiContext(new OAuthTokenCredential($this->client_id, $this->secret));
        $this->apiContext->setConfig(config('paypal.settings'));
    }

    public function add_credits(Request $request, $username) {

      $value = $request['amount'];
      // Create new payer and method
      $payer = new Payer();
      $payer->setPaymentMethod("paypal");

      // Set redirect urls
      $redirectUrls = new RedirectUrls();
      $redirectUrls->setReturnUrl('http://localhost:8000/users/' . $username . '/add_credits')
        ->setCancelUrl('http://localhost:8000/users/' . $username);

      // Set payment amount
      $amount = new Amount();
      $amount->setCurrency("EUR")
        ->setTotal($value);

      // Set transaction object
      $transaction = new Transaction();
      $transaction->setAmount($amount)
        ->setDescription("PCAuction Credits");

      // Create the full payment object
      $payment = new Payment();
      $payment->setIntent('sale')
        ->setPayer($payer)
        ->setRedirectUrls($redirectUrls)
        ->setTransactions(array($transaction));

        // Create payment with valid API context
        try {
          $payment->create($this->apiContext);

          // Get PayPal redirect URL and redirect user
          $approvalUrl = $payment->getApprovalLink();

          return redirect()->away($approvalUrl);
        } catch (PayPal\Exception\PayPalConnectionException $ex) {
          echo $ex->getCode();
          echo $ex->getData();
          die($ex);
        } catch (Exception $ex) {
          die($ex);
        }
    }

    public function process_payment(Request $request, $username) {

      // Get payment object by passing paymentId
      $paymentId = $request['paymentId'];
      $payment = Payment::get($paymentId, $this->apiContext);
      $payerId = $request['PayerID'];

      // Execute payment with payer id
      $execution = new PaymentExecution();
      $execution->setPayerId($payerId);

      try {
        // Execute payment
        $result = $payment->execute($execution, $this->apiContext);

        $state = $result->getState();
        $amount = $result->getTransactions()[0]->getAmount()->getTotal();
        $request->session()->put('paypal', $state);
        $request->session()->put('paypal_amount', $amount);

        if ($state == "approved") {
          $user = User::get()->where('username', '=', $username)->first();

          $email = $result->getPayer()->getPayerInfo()->getEmail();
          $date = Carbon::now('Europe/Lisbon');
          $userId = $user->id;
          $transactionId = $result->getId();

          $transaction = Add_Credits::create([
            'value' => intval($amount),
            'date' => $date,
            'paypalid' => $email,
            'user' => $userId,
            'trasactionID' => $transactionId,
          ]);
        }

      } catch (PayPal\Exception\PayPalConnectionException $ex) {
        // show error message
        $request->session()->put('paypal', "rejected");

      } catch (Exception $ex) {

        $request->session()->put('paypal', "rejected");
      }

      return redirect('/users/' . $username);
    }

}
