# ETH note

This is the collection of notes related to Ethereum blockchain.

<br>

## Deployment

For better UX the notes are organized with `mdbook`. To start browsing notes
the book needs to be deployed.

<br>

### Deploy with docker

The easiest way to deploy the book is to run the following command from the
project' root directory:

```
docker compose up
```

This would build up the docker image, build the documentation and start the
local server available at `http://localhost:3000`.

> Note: Cargo dependencies are stored in the docker volume in order to minimize
> consecutive build time. If you don't care about loading dependecies or disk
> space needs to be preserved, disable `cache` directory volume mounting.

<br>

### Native deployment

This requires `cargo` and `mdbook` installed at the host system. Run the
following command to start the server available at `http://localhost:3000`:

```
mdbook --serve open
```

<br>
<br>
<br>
<br>
