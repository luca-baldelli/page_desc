$LOAD_PATH.unshift("#{__dir__}/page_desc")
$LOAD_PATH.unshift(__dir__)

require 'capybara'

require 'ext/string'
require 'session'
require 'browser'
require 'action'
require 'types/element'
require 'types/clickable'
require 'element_generator'
require 'element'
require 'section'
require 'page'
