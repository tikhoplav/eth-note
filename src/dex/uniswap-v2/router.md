# Uniswap V2 Router

**Useful links**:
- [Documentation](https://docs.uniswap.org/contracts/v2/reference/smart-contracts/router-02)
- [Contract code](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol)
- [Dune](https://dune.com/workspace/library/Uniswap%20V2%20Router)

> After listening for couple hundreds pending transactions it seems like the
> overwhelming majority of swap requests goes through the Router contract.
> However the data showing the amount of direct requests is yet to be shown.

According to documentation the main purpose of the router contract is to guide
the user swap through multiple pair contracts and simplify the swap process for
the end user, however direct calls to Pair contracts are more interesting due
to lower gas usage.

<br>

## Active contracts

At the moment of writing this document the multiple implementations of the
Router contract are detected at the Ethereum mainnet. Those addresses should be
used to filter out pending swaps, along side with pair addresses to detect
direct swaps. Those addresses are:

```
0x7a250d5630b4cf539739df2c5dacb4c659f2488d // Official Uniswap V2 router
```

<br>

## Parsing swap arguments

According to contract code there are 9 function that can be used to perform a 
swap (selector, link to detail page - link to contract code):

- [`0x38ed1739`](./router/swap_exact_tokens_for_tokens.md) - [`swapExactTokensForTokens`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L224-L237);
- [`0x8803dbee`]() - [`swapTokensForExactTokens`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L238-L251);
- [`0x`]() - [`swapExactETHForTokens`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L252-L266);
- [`0x`]() - [`swapTokensForExactETH`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L267-L283);
- [`0x`]() - [`swapExactTokensForETH`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L284-L300);
- [`0x`]() - [`swapETHForExactTokens`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L301-L317);
- [`0x`]() - [`swapExactTokensForTokensSupportingFeeOnTransferTokens`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L339-L355);
- [`0x`]() - [`swapExactETHForTokensSupportingFeeOnTransferTokens`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L356-L378);
- [`0x`]() - [`swapExactTokensForETHSupportingFeeOnTransferTokens`](https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol#L379C14-L400);
