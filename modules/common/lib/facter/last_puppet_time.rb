require 'puppet'

Facter.add('last_puppet_time') do
  setcode do
    report = Puppet.settings[:lastrunreport]
    ymf = YAML::load_file(report)
    ymf.time
  end
end
