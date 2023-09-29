# frozen_string_literal: true

class String
  def column_of(index)
    return 1 if index.zero?

    newline_index = rindex("\n", index - 1)
    if newline_index
      index - newline_index
    else
      index + 1
    end
  end

  def line_of(index)
    self[0...index].count("\n") + 1
  end

  unless method_defined?(:blank?)
    def blank?
      self == ''
    end
  end

  # The following methods are lifted from Facets 2.0.2
  def tabto(n)
    if self =~ %r{^( *)\S}
      # Inlined due to collision with ActiveSupport 4.0: indent(n - $1.length)
      m = n - $1.length
      if m >= 0
        gsub(%r{^}, ' ' * m)
      else
        gsub(%r{^ {0,#{-m}}}, '')
      end
    else
      self
    end
  end

  def treetop_camelize
    to_s.gsub(%r{/(.?)}) { "::#{$1.upcase}" }.gsub(%r{(^|_)(.)}) { $2.upcase }
  end
end
