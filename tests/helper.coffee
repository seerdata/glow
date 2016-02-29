# Copyright (c) 2015 Vault12, Inc.
# MIT License https://opensource.org/licenses/MIT
chai             = require 'chai' # http://chaijs.com/ BDD/TDD assertion lib
# https://github.com/domenic/chai-as-promised/ extends Chai w/asserts, promises
chaiAsPromised   = require 'chai-as-promised'
CryptoStorage    = require 'crypto_storage'
SimpleTestDriver = require 'test_driver'

Utils             = require 'utils'

# uncomment, should we need to bundle q-xhr into tests.js:
# (leave in as an example usage)
# window.Q = require('q-xhr')(window.XMLHttpRequest, require('q'))

# make mocha use source maps; the programmatic way
# (we prefer to have tests as close to prod as possible, so we load this through a <script>)
# require('source-map-support').install
#   handleUncaughtExceptions: false

# initializes should and as-promised interfaces
chai.should()
chai.use chaiAsPromised

if localStorage
  drv = new SimpleTestDriver('tests', {})

  # prevent problems on test reruns after failed tests
  k = (localStorage.key(i) for i in [0...localStorage.length])
  Utils.map k, (x) -> localStorage.removeItem x if x? and x.includes drv._root_tag

  # Start crypto storage stystem with simple localStorage driver
  CryptoStorage.startStorageSystem drv

# Testing configurations.
# host points to known Zax server(s). To set up your own Zax server, see the
# instructions at https://github.com/vault12/zax#installation

# select a preset (local vs remote) or edit your own settings
localTest = true

if localTest
  # local testing
  window.__globalTest =
    host: 'http://localhost:8080'
    offline: false
    timeouts:
      tiny: 500
      mid: 1000
      long: 5000
else
  # internet testing
  window.__globalTest =
    host: 'https://zax_test.vault12.com'
    offline: false
    timeouts:
      tiny: 50000
      mid: 130000
      long: 500000

# control which tests to run
window.__globalTest.runTests =
  'utils':            true
  'nacl':             true
  'crypto':           true
  'keyring':          true
  # 'mailbox':          true
  # 'relay session':    true
  # 'relay low level':  true
  # 'relay wrapper':    true
  # 'relay bulk':       true
  # 'relay invites':    true
  # 'relay stress':     true
  # 'relay ratchet':    true
  # 'relay noise ratchet': true
  #
  # 'relay race':       false


# In tests you can directly access window.Utils, window.Mailbox, etc.
# from the console
window.__CRYPTO_DEBUG = true
