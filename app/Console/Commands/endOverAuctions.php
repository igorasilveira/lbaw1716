<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Auction;
use Carbon\Carbon;

class endOverAuctions extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'endOverAuctions:endauctions';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Change PENDING auction to OVER if has passed limit date';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {

      $now = Carbon::now('Europe/Lisbon');
      $this->info($now);

      $activeAuctions = Auction::where('state', 'Active')
              ->where('limitdate', '<', $now)->get();

      $pendingAuctions = Auction::where('state', 'Pending')
              ->where('limitdate', '<', $now)->get();

      $this->info("Found " . count($activeAuctions) . " auctions that are ACTIVE and past date.");
      $this->info("Found " . count($pendingAuctions) . " auctions that are PENDING and past date.");

      foreach ($activeAuctions as $auction) {
        $this->info("Auction #" . $auction->id . " is ACTIVE and has " . $auction->bids->count() . " bids");
        if($auction->bids->count() > 0) {
            $this->info("Last bid: " . $auction->bids->sortByDesc('date')->first()->value . " Winner: " . $auction->bids->sortByDesc('date')->first()->user_id);
            $auction->update([
              'finaldate' => $now,
              'finalprice' => $auction->bids->sortByDesc('date')->first()->value,
              'auctionwinner' => $auction->bids->sortByDesc('date')->first()->user_id,
              'state' => 'Over'
            ]);
          }
        else {
          $auction->update([
            'refusaldate' => $now,
            'reasonofrefusal' => 'Timeout with no Bids',
            'state' => 'Rejected'
          ]);
        }
        $this->info("Auction Handled");
      }
      foreach ($pendingAuctions as $auction) {
        $this->info("Auction #" . $auction->id . " is PENDING and will be deleted");
        $auction->update([
          'refusaldate' => Carbon::now('Europe/Lisbon'),
          'reasonofrefusal' => 'Timeout with no acceptance',
          'state' => 'Rejected'
        ]);
        $this->info('Auction Handled');
      }
    }
}
