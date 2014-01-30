Facter.add('last_puppet_time') do
  setcode do
    require 'puppet'
    ymf = YAML::load_file('/var/opt/lib/pe-puppet/state/last_run_report.yaml')
    ymf.time
  end
end
