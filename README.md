# StravaAPI

Learning how to use the Strava API w/Objective-C

[Documentation](http://developers.strava.com)

## Notes for getting started

I had to begin by creating a Strava application  

[Create Strava application](https://developers.strava.com)  

I had to login using my own Strava account.  Once I logged in and attempted to create an account, I needed to have the following information:

* Email: My personal email
* Callback URL (Domain only): I used my own domain
* An icon app image which I just created really quickly using preview.

Once I finished this, I was able to get my Client ID and Client Secret.

## Using Token

To make things easy, the code I have is using the Strava access token.  This will save me the time from having to do the Oauth 2 dance.  This token gives public read only access.

## Project notes

This project uses both AFNetworking and NSURLSession to make networking calls.  The dual api clients that I have created both conform to the StravaAPI protocol which makes swapping them out very simple.  This can be observed in `ViewController`.

The weak/strong self dance is not required for the networking calls as they are being made.  To prove that there are not any block retain cycles, I have added logs in dealloc methods in `ViewController`, `StravaAPIAFClient` and `StravaAFIClient`.  I also placed the `View Controller` in a navigation stack to show that everything is being deallocated when the `ViewController` is being dismissed.
