require_relative "classes_view"

class LeftView < ListView
  def initialize( interpreter )
    @interpreter = interpreter
    init_space
    super([ SelectView.new(interpreter) ,
      @space,
      ClassesView.new(interpreter) ])
    interpreter.register_event(:state_changed,  self)
  end

  def init_space
    @space = ObjectView.new( Parfait.object_space , @interpreter , 26)
  end

  def state_changed( old , new_s )
    return unless new_s == :running
    init_space
    replace_at( 1 , @space )
  end

  def draw
    super(".classes")
  end
end


class SelectView < ElementView

  def initialize( interpreter )
    super
    @interpreter = interpreter
    @codes = nil
  end

  def draw
    @element =  div("h4.select", "Code") << (list = div("ul.nav!"))
    list << (div("li.code_list") << div("a.selected" , "none selected"))
    selection_codes unless @codes
    @element << div("br")
    @element << div("br")
  end

  def selection_codes
    @codes = get_codes.keys
    list = div "ul"
    @codes << @codes.first if @codes.length == 1  #otherwise unselectable
    @codes.each do |c|
      code = div("li") << div("a" , c )
      code.style["z-index"] = 10
      code.on("click"){ select(c) }
      list <<  code
    end
    @element.at_css(".code_list") <<  list
  end

  def select( code )
    puts "selecting #{code}"
    machine = Risc.machine.boot
    @interpreter.set_state :stopped
    @element.at_css(".selected").text = code
    ruby = get_codes[code]
    Vool::VoolCompiler.ruby_to_vool( as_main(ruby) )
    machine.objects
    puts "starting"
    @interpreter.start machine.risc_init
  end
  def as_main(statements)
    "class Space ;def main(arg) ; #{statements}; end; end"
  end
  def get_codes
    {set_internal_byte: "return 'Hello'.set_internal_byte(1,75)" ,
     called_if: 'if( 10 ); return "then";else;return "else";end' ,
     hello_world: "h = 'Hello World'.putstring;return h",
     dynamic_call: "a = 150 ; return a.div10",
    }
  end

end