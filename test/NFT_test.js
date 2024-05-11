const {
    time,
    loadFixture,
} = require("nomicfondation/hardhat-network-helpers");
const { anyValue } = require("nomicfondation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFT tests", () => {

    describe("Mint test", () => {
        it("mints correctly", async () => {
            const accounts = await ethers.getSigners();
            let contracts = await ethers.getContractFactory("NFT",accounts[0]);
            let deployContract = await contract.deploy();
            deployContract = await deployContract.deployed();
            
             expect(await deployContract.totalSupply()).to.equal(0);
            
        })
    })
})