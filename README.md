## Foundry

**A simple swap contract deployed to sepolia.**

It forks ethereum sepolia and impersonates accounts to interact on the network.

Find the deployed contract here:  https://sepolia.etherscan.io/address/0x6c3303e3eeea79709802ca090617adf0ad0151e6

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### to run test: 

```shell
$ forge test --rpc-url <sepolia url> --evm-version paris -vvvvv
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
