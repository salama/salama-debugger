class SourceView

  include React::Component

  define_state :source

  def render
    div :class => :row  do
      "Virtual Machine Instruction".span
      source.name
    end
  end

end
