#!/bin/bash

set -e

if [ "$SOLIDITY_COVERAGE" = true ]; then
  npm run test && cat coverage/lcov.info | ./node_modules/coveralls/bin/coveralls.js
else
  yarn test test/DTCrowdsale.js test/DTPresale.js test/DTToken.js test/WhitelistedCrowdsale.js
  GEN_TESTS_TIMEOUT=400 GEN_TESTS_QTY=40 yarn test test/DTPresaleGenTest.js test/DTCrowdsaleGenTest.js
fi
