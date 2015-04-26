module WildflyCliAssembler
  def assemble_address(resource)
    address = []

    resource.split('/').each do |token|
      values = token.split('=')
      unless values.empty?
        address << { values[0] => values[1] }
      end
    end

    address
  end

  def assemble_attributes(params)
    attributes = []

    params.split(',').each do |token|
      values = token.split('=')
      attributes << { values[0].strip => values[1].strip }
    end

    attributes.reduce Hash.new, :merge
  end

  def assemble_command(command)
    if command.include? ':'
      path, operation = command.split(':')
    else
      path = '/'
      operation = command
    end

    command = {
      :address => assemble_address(path)
    }

    command.merge assemble_operation(operation)
  end

  def assemble_operation(operation)
    operation.sub!('()', '')

    if operation =~ /^([\w\-]+)$/
      operation_name = Regexp.last_match(1)
    end

    if operation =~ /([\w\-]+)\s+([\w\-]+)/
      operation_name = Regexp.last_match(1)
      attribute_name = Regexp.last_match(2)
    end

    if operation =~ /([\w\-]+)\((.+)\)/
      operation_name = Regexp.last_match(1)
      params = Regexp.last_match(2)
    end

    assembled_operation = { :operation => operation_name }

    unless attribute_name.nil?
      assembled_operation[:name] = attribute_name
    end

    unless params.nil?
      assembled_operation.merge! assemble_attributes(params)
    end

    assembled_operation
  end
end
