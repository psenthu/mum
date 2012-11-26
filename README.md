mum
===

Money User Management


API
===

Authenticate with multiple providers

Add Funds

Transfer funds to friends/family

Charge user

GET User Auth Token
===================

via console:

# Get the first user
@user = User.first

# Create new authentication token
@user.reset_authentication_token!

# Get authentication token
@user.authentication_token