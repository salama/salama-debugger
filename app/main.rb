require 'opal'
require "opal/parser"

require "salama"
require "interpreter"

require 'opal-react'

require "class_view"
require "register_view"
require "source_view"
require "block_view"
require "debugger"

require 'opal-jquery'

Document.ready? do  # Document.ready? is a opal-jquery method.
  machine = Virtual.machine.boot
  React.render( React.create_element( Debugger , :machine => machine ),  Element['#content']    )
end
