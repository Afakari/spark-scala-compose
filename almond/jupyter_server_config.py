c = get_config()  #noqa
# test
c.PasswordIdentityProvider.hashed_password = 'argon2:$argon2id$v=19$m=10240,t=10,p=8$pdaPTfKkW+AvT+4QFBW0+A$tjXnkuif9fHSRShQrOFWOh975ORpbfOhSpPjizx5bSg'
c.PasswordIdentityProvider.password_required = True
c.IdentityProvider.token = ""
