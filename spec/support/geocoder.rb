module Geocoder

  Geocoder.configure(:lookup => :test)

  Geocoder::Lookup::Test.set_default_stub([{  'latitude'     => 40.8145142,
                                              'longitude'    => -73.4898338,
                                              'address'      => '3 Pond Drive, Syosset, NY, 11791, USA',
                                              'state'        => 'New York',
                                              'state_code'   => 'NY',
                                              'country'      => 'United States',
                                              'country_code' => 'US' }])
end