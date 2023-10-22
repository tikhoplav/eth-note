# swapTokensForExactTokens

**Useful links**:

- [Documentation](https://docs.uniswap.org/contracts/v2/reference/smart-contracts/router-02#swaptokensforexacttokens)
- [Contract code](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L238-L251)
- [Dune](https://dune.com/queries/3132927)

<br>

```Solidity
function swapTokensForExactTokens(
  uint amountOut,
  uint amountInMax,
  address[] calldata path,
  address to,
  uint deadline
) external returns (uint[] memory amounts)
```

This function swaps into exact amount set by `amountOut` of tokens, with
contract address last in the `path` array, using **as few as possible** input
tokens, with address first in the `path`. It's signature and ABI selector are:

```
// Solidity function signature
swapTokensForExactTokens(uint256,uint256,address[],address,uint256)

// ABI encoded selector
0x8803dbee
```

<br>

## Parsing swap data

Let's use the following tx to show the example of parsing swap data:

```JavaScript
{
    blockHash: '0xae40d166802cfa513da212a1bd2cf326d18a907cd06e072e71d9753300f896ce',
    blockNumber: '0x118c29c',
    hash: '0x8526e922ff60008a8ff7455479cc43beb3d69663cb6ad4a5e41ea67db4604bcf',
    chainId: '0x1',
    from: '0x29bbc2b5aff41a2143f7d28fe6944453178f1473',
    gas: '0x632ea0',
    gasPrice: '0x5597d3df6',
    input: '0x8803dbee000000000000000000000000000000000000000001847d128301c3d3a94080000000000000000000000000000000000000000000000000001c576b7f9a7d46d400000000000000000000000000000000000000000000000000000000000000a000000000000000000000000029bbc2b5aff41a2143f7d28fe6944453178f147300000000000000000000000000000000000000000000000000000000653402050000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000008e6cd950ad6ba651f6dd608dc70e5886b1aa6b24',
    nonce: '0xaf4',
    r: '0xb89b87eea83ca95fc4d9415bde3cc4dab6ecefd1085c380b8b44db185ab36b0c',
    s: '0x4db5bff476fa69c0d5f3d638858dca7b615ddc5e7e8ad05583c390394818953e',
    to: '0x7a250d5630b4cf539739df2c5dacb4c659f2488d',
    transactionIndex: '0x3a',
    type: '0x0',
    v: '0x25',
    value: '0x0'
}
```

Aligning the data slots (by 32 bytes) considering the selector and prefix:

```
0x8803dbee
// amount out
000000000000000000000000000000000000000001847d128301c3d3a9408000
// amount in max
0000000000000000000000000000000000000000000000001c576b7f9a7d46d4
// location of data
00000000000000000000000000000000000000000000000000000000000000a0
// recipient address
00000000000000000000000029bbc2b5aff41a2143f7d28fe6944453178f1473
// deadline (unix timestamp)
0000000000000000000000000000000000000000000000000000000065340205
// length of path array
0000000000000000000000000000000000000000000000000000000000000002
// --- token address 0
000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
// --- token address 1
0000000000000000000000008e6cd950ad6ba651f6dd608dc70e5886b1aa6b24
```

Which means that user expects to get the exact amount `1847d128301c3d3a9408000`
of token `8e6cd950ad6ba651f6dd608dc70e5886b1aa6b24` when exchanging some amount
of token `c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2` (WETH), but not more then
`1c576b7f9a7d46d4`.

A naive implementation of a parsing function may look like the following, note
that each byte of the callData is encoded with two hex nibbles, in case if
instead of the hex string the byte array is parsed, indexes should be converted
using the rule `2 * i - 2`:

```JavaScript
function parseSwapTokensForExactTokens(callData) {
  return {
    amoutOut: BigInt(`0x${callData.slice(10, 74)}`),
    amountInMax: BigInt(`0x${callData.slice(74, 138)}`),
    tokens: callData.slice(394).match(/.{64}/g).map(a => a.slice(-40))
  }
}
```

> TODO:: Add the example of resolving pair addresses using `path` from callData

<br>

## Example of using callData

As an example let's find all transaction from a period, which led to swap some
amount of some token to some amount of WETH, you can find example at [dune](https://dune.com/queries/3132954):

> Note: this query shows only transaction where the direct swap token to WETH
> is available. However it is possible that swap was performed through some
> intermediate token, like X -> Y -> WETH. To find those the third address of
> `path` should be filtered instead.

```SQL
select
    -- parse the amount out and sum up
    sum(
        bytearray_to_uint256(
            bytearray_substring(data, 5, 32)
        )
    ) as total
from ethereum.transactions
where block_number > {{from_block}}
and bytearray_starts_with(data, 0x8803dbee)
-- filter all swaps to WETH
-- 5 for slector
-- skip 7 slots of 32 bytes
and bytearray_substring(data, 5 + 7 * 32, 32) = 0x000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
```

<br>

## Parsing the response

> TODO:: add example of a response and it's parsing

<br>
<br>
<br>
<br>