![Squidex Logo](https://raw.githubusercontent.com/Squidex/squidex/master/media/logo-wide.png "Squidex")

# Squidex Samples

Multiple Docker Definitions for Squidex are located here: https://github.com/Squidex/squidex-docker

## How to make feature requests, get help or report bugs? 

Please join our community forum: https://support.squidex.io


## Steps:

1. Copy `_env` to `.env` and change secrets. Notes - password requirements are strict: minimum 8 characters (one capital letter, one special character and one number at least)
2. Edit `.env` file and replace the value in `SQUIDEX_ADMINPASSWORD` parameter by running a bash command `openssl rand -base64 16`
3. Note: after several incorrect login attempts the account may get locked out
4. Note: user login may not work in Google Chrome try Firefox.
