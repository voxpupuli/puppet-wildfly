def deploy_status(artifact_name)
  %x( sh jboss-cli.sh -c --command='/deployment=#{artifact_name}:read-attribute(name=content)' )
end

def extract_current_content_sha1(result)
  bytes_regex = /bytes {(.*) }/m

  match_data = bytes_regex.match(result)

  unless match_data.nil? || match_data == 0

    bytes = match_data[1]
    byteArray = bytes.split(',').map(&:strip).map(&:hex)
    byteArray.pack('C*').unpack('H*').first

  end

end

def new_content_sha1(artifact_name)
  %x( sha1sum /tmp/#{artifact_name} ).split(' ')[0]
end

def undeploy(artifact_name)
  puts "Undeploying #{artifact_name}..."
  %x( sh jboss-cli.sh -c --command='undeploy #{artifact_name}' )
end

def deploy(artifact_name)
  puts "Deploying #{artifact_name}..."
  %x( sh jboss-cli.sh -c --command='deploy /tmp/#{artifact_name}' )
end

artifact_name = ARGV[0]

current_content_sha1 = extract_current_content_sha1(deploy_status(artifact_name))

if current_content_sha1.nil?
  puts deploy(artifact_name)
  exit($?.exitstatus)
elsif current_content_sha1 != new_content_sha1(artifact_name)
  puts undeploy(artifact_name)
  undeploy_exit_code = $?

  if undeploy_exit_code == 0
    puts deploy(artifact_name)
    exit($?.exitstatus)
  else
    exit(undeploy_exit_code.exitstatus)
  end

end
