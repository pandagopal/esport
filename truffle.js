module.exports = {
    networks: {
        development: {
            host: 'localhost',
            port: 8545,
            network_id: '*',
            gasPrice: 22000000000
          },
        development: {
            host: process.env.LOCAL_RPC__ADDRESS || "localhost",
            port: process.env.LOCAL_RPC__PORT || 8545,
            network_id: process.env.LOCAL_RPC__NETWORK || "*",
            gas: 2900000
        },
        dev: {
            host: "dt-api-dev.dreamteam.gg/eth-nw",
            port: 80,
            gas: 2900000,
            network_id: 15
        },
        qa: {
            host: "dt-api-qa.dreamteam.gg/eth-nw",
            port: 8545,
            gas: 2900000,
            network_id: 15
        },
        stage: {
            host: "dt-api-stage.dreamteam.gg/eth-nw",
            port: 8545,
            gas: 2900000,
            network_id: 15
        },
        live: {
            network_id: 1
        }
    }
};