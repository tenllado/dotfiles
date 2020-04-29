# Msmtp setup for GMail with OAuth2

I write this file to document the process to configure msmtp to access a GMail
account using OAuth2 authentication.

I needed this to access the account of the University I work for, that uses the
GMail infrastructure. The problem with these institutional GMail accounts is
that you don't have the option to create application specific keys, as I can for
instance do on my personal GMail account. You are left with two options (if you
want to use msmtp), or you enable *Less secure app access* or you use OAuth2
credentials. This document describes how you can do that.

I have tested it on a Debian 10 system, but compiling the 1.8.8 version from
source, as I had permission problems with the stable and testing msmtp packages
for the passwordeval script which I could not figure out how to solve.

## Configuring msmtp

To use the oauth2 credential with gmail you have to use the oauthbearer
authentication method and use the passwordeval key to run a script that is able
to generate a valid token for that credential. You can use the outh2token script
from this repository for the latter. A configuration template for using it is as
follows:
```
defaults
host smtp.gmail.com
port 587
protocol smtp
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account <account-name>
auth oauthbearer
from <gmail-address>
user <gmail-address>
passwordeval ~/.config/msmtp/oauth2token <gmail-address> <att-name>
```


The oauth2token script assumes that you store the client-id, client-secret and
refresh keys (see below how to obtain them) in the system's keyring, using the
<att-name> string as attribute name. Once you have them you can store them on
the keyring with secret-tool:
```
secret-tool store --label=<the-label-you-like> <att-name> client-id
secret-tool store --label=<the-label-you-like> <att-name> client-secret
secret-tool store --label=<the-label-you-like> <att-name> refresh
```

The oauth2token is just a wrapper on the oauth2.py (
https://github.com/google/gmail-oauth2-tools/blob/master/python/oauth2.py). It
uses the oauth2.py to get a token (using the secrets stored in the keyring) only
if the last token stored (again in the keyring) has not expired, with a
threshold of 1 minute.

## The OAuth2 credentials

To get this working, you first need to create the OAuth2 credentials. You do
that creating a project in https://console.developers.google.com/ , you activate
the GMail API for that project and add the credentials for that API, and you
copy the client-id and client-secret codes from that credential.

Once you have done that, you have to download the oauth2.py script from
https://github.com/google/gmail-oauth2-tools/blob/master/python/oauth2.py. At
the top of that script you find a large comment explaining how to use it. From
the three steps described you **only need to do the first one**, and only once.
The second step will be performed by oauth2token when needed, and the third one
is never needed, as msmtp requires the raw token key.

To perform the first step you can do:
```
oauth2 --user=3Dxxx@gmail.com --client_id=<the client-id> \
	--client_secret=<the client-secret> --generate_oauth2_token
```

The result is the refresh key. The oauth2token script assumes that you have
stored it in the keyring, so go ahead and run:

```
secret-tool store --label=<the-label-you-like> <att-name> refresh
```

and you give it the refresh key obtained from the oauth2 script.

Once this is done, msmtp will use the oauth2token script to generate the token
needed to authenticate, getting a new one when the last used token has expired.

## Notes on possible modifications

The oauth2token script gets the client-id, client-secret, refresh key and token
from the system's keyring. You might not want to use this method for whatever
reason. For instance you may prefer to encrypt the keys with gpg on your file
system and just use the gpg tool to decrypt them. You can adapt the oauth2token
script to do that.
