# swapExactTokensForTokens

**Useful links**:

- [Documentation](https://docs.uniswap.org/contracts/v2/reference/smart-contracts/router-02#swapexacttokensfortokens)
- [Contract code](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L224-L237)
- [Dune](https://dune.com/queries/3132585?from_block_t6c1ea=18000000)

<br>

```
function swapExactTokensForTokens(
  uint amountIn,
  uint amountOutMin,
  address[] calldata path,
  address to,
  uint deadline
) external returns (uint[] memory amounts);
```

According to the documentation, this function takes the exact amount of tokens,
specified by the first address in `path` array, and exchange for tokens, set by
the last address in `path`, to a **maximum possible** amount. It's signature 
and ABI encoded selector are:

```
// Solidty function signature
swapExactTokensForTokens(uint256,uint256,address[],address,uint256)

// ABI encoded selector
0x38ed1739
```

<br>

## Parsing swap data

Let's decode the swap parameters from the following transaction data:

```JavaScript
{
    blockHash: '0xeaa5fa21298133a61270bdf9bd396fcbb2f3e61ece321ff3420f467d33c918ed',
    blockNumber: '0x118c116',
    hash: '0x7b09f7399aae4c62266135162269da209b4e35b242609c839839dabe25f90fb9',
    accessList: [],
    chainId: '0x1',
    from: '0x0a880998fd7fc411aab94818d022f326020f097b',
    gas: '0x493e0',
    gasPrice: '0x3b693548b',
    input: '0x38ed1739000000000000000000000000000000000000000000000000027f7d0bdb92000000000000000000000000000000000000000000000000c8485ce9f6871725535a00000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000a880998fd7fc411aab94818d022f326020f097b000000000000000000000000000000000000000000000000000000006533eba00000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000085df7a5dd129d5a21bf4bde1e6511f775a593ba2',
    maxFeePerGas: '0x48cacbd00',
    maxPriorityFeePerGas: '0x5f5e100',
    nonce: '0x71',
    r: '0xf7b66b0e4535097edf7cde69187253efaef1eee8cf3eb9a0903ce84c3e5347cb',
    s: '0x3a65af1ce3dd19b24e6ecb97d8481a019a8ae00bafb9eb170c3000a05582b098',
    to: '0x7a250d5630b4cf539739df2c5dacb4c659f2488d',
    transactionIndex: '0x45',
    type: '0x2',
    v: '0x0',
    value: '0x0'
}
```

Slicing the selector and splitting up the calldata by 32 byte chunks let's show
call data components:

```MD
0x38ed1739
// amountIn
000000000000000000000000000000000000000000000000027f7d0bdb920000
// amountOutMin
00000000000000000000000000000000000000000000c8485ce9f6871725535a
// data location, always same
00000000000000000000000000000000000000000000000000000000000000a0
// recipient of tokens
0000000000000000000000000a880998fd7fc411aab94818d022f326020f097b
// deadline (unix timestamp)
000000000000000000000000000000000000000000000000000000006533eba0
// array of addresses (gte 2)
0000000000000000000000000000000000000000000000000000000000000002
// --- token 0 address
000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
// --- token 1 address
00000000000000000000000085df7a5dd129d5a21bf4bde1e6511f775a593ba2
```

What means that user is swapping the `0x27f7d0bdb920000` amount of WETH tokens
(the address `0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2`) to maximum possible
amount of tokens (contract address `0x85df7a5dd129d5a21bf4bde1e6511f775a593ba2`)
expecting the output to be not less then `c8485ce9f6871725535a`. In case if out
amount is less, the call would revert.

A naive implementation of a parsing function may look like the following, small
note that each byte of the callData is encoded with two hex nibbles, in case if
instead of the hex string the byte array is parsed, indexes should be converted
using the rule `2 * i - 2`:

```JavaScript
function parseSwapExactTokenForToken(callData) {
    return {
        amountIn: BigInt(`0x${txData.slice(10, 74)}`),
        amountOutMin: BigInt(`0x${txData.slice(74, 138)}`),
        tokens: txData.slice(394).match(/.{64}/g).map(a => a.slice(-40)),
    }
}
```

<br>

## Example of using callData

As an example let's group up a selection of transactions by the input token.
Corresponding Dune query is available [here](https://dune.com/queries/3132609/5225377?from_block_t6c1ea=18000000):

```SQL
select 
    pair,
    count(hash) as c
from (
    select
        -- parse out the address of the token used for the exchange
        bytearray_substring(data, 197, 32) as pair,
        hash
    from ethereum.transactions
    where block_number > {{from_block}}
    and bytearray_starts_with(data, 0x38ed1739)
)
group by pair
order by c desc
limit 12
```

<br>
<br>
<br>
<br>
