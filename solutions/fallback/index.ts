import { ethers } from "ethers";
import dotenv from "dotenv";

dotenv.config();
import { Fallback } from "../../contracts/types/Fallback";
import { abi as CONTRACT_ABI } from "../../contracts/artifacts/Fallback.sol/Fallback.json";

const main = async () => {
    const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
    const wallet = ethers.Wallet.fromPhrase(
        process.env.WALLET_SEED_PHRASE as string
    ).connect(provider);

    const contractAddress = "0x1a4F8E869ab819813cC3ca26bF53FcDBc22DAD94";

    const contract = new ethers.Contract(
        contractAddress,
        CONTRACT_ABI,
        wallet
    ) as unknown as Fallback;

    const tx = await contract.contribute({
        value: "1",
    });
    console.log("tx send: ", tx.hash);

    await tx.wait();
    console.log("tx confirmed");

    const tx2 = await wallet.sendTransaction({
        to: contractAddress,
        value: "1",
    });

    console.log("tx send: ", tx2.hash);

    await tx2.wait();
    console.log("tx confirmed");

    const tx3 = await contract.withdraw();
    console.log("tx send: ", tx3.hash);
    await tx3.wait();
    console.log("tx confirmed");
};

main().catch((e) => {
    console.error("TOP LEVEL ERROR:", e);
    process.exit(1);
});
