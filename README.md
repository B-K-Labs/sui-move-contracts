# BOTP - from BlocKey Labs Sui Contracts

## Open letter 

Dear SUI Foundation,

Thank you for your quick reminder. We are writing to discuss our case regarding the next steps in our grant proposal process.

Currently, we are in the process of migrating our contract from the EVM to Move language for SUI network, and everything is still under development. At this point, we have not yet completed or deployed any Move contracts on the SUI network.

Given this, could we request that our proposal evaluation continue? We are fully committed to open-sourcing our Move smart contract repositories immediately upon deployment to the SUI network.

We are working diligently to develop the Move contracts on the SUI network, and we greatly appreciate your support with this grant to help us swiftly bring our solution to go live on SUI and also contribute to the growth of the SUI ecosystem.

Thank you for your understanding, and we look forward to your guidance on the next steps.

Best regards,

BlocKey Labs.

## Overview
This project contains a set of Sui Move smart contracts for BOTP - BlocKey Labs. It utilizes the Sui blockchain and Move language to BOTP solution.

## Contracts
The following Move modules are included in this project:

- **ModuleName1**: Description of the module, its purpose, and what it does.
- **ModuleName2**: Description of the module, its purpose, and what it does.
- **ModuleName3**: Description of the module, its purpose, and what it does.

## Installation and Setup

To set up the project locally, follow these steps:

1. **Install Sui CLI**:
    ```bash
    sui client install
    ```

2. **Clone the repository**:
    ```bash
    git clone https://github.com/your-repo/move-sui-contracts.git
    cd move-sui-contracts
    ```

3. **Build the contracts**:
    ```bash
    sui move build
    ```

4. **Test the contracts**:
    ```bash
    sui move test
    ```

5. **Publish the package**:
    ```bash
    sui client publish --gas-budget [amount]
    ```

## Contract Details

### Module: ModuleName1

- **Functions**:
    - `function_name_1`: Description of the function, parameters, and return type.
    - `function_name_2`: Description of the function, parameters, and return type.
  
- **Structs**:
    - `StructName1`: Explanation of the struct and its fields.
    - `StructName2`: Explanation of the struct and its fields.

### Module: ModuleName2

- **Functions**:
    - `function_name_1`: Description of the function, parameters, and return type.

- **Structs**:
    - `StructName1`: Explanation of the struct and its fields.

## Usage

### Interacting with the Contracts
To interact with the contracts, use the following commands:

1. **Call a function**:
    ```bash
    sui client call --function [function_name] --package [package_address] --args [arguments] --gas-budget [gas_amount]
    ```

2. **Transfer assets**:
    ```bash
    sui client transfer --to [receiver_address] --amount [amount] --gas-budget [gas_amount]
    ```

## Testing
Run the unit tests using the following command:

```bash
sui move test
