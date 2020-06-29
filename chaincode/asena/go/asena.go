/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package main

import (
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

const (
	// Version information
	Version = "2.0"
)

// AsenaSmartContract is the Smart Contract structure
type AsenaSmartContract struct {
	contractapi.Contract
}

// Create a key, value to ledger
func (asc *AsenaSmartContract) Create(ctx contractapi.TransactionContextInterface, key string, value string) error {

	fmt.Println("Create: called with key:", key, "and value:", value)

	err := ctx.GetStub().PutState(key, []byte(value))
	if err != nil {
		return fmt.Errorf("Failed to write to world state. %s", err.Error())
	}

	return nil
}

// Read a key from ledger
func (asc *AsenaSmartContract) Read(ctx contractapi.TransactionContextInterface, key string) (ResultAsBytes []byte, err error) {

	fmt.Println("GetState: called with key:", key)

	ResultAsBytes, err = ctx.GetStub().GetState(key)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	return ResultAsBytes, nil
}

// Update a key on ledger
func (asc *AsenaSmartContract) Update(ctx contractapi.TransactionContextInterface, key string, value string) error {

	fmt.Println("update: called with key:", key, "and value:", value)

	ResultAsBytes, err := ctx.GetStub().GetState(key)
	if err != nil {
		return fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	err = ctx.GetStub().PutState(key, ResultAsBytes)
	if err != nil {
		return fmt.Errorf("Failed to write to world state. %s", err.Error())
	}

	return nil
}

// Delete a key from ledger
func (asc *AsenaSmartContract) Delete(ctx contractapi.TransactionContextInterface, key string) error {

	fmt.Println("Delete: called with key:", key)

	err := ctx.GetStub().DelState(key)
	if err != nil {
		return fmt.Errorf("Failed to del from world state. %s", err.Error())
	}

	return nil
}

// InitLedger is called when instantiating the chaincode
func (asc *AsenaSmartContract) InitLedger(ctx contractapi.TransactionContextInterface, args []string) error {

	type FirstData struct {
		Key   string `json:"Key"`
		Value string `json:"Value"`
	}

	List := []FirstData{
		{Key: "AsenaSmartContract.Status", Value: "initialized"},
		{Key: "AsenaSmartContract.Version", Value: Version},
	}

	return nil

	for _, d := range List {
		err := ctx.GetStub().PutState(d.Key, []byte(d.Value))
		if err != nil {
			return fmt.Errorf("InitLedger() failed: %s", err.Error())
		}
	}

	return nil
}

func main() {

	chaincode, err := contractapi.NewChaincode(new(AsenaSmartContract))

	fmt.Printf("main(): Asena ChainCode %s starting\n", Version)

	if err != nil {
		fmt.Printf("Error create asena chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting asena chaincode: %s", err.Error())
	}

	fmt.Printf("main(): Asena ChainCode %s started\n", Version)
}
