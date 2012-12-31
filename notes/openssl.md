---
layout: note
title: OpenSSL
excerpt: No matter how many times I use openssl or ssh-keygen, I can never remember the damn syntax...
promote: true
last_modified: 2012-06-12 13:37:00 -0500
---
#### Generate SSH Authentication Keys

    ssh-keygen -b 4096 -t rsa

#### Certificate Signing

##### Conventions

 * .key = Private Key (Encrypted or Unencrypted)
 * .enc = Encrypted Private Key
 * .csr = Certificate Signing Request
 * .crt = Signed Public Certificate from Authority
 * .cer = Signed Public Certificate from Authority, alternative extension
 * .p12 = PKCS12 Bundle (both Private Key and Signed Public Certificate)

##### Create a New Key

    openssl genrsa -des3 -out ssl.domain.com.key 4096

##### Generate Certificate Signing Request

    openssl req -new -key ssl.domain.com.key -out ssl.domain.com-`date +%Y%m%d`.csr

##### Strip Pass Phrase from Private Key

    cp ssl.domain.key ssl.domain.key.enc
    openssl rsa -in server.key.enc -out server.key

##### Verify MD5 Outputs

    openssl rsa -noout -modulus -in ssl.domain.key | openssl md5
    openssl x509 -noout -modulus -in ssl.domain.crt 2>/dev/null | openssl md5

##### Export To PKCS12 Bundle

    openssl pkcs12 -export -in ssl.domain.com-`date +%Y%m%d`.crt -inkey ssl.domain.com.key -out ssl.domain.com-`date +%Y%m%d`.p12
