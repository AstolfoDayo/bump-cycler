require("dotenv").config();

import {UserResolvable} from "discord.js-selfbot-v13";

import {Client} from 'discord.js-selfbot-v13';
const client = new Client();

client.on('ready', async () => {
    console.log(`${client.user?.username} is ready!`);
    schedule();
})

function schedule(): void {
    // Disboard
    setInterval((): void => {
        runDisboardCommand();

        // 2 hours and a little bit of delay for safety
    }, 2 * 60 * 60 * 1000 + 10 * 1000);

    // Dissoku
    setInterval((): void => {
        runDissokuCommand();

        // 1 hour and a little bit of delay for safety
    }, 60 * 60 * 1000 + 10 * 1000);
}

function runDissokuCommand(): void {
    client.channels.fetch("1140977346590023751").then((channel: any): void => {
        client.users.fetch("761562078095867916").then((bot: UserResolvable) => {
            channel.sendSlash(bot, "dissoku up");
        })
    });
}

function runDisboardCommand(): void {
    client.channels.fetch("1140977346590023751").then((channel: any): void => {
        client.users.fetch("302050872383242240").then((bot: UserResolvable) => {
            channel.sendSlash(bot, "bump");
        })
    });
}

client.login(process.env.DISCORD_TOKEN);